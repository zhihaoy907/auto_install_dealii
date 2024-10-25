#!/bin/bash
set -e
current_path=$(pwd)
current_cmake_version=$(cmake --version | grep -oP 'cmake version \K[\d.]+')
target_version="3.23.0"
# 比较版本,安装trilinos需要cmake版本>=3.23.0
compare_versions() {
    IFS='.' read -r -a current <<< "$1"
    IFS='.' read -r -a target <<< "$2"

    for (( i=0; i<${#current[@]}; i++ )); do
        if [[ "${current[i]}" -gt "${target[i]}" ]]; then
            return 1
        elif [[ "${current[i]}" -lt "${target[i]}" ]]; then
            return 0
        fi
    done
    return 0
}

install_trilinos() {
    echo "try to install trilinos..."
    set -e
	if [ -e $INSTLL_ROOT_PATH/trilinos ]; then
        echo "trilinos dir already exist, please remove it, now skip install it"
        return
    fi
	./check_params.sh $@
	if compare_versions "$current_version" "$target_version"; then
    	echo "CMake version is ($current_cmake_version),now try to install higher version"
		source $current_path/params
		./install_cmake.sh --prefix=$INSTLL_ROOT_PATH/cmake
	else
    	echo "CMake version is ($current_cmake_version)"
	fi
	# boost
    if ! command -v boost &> /dev/null; then
		echo "donot find boost,now try to install it"
        source $current_path/params
        ./install_boost.sh --prefix=$INSTLL_ROOT_PATH/boost
    fi
	# curl	
	if [ ! -d $INSTLL_ROOT_PATH/curl ]; then
        echo "donnot find curl,now try to install it"
        source $current_path/params
        ./install_curl.sh --prefix=$INSTLL_ROOT_PATH/curl
    else
        echo "find curl"
    fi
	# netcdf
	if [ ! -d $INSTLL_ROOT_PATH/netcdf4-needed ]; then
		echo "donnot find netcdf,now try to install it"
		source $current_path/params
		./install_netcdf.sh
	else
		echo "find netcdf"
	fi
	cd $current_path
	source unpack_file.sh trilinos
	source $current_path/params
	mkdir -p $TRILINOS_SOURCE_DIR/build && cd $TRILINOS_SOURCE_DIR/build
	cmake                                            \
    -DTrilinos_ENABLE_Amesos=ON                      \
    -DTrilinos_ENABLE_Epetra=ON                      \
    -DTrilinos_ENABLE_EpetraExt=ON                   \
    -DTrilinos_ENABLE_Ifpack=ON                      \
    -DTrilinos_ENABLE_AztecOO=ON                     \
    -DTrilinos_ENABLE_Sacado=ON                      \
    -DTrilinos_ENABLE_SEACAS=ON                      \
    -DTrilinos_ENABLE_Teuchos=ON                     \
    -DTrilinos_ENABLE_MueLu=ON                       \
    -DTrilinos_ENABLE_ML=ON                          \
    -DTrilinos_ENABLE_NOX=ON                         \
    -DTrilinos_ENABLE_ROL=ON                         \
    -DTrilinos_ENABLE_Tpetra=ON                      \
    -DTrilinos_ENABLE_COMPLEX=ON                     \
    -DTrilinos_ENABLE_FLOAT=ON                       \
    -DTrilinos_ENABLE_Zoltan=ON                      \
    -DTrilinos_VERBOSE_CONFIGURE=OFF                 \
    -DTPL_ENABLE_MPI=ON                              \
    -DBUILD_SHARED_LIBS=ON                           \
    -DCMAKE_VERBOSE_MAKEFILE=OFF                     \
    -DCMAKE_BUILD_TYPE=RELEASE                       \
    -DCMAKE_INSTALL_PREFIX:PATH=$INSTLL_ROOT_PATH/trilinos \
    -DCMAKE_C_COMPILER:FILEPATH=$INSTLL_ROOT_PATH/mpich/bin/mpicc \
    -DCMAKE_CXX_COMPILER:FILEPATH=$INSTLL_ROOT_PATH/mpich/bin/mpicxx \
    -DTPL_Boost_INCLUDE_DIRS=$INSTLL_ROOT_PATH/boost/lib \
    -DTPL_Netcdf_LIBRARIES=$INSTLL_ROOT_PATH/netcdf4-needed/lib \
    -DNetcdf_INCLUDE_DIRS=$INSTLL_ROOT_PATH/netcdf4-needed/include \
    -D TPL_BLAS_LIBRARIES="$INSTLL_ROOT_PATH/lib/librefblas.a;gfortran;m" \
    -D TPL_LAPACK_LIBRARIES="$INSTLL_ROOT_PATH/lib/liblapack.a;gfortran;m" \
   	..

    make -j2 && make install
    echo "trilinos has been installed"
}

install_trilinos "$@"

