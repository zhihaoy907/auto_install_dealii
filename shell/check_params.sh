#!/bin/bash
set -e

WITH_P4EST=false
WITH_PETSC=false
WITH_TRILINOS=false
WITH_PREFIX=false
CMAKE_CACHE_VARS=""
is_first_call=true
PARAMS_FILE="params"
CMAKE_CACHE_FILE="cmakecache"

# 处理命令行参数
for arg in "$@"; do
    if [[ "$arg" == "--prefix="* ]]; then
        INSTALL_DIR="${arg#--prefix=}"
        WITH_PREFIX=true
        echo "Found prefix: $INSTALL_DIR"
    fi
done

if [ "$WITH_PREFIX" = false ]; then
    echo "error:please add --prefix=<path to install> to set install dir"
    exit -1
fi

if [ "$is_first_call" = true ]; then
	echo INSTALL_DIR:$INSTALL_DIR
	if  grep -q "export INSTLL_ROOT_PATH=" "$PARAMS_FILE"; then
		is_first_call=false
	else
		echo "export INSTLL_ROOT_PATH=$(dirname "$INSTALL_DIR")" >> $PARAMS_FILE
		is_first_call=true
	fi
fi  

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --with-p4est)
            WITH_P4EST=true
            P4EST_INSTALL_DIR=$INSTALL_DIR/../p4est
            shift
            ;;
        --with-petsc)
            WITH_PETSC=true
            PETSC_INSTALL_DIR=$INSTALL_DIR/../petsc
			MPICH_INSTALL_DIR=$INSTALL_DIR/../mpich
            shift
            ;;
        --with-trilinos)
            WITH_TRILINOS=true
			TRILINOS_INSTALL_DIR=$INSTALL_DIR/../trilinos
            shift
            ;;
        --prefix=*)
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ $is_first_call = true ];then
	echo "export SOURCE_PATH=../opensource" >> $PARAMS_FILE
fi

# 设置 CMake 缓存变量
if [ "$WITH_P4EST" = true ]; then
    CMAKE_CACHE_VARS+="-DEAL_II_WITH_P4EST=ON -DDEAL_II_WITH_MPI=ON "
	echo "export P4EST_INSTALL_DIR=$P4EST_INSTALL_DIR " >> $PARAMS_FILE
else
    CMAKE_CACHE_VARS+="-DWITH_P4EST=OFF "
fi

if [ "$WITH_PETSC" = true ]; then
    CMAKE_CACHE_VARS+="-DWITH_PETSC=ON "
	echo "export PETSC_INSTALL_DIR=$PETSC_INSTALL_DIR " >> $PARAMS_FILE
	echo "export MPICH_INSTALL_DIR=$MPICH_INSTALL_DIR " >> $PARAMS_FILE
else
    CMAKE_CACHE_VARS+="-DWITH_PETSC=OFF "
fi

if [ "$WITH_TRILINOS" = true ]; then
    CMAKE_CACHE_VARS+="-DEAL_II_WITH_TRILINOS=ON "
	echo "export TRILINOS_INSTALL_DIR=$TRILINOS_INSTALL_DIR " >> $PARAMS_FILE
else
    CMAKE_CACHE_VARS+="-DEAL_II_WITH_TRILINOS=OFF "
fi

if [ "$WITH_P4EST" = true ] || [ "$WITH_PETSC" = true ] || [ "$WITH_TRILINOS" = true ];then
	echo "$CMAKE_CACHE_VARS" > $CMAKE_CACHE_FILE
fi
