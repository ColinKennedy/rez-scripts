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


get_local_rez_package() {
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


get_release_path() {
    echo `rez-config | grep "^release_packages_path: " | cut -d" " -f 2`
}
