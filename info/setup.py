from setuptools import setup

setup(
    name="dockerinfo",
    version="0.6",
    description="Show information about docker container",
    py_modules=["dockerinfo"],
    install_requires=["bottle"],
    entry_points = {
        "console_scripts": ["dinfo=dockerinfo:infoserver"]
    }
)
