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


set_config() {
    current_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    parent=`dirname $current_directory`

    export REZ_CONFIG_FILE=${PERSONAL_CONFIG_FILE-$parent/python/rezconfig.py}:$REZ_CONFIG_FILE
}
