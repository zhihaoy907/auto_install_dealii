#!/bin/bash
current_path=$(pwd)

source $current_path/params

install_petsc() {
    if [ -e $INSTLL_ROOT_PATH/petsc ]; then
        echo "petsc dir already exist, please remove it, now skip install it"
        return
    fi
    ./check_params.sh $@
    source $current_path/params
    source unpack_file.sh petsc
    source $current_path/params
    set -e
    echo "try to install PETSc..."
    cd $PETSC_SOURCE_DIR
    set -e
    export PETSC_DIR=$PETSC_SOURCE_DIR
    export PETSC_ARCH=test
    ./configure --with-mpi=1 --with-mpi-dir=$MPICH_INSTALL_DIR --with-blas-lib=$INSTLL_ROOT_PATH/lapack/lib/librefblas.a --with-lapack-lib=$INSTLL_ROOT_PATH/lapack/lib/liblapack.a
    make PETSC_DIR=$PETSC_DIR PETSC_ARCH=test all
    cp -r test $INSTLL_ROOT_PATH/petsc
    cp $PETSC_SOURCE_DIR/include/*.h $INSTLL_ROOT_PATH/petsc/include
    cp $PETSC_SOURCE_DIR/include/petsc $INSTLL_ROOT_PATH/petsc/include -r
}

install_petsc $@

