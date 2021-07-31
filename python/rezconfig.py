"""The back-end for all executable shell scripts in this git repository.

Each shell script, at some point during its execution, will source this file
and use it for any building, Rez resolving, etc.

"""

import os
import subprocess

from rez.config import config


def _get_branch_name():
    """str: Get the user's current git branch name, if any."""
    process = subprocess.Popen(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        universal_newlines=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd=os.getcwd(),
    )
    stdout, stderr = process.communicate()

    if stderr == "fatal: not a git repository (or any of the parent directories): .git\n":
        return ""

    return stdout.strip()


def _local_packages_path():
    """Find the directory where Rez packages will be installed.

    If the user is not in a git repository, the default ~/packages path is
    used. If they are in a git repository, their
    $PERSONAL_WORK_AREA/$git_branch_name is used instead.

    Returns:
        str: The found install path.

    """
    branch = _get_branch_name()

    if not branch:
        # Fall back to the original local packages path if not within a git repository
        return os.path.join(os.path.expanduser("~"), "packages")

    if "PERSONAL_WORK_AREA" in os.environ:
        base = os.environ["PERSONAL_WORK_AREA"]
    else:
        base = os.path.join(os.path.expanduser("~"), "work_area")

    return os.path.join(base, branch)

local_packages_path = _local_packages_path()
packages_path = ModifyList(prepend=[local_packages_path])
