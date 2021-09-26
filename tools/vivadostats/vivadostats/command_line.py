import argparse
from jinja2 import Environment, PackageLoader, select_autoescape
import logging
import numpy as np
from pathlib import Path
import pandas as pd
import re
import shutil
import subprocess
import sys
from typing import List

def guess_dtype(val: str):
    """Guess dtype for given string value.

    Args:
        val (str): String whose dtype to guess.

    Returns:
        dtype: Guessed dtype fo value
    """
    if re.match('[+-]?\d*\.\d+', val):
        return float
    elif re.match('[+-]?\d+', val):
        return int
    else:
        return str

def command(command: List[str], *args, input=None, check=True, stdin=subprocess.DEVNULL, out=sys.stdout, **kwargs):
    """Run a command and log its output.

    Args:
        command (List[str]): Command to execute.
        input (str): Command input. Defaults to None.
        stdin: Defaults to subprocess.DEVNULL.

    Raises:
        subprocess.CalledProcessError: Raised if command return code is non-zero.
    """
    if isinstance(command, list):
        print('> ' + ' '.join(command), file=out, flush=True)
    else:
        print('> ' + str(command), file=out, flush=True)

    # See:
    #   https://www.endpoint.com/blog/2015/01/28/getting-realtime-output-using-python

    if input:
        stdin = subprocess.PIPE

    p = subprocess.Popen(command, *args,
                         stdin=stdin,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.STDOUT,
                         **kwargs)

    if input:
        p.stdin.write(input)
        p.stdin.close()

    while True:
        output = p.stdout.readline()
        if output == b'' and p.poll() is not None:
            break
        if output:
            print(output.decode(), end='', file=out, flush=True)

    p.wait()
    if check and p.returncode != 0:
        raise subprocess.CalledProcessError(returncode=p.returncode, cmd=command)

def run(files, tempdir=Path("temp"), output=Path("."), **kwargs):
    tempdir.mkdir(exist_ok=True)

    # Copy RTL
    rtl_dir = tempdir / 'rtl'
    rtl_dir.mkdir(exist_ok=True)

    rtl_files = []

    for file in files:
        rtl_dest = rtl_dir / file.name
        shutil.copyfile(str(file), str(rtl_dest))
        rtl_files.append(rtl_dest)

    # Create output directory
    output.mkdir(exist_ok=True)

    top_name= rtl_files[0].stem

    # Search for best frequency
    df = search(tempdir, rtl_files, **kwargs)
    logging.debug(df)
    df.to_csv(output / (top_name + '_clock.csv'), index=False)

    output_dir = tempdir / 'output'

    df = read_timing_table(output_dir / 'post_route_timing_summary.rpt', 'Intra Clock Table')
    logging.debug(df)
    df.to_csv(output / (top_name + '_timing.csv'), index=False)

    df = read_table(output_dir / 'post_route_util.rpt', 'Slice Logic', drop_columns=[r'Util%'])
    logging.debug(df)
    df.to_csv(output / (top_name + '_util.csv'), index=False)

def search(tempdir, rtl_files, once=False, clock_period=2, delta_thresh=0.01, clock_thresh=0.01, dry_run=False, **kwargs):
    output_dir = tempdir / 'output'

    f = (tempdir / 'synth.log').open('w')

    # Attempted clocks
    items = []

    wns = None
    wpws = None
    delta = 0

    # Invariant: clock_period_lo guarantees we fail timing.
    clock_period_lo = 0

    # Invariant: clock_period_hi guarantees we meet timing OR clock_period_hi is
    # 0 (we haven't yet met timing).
    clock_period_hi = 0

    while True:
        if wns is not None:
            # Determine time delta, the minimum of WPS and WPWS
            delta = min(wns, wpws)

            # If time delta is positive and under the threshold, or if the
            # difference between clock_period_hi and clock_period_lo is small,
            # we've met the timing requirements
            if delta >= 0 and delta < delta_thresh or (clock_period_hi != 0 and clock_period_hi - clock_period_lo < clock_thresh):
                break

            # If delta is positive, try a tighter timing
            if delta >= 0:
                clock_period_hi = clock_period

                new_clock_period = clock_period_lo + (clock_period_hi - clock_period_lo) / 2.0
                delta_clock_period =  clock_period - delta

                # If subtracting delta gives a clock period that we know is too
                # small, use binary search.
                if delta_clock_period > clock_period_lo and delta_clock_period < new_clock_period:
                    clock_period = delta_clock_period
                else:
                    clock_period = new_clock_period
            else:
                clock_period_lo = clock_period

                new_clock_period = clock_period_lo + (clock_period_hi - clock_period_lo) / 2.0
                delta_clock_period =  clock_period - delta

                # If subtracting delta gives a clock period that we know is too
                # big, use binary search.
                if delta_clock_period > new_clock_period and delta_clock_period < clock_period_hi:
                    clock_period = delta_clock_period
                else:
                    clock_period = new_clock_period

        logging.debug("Clock period: now=%f; delta=%f; low=%f; high=%f",
                      clock_period, delta, clock_period_lo, clock_period_hi)

        if not dry_run:
            synthesize(tempdir,
                       clock_period=clock_period,
                       rtl_files=rtl_files,
                       log=f,
                       **kwargs)

        df = read_timing_table(output_dir / 'post_route_timing_summary.rpt', 'Intra Clock Table')

        wns = df.iloc[0]['WNS(ns)']
        whs = df.iloc[0]['WHS(ns)']
        wpws = df.iloc[0]['WPWS(ns)']

        items.append((clock_period, wns, whs, wpws))

        logging.debug("WNS: %f; WHS: %f; WPWS: %f", wns, whs, wpws)

        # If we were asked to only run the synthesis loop once, stop
        if once:
            break

    df = pd.DataFrame(items, columns=['clock_period', 'wns', 'whs', 'wpws'])
    return df

