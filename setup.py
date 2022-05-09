from setuptools import setup

setup(
    name = "remote-control-server",
    version = "1.0.0",
    install_requires=[
        "requests",
        "typer"
    ],
    scripts=[
        "main.py"
    ]
)
