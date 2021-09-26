from setuptools import setup

setup(
    name='vivadostats',
    author='Geoffrey Mainland',
    author_email='mainland@drexel.edu',
    description='Vivado statistics',
    long_description='',
    packages=['vivadostats'],
    package_data={
        'vivadostats': ['templates/*.j2'],
    },
    entry_points = {
        'console_scripts': ['vivadostats=vivadostats.command_line:main'],
    },
    version='0.1',
    install_requires=[ 'Jinja2'
                     , 'pandas'
                     ]
)