def synthesize(tempdir,
               part="xc7vx485tffg1761-2",
               clock_period=2,
               top='main',
               rtl_files=None,
               log=sys.stdout):
    # Create TCL script and constraints file
    env = Environment(loader=PackageLoader('vivadostats'),
                      autoescape=select_autoescape())

    rtl_files = [file.relative_to(tempdir) for file in rtl_files]

    params = { 'part': part
             , 'clock_period': clock_period
             , 'input_delay': 0.1*clock_period
             , 'output_delay': 0.5*clock_period
             , 'top': top
             , 'rtl_top': rtl_files[0]
             , 'rtl_files': rtl_files
             }

    template = env.get_template('script.tcl.j2')
    with (tempdir / 'script.tcl').open('w') as f:
        f.write(template.render(**params))

    template = env.get_template('constraints.xdc.j2')
    with (tempdir / 'constraints.xdc').open('w') as f:
        f.write(template.render(**params))

    # Create output directory
    output_dir = tempdir / 'output'

    if output_dir.exists():
        shutil.rmtree(str(output_dir))

    output_dir.mkdir(exist_ok=True)

    # Run Vivado
    command(['vivado', '-mode', 'batch', '-source', 'script.tcl'], cwd=str(tempdir), out=log)

def create_dataframe(headings, rows, drop_columns=[]):
    df = pd.DataFrame(columns=headings, data=rows)

    col_dtypes = [guess_dtype(col) for col in rows[0]]
    dtypes = dict(zip(headings, col_dtypes))

    for col in drop_columns:
        del df[col]
        del dtypes[col]

    for col, dtype in dtypes.items():
        if dtype == int:
            df[col] = df[col].replace(r'^\s*$', 0, regex=True)
        elif dtype == float:
            df[col] = df[col].replace(r'^\s*$', np.nan, regex=True)

    df = df.astype(dtype=dtypes, errors='ignore', copy=False)

    return df

def read_table(path, header, **kwargs):
    with path.open('r') as f:
        text = f.read()

    return extract_table(header, text, **kwargs)

def extract_table(header, text, **kwargs):
    m = re.search(r'^\d+\.\s+%s\s*\n\-+\s*(.*?)\n\n\n' % header, text, re.M|re.S)
    if not m:
        return None

    lines = m.group(1).splitlines()

    # Find headings
    headings = re.split(r'\s*\|\s*', lines[1])

    # First and last columns are empty due to delimiter
    headings = headings[1:-1]

    # Collect rows
    rows = []

    for line in lines[3:]:
        cols = re.split(r'\s*\|\s*', line)
        cols = cols[1:-1]

        if len(cols) >= len(headings):
            rows.append(cols)

    if len(rows) == 0:
        return None

    return create_dataframe(headings, rows, **kwargs)

def read_timing_table(path, header, **kwargs):
    with path.open('r') as f:
        text = f.read()

    return extract_timing_table(header, text, **kwargs)

def extract_timing_table(header, text, **kwargs):
    m = re.search(r'^-+\n\|\s+%s(.*?)\n\n\n' % header, text, re.M|re.S)
    if not m:
        return None

    lines = m.group(0).splitlines()

    # Find headings
    headings = re.split(r'\s\s+', lines[5])

    # Trim empty columns
    while re.match(r'^\s*$', headings[-1]):
        headings = headings[:-1]

    # Collect rows
    rows = []

    for line in lines[7:]:
        cols = re.split(r'\s\s+', line)
        if len(cols) >= len(headings):
            cols = cols[:len(headings)]
            rows.append(cols)

    if len(rows) == 0:
        return None

    return create_dataframe(headings, rows, **kwargs)

def main():
    parser = argparse.ArgumentParser(description="Vivado statistics",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-d', '--debug', action='store_const', const=logging.DEBUG,
                        dest='loglevel',
                        default=logging.WARNING,
                        help='print debugging information')
    parser.add_argument('-v', '--verbose', action='store_const', const=logging.INFO,
                        dest='loglevel',
                        help='be verbose')
    parser.add_argument('-n', '--dry-run', action='store_true',
                        default=False,
                        help='dry run')
    parser.add_argument('--clock-period', type=float,
                        default=2.0,
                        help='clock period')
    parser.add_argument('--once', action='store_true',
                        default=False,
                        help='only run loop once')
    parser.add_argument('--top',
                        default='main',
                        help='top component')
    parser.add_argument('--tempdir',
                        default='temp',
                        help='temporary directory')
    parser.add_argument('-o', '--output',
                        default='.',
                        help='output directory')
    parser.add_argument(dest='files',
                        nargs='+',
                        metavar='FILE',
                        help='VHDL source')

    args = parser.parse_args()

    logging.basicConfig(format='%(asctime)s:%(name)s:%(levelname)s:%(message)s',
                        level=args.loglevel)

    run([Path(file) for file in args.files],
        tempdir=Path(args.tempdir),
        output=Path(args.output),
        once=args.once,
        clock_period=args.clock_period,
        top=args.top,
        dry_run=args.dry_run)

    #extracts_stats(Path("temp/output"))
