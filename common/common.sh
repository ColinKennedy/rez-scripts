endswith() {
    case $1 in
      *"$2") return 0;;
      *)    return 1;;
    esac
}

# Reference: https://unix.stackexchange.com/a/22215/290614
find_up() {
    path=$2

    while [[ "$path" != "" && ! -e "$path/$1" ]]; do
        path=${path%/*}
    done

    if ! [ -z $path ]
    then
        echo $path/$1
    fi
}


find_nearest_rez_package() {
    package=`find_up package.py $1`

    if [ -z "$package" ]
    then
        package=`find_up package.yaml $1`
    fi

    echo $package
}


get_local_package_name() {
    directory=$1
    package_file=`find_nearest_rez_package $directory`
    output=""

    if [ -z "$package_file" ]
    then
        echo >&2 "The current directory is not in a Rez package"

        return
    fi

    if endswith $package_file ".py"
    then
        name=`grep "^name" $package_file | sed -e "s/name\s*=\s*[\"']//" -e "s/[\"']\s*$//"`
    elif endswith $package_file ".yaml"
    then
        name=`grep "^name" $package_file | sed -e "s/name\s*:\s*[\"']//" -e "s/[\"']//"`
    else
        echo >&2 "Package \"$package_file\" could not processed."

        return
    fi

    echo $name
}


get_local_package_version() {
    directory=$1
    package_file=`find_nearest_rez_package $directory`
    output=""

    if [ -z "$package_file" ]
    then
        echo >&2 "The current directory is not in a Rez package"

        return
    fi

    if endswith $package_file ".py"
    then
        version=`grep "^version" $package_file | sed -e "s/version\s*=\s*[\"']//" -e "s/[\"']\s*$//"`
    elif endswith $package_file ".yaml"
    then
        version=`grep "^version" $package_file | sed -e "s/version\s*:\s*[\"']//" -e "s/[\"']//"`
    else
        echo >&2 "Package \"$package_file\" could not be processed to find a version."

        return
    fi

    echo $version
}


get_release_path() {
    if [ -n "$REZ_RELEASE_PACKAGES_PATH" ]
    then
        echo $REZ_RELEASE_PACKAGES_PATH

        return
    fi

    if test -f ~/.rezconfig
    then
        # This is the default Rez release path
        echo "~/.rez/packages/int"

        return
    fi

    # Query the user's release packages path
    echo `rez-config release_packages_path`
}


do_test() {
    # Run som rez-test command for a particular path / Rez package / test suite.
    #
    # Args:
    #     stage_path (str):
    #         The path on-disk to your local Rez package build.
    #     package_name (str):
    #         The package to run tests on.
    #     test_names (str, optional):
    #         The test / tests to run, if any. When nothing is given,
    #         the entire Rez package's test suite gets run (minus any
    #         test whose "run_on" value is set to "explicit".
    #
    stage_path=$1
    package_name=$2
    test_names="${@:3}"

    echo "Testing local stage: $stage_path"
    echo "REZ_PACKAGES_PATH=$stage_path:`get_release_path` rez-test $package_name $test_names"

    REZ_PACKAGES_PATH=$stage_path:`get_release_path` rez-test $package_name $test_names

    echo "Completed"
    echo "REZ_PACKAGES_PATH=$stage_path:`get_release_path` rez-test $package_name $test_names"
}
