#!/bin/bash

install_dealii() {
	current_path=$(pwd)
	./check_params.sh $@
	source $current_path/params
	source unpack_file.sh dealii
	if [ -e $INSTLL_ROOT_PATH/dealii ]; then
        echo "dealii dir already exist, please remove it, now skip install it"
        return
    	fi
	cd $current_path
	echo "try to install dealii..."
	if [ -n "$MPICH_INSTALL_DIR" ]; then
        echo "open mpich,now try to install it"
        ./install_mpich.sh --prefix=$MPICH_INSTALL_DIR
    	fi
    	if [ -n "$P4EST_INSTALL_DIR" ]; then
		echo "open p4est,now try to install it"
		./install_p4est.sh --prefix=$P4EST_INSTALL_DIR
	fi
	if [ -n "$PETSC_INSTALL_DIR" ]; then
        echo "open petsc,now try to install it"
        ./install_petsc.sh --prefix=$PETSC_INSTALL_DIR
    	fi
	if [ -n "$TRILINOS_INSTALL_DIR" ]; then
        echo "open trilinos,now try to install it"
        ./install_trilinos.sh --prefix=$TRILINOS_INSTALL_DIR
    	fi
	CMAKE_CACHE_VARS=$(cat cmakecache)
	set -e
	source $current_path/params
    	cd $SOURCE_PATH/dealii
    	if [ ! -e build ];then
    		mkdir build
    	fi
    	cd build
    	cmake -DCMAKE_INSTALL_PREFIX=$INSTLL_ROOT_PATH/dealii \
        	$CMAKE_CACHE_VARS \
        	-DPETSC_DIR=$INSTLL_ROOT_PATH/petsc \
	        -DP4EST_DIR=$INSTLL_ROOT_PATH/p4est \
	        -DMPI_C_COMPILER=$INSTLL_ROOT_PATH/mpich/bin/mpicc \
	        -DMPI_CXX_COMPILER=$INSTLL_ROOT_PATH/mpich/bin/mpicxx \
	        -DMPI_Fortran_COMPILER=$INSTLL_ROOT_PATH/mpich/bin/mpif90 \
	        -DTRILINOS_DIR=$INSTLL_ROOT_PATH/trilinos \
	        -DSLEPC_DIR=$INSTLL_ROOT_PATH/slepc \
	        -DBOOST_ROOT=$INSTLL_ROOT_PATH/boost \
	        -DCMAKE_CXX_STANDARD=17 \
	        -DDEAL_II_COMPONENT_PYTHON_BINDINGS=ON \
	        -DCMAKE_CXX_STANDARD_REQUIRED=True \
	        -DDEAL_II_WITH_PYTHON=ON \
	        -DPYTHON_EXECUTABLE=$(which python3) \
	        -DPYTHON_INCLUDE_DIR="$boost_python_DIR/include;$(python3 -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())')" \
	        -DPYTHON_LIBRARY="$boost_python_DIR/lib;$(python3 -c 'import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var("LIBDIR"))')" \
	        ..

	make -j2 && make install
	echo "dealii has been installed"
}

install_dealii "$@"
