#!/bin/bash
current_path=$(pwd)

install_curl() {
    ./check_params.sh $@
    source $current_path/params
    source unpack_file.sh curl
    if [ -e $INSTLL_ROOT_PATH/curl ]; then
        echo "curl dir already exist, please remove it, now skip install it"
        return
    fi
    echo "try to install curl..."
    set -e
    cd $SOURCE_PATH/curl
    mkdir -p build && cd build
    cmake -DCMAKE_INSTALL_PREFIX=$INSTLL_ROOT_PATH/curl ..
    make && make install
    echo "curl has been installed"
    echo "export PATH=$INSTLL_ROOT_PATH/curl/bin:$PATH"
    echo "export LD_LIBRARY_PATH=$INSTLL_ROOT_PATH/curl/lib:$LD_LIBRARY_PATH"
    echo "export CPATH=$INSTLL_ROOT_PATH/curl/include:$CPATH"
}

install_curl "$@"
