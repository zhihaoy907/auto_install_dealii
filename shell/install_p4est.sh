#!/bin/bash
set -e
current_path=$(pwd)
source $current_path/params

install_p4est() {
    if [ -e $INSTLL_ROOT_PATH/p4est ]; then
        echo "p4est dir already exist, please remove it, now skip install it"
    return
    fi
    if [ ! -e $INSTLL_ROOT_PATH/lapack/liblapack.a ]; then
        echo "donot find blas and lapack,now try to install it"
        ./install_blaslapack.sh
    fi
    ./check_params.sh $@
    source $current_path/params
    source unpack_file.sh p4est
    source $current_path/params
    echo "try to install p4est..."
    set -e
    cd $P4EST_SOURCE_DIR
    export CC=$INSTLL_ROOT_PATH/mpich/bin/mpicc
    export CXX=$INSTLL_ROOT_PATH/mpich/bin/mpicxx
    ./configure --prefix=$INSTLL_ROOT_PATH/p4est --enable-mpi --enable-zlib --with-zlib=$INSTLL_ROOT_PATH/zlib
    make -j$(nproc)
    make install
}

install_p4est $@

