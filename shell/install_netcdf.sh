#!/bin/bash
current_path=$(pwd)
export OPENSSL_ROOT_DIR=$INSTLL_ROOT_PATH/openssl

install_netcdf() {
        current_path=$(pwd)
        source $current_path/params
        source unpack_file.sh netcdf
        if [ -e $INSTLL_ROOT_PATH/netcdf4-needed ]; then
            echo "netcdf dir already exist, please remove it, now skip install it"
            return
        fi
	cd $current_path
        ./unpack_spec_dir.sh
        cd $current_path
        echo "try to install netcdf..."
        set -e
        source $current_path/params
        #install zlib
        if [ ! -d $INSTLL_ROOT_PATH/netcdf4-needed ]; then
            echo "donnot find zlib at the same dir,now try to install zlib"
            mkdir $INSTLL_ROOT_PATH/netcdf4-needed
            source $current_path/unpack_file.sh zlib
            cd $SOURCE_PATH/zlib
            ./configure --prefix=$INSTLL_ROOT_PATH/netcdf4-needed
            make && make install
        fi
        #install hdf5 curl
        if [ ! -d $INSTLL_ROOT_PATH/hdf5 ]; then
            echo "donnot find hdf5 at the same dir,now try to install hdf5"
            cd $SOURCE_PATH/hdf5
            ./configure --prefix=$INSTLL_ROOT_PATH/hdf5 --with-zlib=$INSTLL_ROOT_PATH/netcdf4-needed
            make && make install
            echo "donnot find curl at the same dir,now try to install curl"
            cd $current_path
            ./install_curl.sh --prefix=$INSTLL_ROOT_PATH/netcdf4-needed
            echo "curl has been installed"
        fi
        source $current_path/params
        #install netcdf-c netcdf-fortran
        echo "donnot find netcdf-c at the same dir,now try to install netcdf-c"
        cd $current_path/../opensource/netcdf
        export CPATH=$CPATH:$current_path/../opensource/netcdf/include
        export CPATH=$CPATH:$current_path/../opensource/hdf5/include
        ./configure --prefix=$INSTLL_ROOT_PATH/netcdf4-needed --disable-dap --with-hdf5=$INSTLL_ROOT_PATH/hdf5 CPPFLAGS=-I$INSTLL_ROOT_PATH/hdf5/include LDFLAGS=-L$INSTLL_ROOT_PATH/hdf5/lib
        make && make install
        cd $current_path/../opensource/netcdf-fortran
        ./configure --prefix=$INSTLL_ROOT_PATH/netcdf4-needed --disable-dap CPPFLAGS=-I$INSTLL_ROOT_PATH/netcdf-c/include LDFLAGS=-L$INSTLL_ROOT_PATH/netcdf-c/lib
        make && make install
        echo "export LD_LIBRARY_PATH=$INSTLL_ROOT_PATH/netcdf4-needed/lib:$LD_LIBRARY_PATH"
}

install_netcdf "$@"

