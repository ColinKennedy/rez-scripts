rez-scripts is a small, TD-focused extension of
[Rez](https://github.com/nerdvegas/rez).

Rez is a great tool but, for developers, it can be a bit hard to work
without a little tooling. This repository provides some nice scripts to
do just that.


# Why rez-scripts
Rez installs all of its packages into your
[local_packages_path](https://github.com/nerdvegas/rez/wiki/Configuring-Rez#local_packages_path)
(usually it's the "~/packages" folder). For casual work, this is fine. But if
you work on many tickets over time, or even multiple tickets at once, your
previously-built packages will start interfering with whatever packages you're
trying to build now.

The goal of this repository is to provide a wrap of Rez that will give you an
isolated environment that will give you "just the WIP changes you're working on
and nothing else". Here's how it works:


# System Requirements
- [Rez](https://github.com/nerdvegas/rez)
- [git](https://github.com/git/git)
- bash (as an executable shell)
- various core tools, like `cd`, `dirname`, and the like (you probably already have them)


# Environment Requirements
- The Rez package you want to call commands on must be in a git repository
  (keep reading for more details)


# Installation
```sh
git clone https://github.com/ColinKennedy/rez-scripts
echo "export PATH=$PWD/rez-scripts/bin:\$PATH" >> ~/.profile
echo "export PERSONAL_CONFIG_FILE=$PWD/rez-scripts/python/rezconfig.py" >> ~/.profile
# Make a new terminal
```

The echo lines make sure, whenever a terminal starts up, the commands are
visible to Linux. If you use a different file on start-up than ~/.profile, make
sure to adjust those commands as needed.


# Quick Explanation
The 2 main details of this repository are

- All of the executable scripts, located in [bin](bin)
- This configuration file, [python/rezconfig.py](python/rezconfig.py)

Each executable in [bin](bin) is designed to build, resolve, and do everything
from a custom folder path (which you can customize if needed) instead of the
regular ~/packages folder.  This path is auto-generated, **based on your
current git repository name**. In practice, that means these executables
require your Rez package to be inside of a git repository in order to work.

You may be wondering what the rezconfig.py is for. The rezconfig.py is what
tells Rez to start looking for git repository branch names. It's basically the
back-end that enables the executables in [bin](bin) to work.


# Commands
## bin/rb
It works exactly like ``rez-build`` but builds to a work area location, instead
of to ~/packages.  It also will take into account any previously released
packages, so if there are rez-conflicts or any issues with your build, you'll
see them when you call ``rb``. This is fantastic because it lets you address
any potential problems prior to doing a ``rez-release``!


## bin/re
A thin wrap around ``rez-env`` with the following features.

- Creates resolves based on your work area
- Auto-includes your current directory's Rez package name, if it exists

The second point is a time-saver just so you don't have to write ``re
foo_package`` all of the time if you're already working on foo_package's
folder.


## bin/ro
If you have already called ``rb`` at least once and would like to open your
installed package.py, run this command to get a path to wherever your package
was installed to.


## bin/rp
It's very common while working with these commands to call ``rb`` and then
quickly a way to send replicate this environment for other users for testing.

Calling ``ro`` will return a REZ_PACKAGES_PATH setting which will replicate
your work area.

You can use this to copy to your clipboard, for easy copy / pasting

```sh
rp | clipboard
```


## bin/rt
This command wraps `rez-test`. Here's what it can do

Call all non-explicit Rez test commands, for the current package
```sh
cd /path/to/some/rez/package
rt
```

Call a specific test
```sh
cd /path/to/some/rez/package
rt unittests_python_2
```

Call a suite of tests with a similar name
```sh
cd /path/to/some/rez/package
rt ^unittests_python_.*
```


## bin/rte
Similar to rt but, instead of calling the rez-test commands, it generates a
``rez-env`` command. The environment ``rez-env`` uses will be "your current
package + and dependencies from your rez-test". This is a huge time-saver if
your packages have lots of dependencies per-test and you need to get into one
of your tests to run some kind of command. If your resolve times for a rez-test
are slow, this can be an even bigger time-saver because you only need to
resolve once.


```sh
# Assuming you have a package with these rez-test keys
#
# ["isort", "pydocstyle", "pylint", "unittests_python_2", "unittests_python_3"]
#
cd /path/to/some/rez/package
rte unittest_python_2  # Creates an environment with your package + "unittest"
rte py.*  # Your package + all requiremesnt for "pylint" + "pydocstyle" rez-tests
rte u.*2  # Your package + the "unittests_python_2" environment
```


## rcd
If you are in a folder which is somewhere within a Rez package and you want to
quickly cd into the root directory, you can call ``rcd`` to do it. ``rcd`` is 
actually an alias which you need to separately set up.

To add this alias, run this:

```sh
echo "alias rcd=\`$PWD/rez-scripts-bin/_rcd\`" >> ~/.bashrc  # Bash users
echo "alias rcd=\`$PWD/rez-scripts-bin/_rcd\`" >> ~/.zshrc  # Zsh users
```


# Setup
These tools assume that you are using Rez in a git environment. Make
sure to name your git branch something sensible. For example, if you
work off of tickets in Jira and your project key is "AS", naming a
branch like "AS-1234-some_description" is a good idea.

Your branch name doubles as your workspace name. So keep it descriptive!


# Customizations
Every command in this repository works based on a work area. By default, the
root path for all work area folders is "~/work_area".

You can change this folder location by setting ``$PERSONAL_WORK_AREA``

```sh
export PERSONAL_WORK_AREA=~/some/custom/location
```
