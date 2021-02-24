rez-scripts is a small, TD-focused extension of [Rez](https://github.com/nerdvegas/rez).

Rez is a great tool, but for developers, it can be a bit hard to work
without a little tooling. This repository provides some nice scripts to
do that.

# Requirements
- [Rez](https://github.com/nerdvegas/rez)
- [git](https://github.com/git/git)
- bash (as an executable shell)
- various core tools, like `cd`, `dirname`, and the like (you probably already have them)


# Basic Setup
```sh
git clone https://github.com/ColinKennedy/rez-scripts
echo "export PATH=$PWD/rez-scripts/bin:\$PATH" >> ~/.profile
# Make a new terminal
```

The echo line makes sure, whenever a terminal starts up, the commands
are visible to Linux.


## rt
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
rt unittests_python_*
```

## rte
Similar to rt but, instead of 

## re


## rbs


## rb
