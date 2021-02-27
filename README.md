rez-scripts is a small, TD-focused extension of
[Rez](https://github.com/nerdvegas/rez).

Rez is a great tool but, for developers, it can be a bit hard to work
without a little tooling. This repository provides some nice scripts to
do just that.


# Requirements
- [Rez](https://github.com/nerdvegas/rez)
- [git](https://github.com/git/git)
- bash (as an executable shell)
- various core tools, like `cd`, `dirname`, and the like (you probably already have them)


# Installation
```sh
git clone https://github.com/ColinKennedy/rez-scripts
echo "export PATH=$PWD/rez-scripts/bin:\$PATH" >> ~/.profile
# Make a new terminal
```

The echo line makes sure, whenever a terminal starts up, the commands
are visible to Linux.


# Quick Explanation
Every command in this repository works based on a work area. In this
case, "work area" just means "a dedicated folder where changes are built
to". The work area has the same as your local git branch, which means
the work area functions even if you modify Rez packages located in
different git repositories. As long as the branch name is consistent,
everything works.


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

Call a range of tests
```sh
cd /path/to/some/rez/package
rt unittests_python_.*
```


## bin/rte
Similar to rt but, instead of calling the rez-test commands, it calls
rez-env **with** the same environment of the rez-test commands that
you've chosen.

This can be a huge time saver when you're trying to debug a failing test
and you don't want to wait to resolve over and over again. Or you want
to run a command within a test environment which isn't the same command
as the one that you've defined in your ``tests`` attribute.

```sh
# Assuming you have rez-test keys
#
# ["isort", "pydocstyle", "pylint", "unittests_python_2", "unittests_python_3"]
#
cd /path/to/some/rez/package
rte unittest_python_2  # Creates an environment with your package + "unittest"
rte py.*  # Your package + all requiremesnt for "pylint" + "pydocstyle" rez-tests
rte u.*2  # Your package + the "unittests_python_2" environment
```


## bin/rbs
A rez-build wrapper which builds your package to a scratch workspace.
This command is designed to isolate your environment. Your environment
will only ever be the centralized Rez packages that come with your
environment + your local changes. This is a great way to make sure your
changes work in isolation before doing a release. ``re``, ``rt``, and
``rte`` also respect this workspace location so you can very easily
run any combination of these commands and be sure that you have an
environment that only contains the changes that you want to test and
nothing else.

```sh
cd /path/to/some/rez/package
rbs
```


## rb
A variation of ``rbs`` which includes a ``--symlink`` flag, which can
be used to tell Rez to only symlink built packages, instead of copying.
Your build system needs to respect that flag for this command to be
useful. Otherwise, use ``rbs``.


# Setup
These tools assume that you are using Rez in a git environment. Make
sure to name your git branch something sensible. For example, if you
work off of tickets in Jira and your project key is "AS", naming a
branch like "AS-1234-some_description" is a good idea.

Your branch name doubles as your workspace name. So keep it descriptive!


# Customization
Every command in this repository works based on a work area. In this
case, "work area" just means "a dedicated folder".

You can change this folder by setting ``$PERSONAL_WORK_AREA``

```sh
export PERSONAL_WORK_AREA=~/some/custom/location
```

If ``$PERSONAL_WORK_AREA`` is not defined, ``~/scratch`` is used as a fallback.
