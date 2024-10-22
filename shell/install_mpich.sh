#!/bin/bash
current_path=$(pwd)

install_mpich() {
        ./check_params.sh $@
        source $current_path/params
        source unpack_file.sh mpich
        if [ -e $INSTLL_ROOT_PATH/mpich ]; then
        echo "mpich dir already exist, please remove it, now skip install it"
        echo "mpich has been installed"
        echo "export PTAH=$INSTLL_ROOT_PATH/mpich/bin:$PATH" >> $current_path/params
        return
    fi
    echo "try to install mpich..."
    echo "mpich has been installed"
    echo "export PTAH=$INSTLL_ROOT_PATH/mpich/bin:$PATH" >> $current_path/params
    set -e
    cd $SOURCE_PATH/mpich
    ./configure --prefix=$INSTLL_ROOT_PATH/mpich --enable-cxx --enable-romio
    make -j$(nproc)
    make install
}

install_mpich "$@"

