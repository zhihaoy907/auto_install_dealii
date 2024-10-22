#!/bin/bash
set -e
current_path=$(pwd)

install_cmake() {
        ./check_params.sh $@
        source $current_path/params
        source unpack_file.sh cmake
        if [ -e $INSTLL_ROOT_PATH/cmake ]; then
            echo "cmake dir already exist, please remove it, now skip install it"
            echo "export PATH=$INSTLL_ROOT_PATH/cmake/bin:$PATH" >> $current_path/params
            return
        fi
        echo "try to install cmake..."
        echo "export PATH=$INSTLL_ROOT_PATH/cmake/bin:$PATH" >> $current_path/params
        source $current_path/params
	cd $current_path
        if [ ! -e $INSTLL_ROOT_PATH/openssl ]; then
            ./install_openssl.sh --prefix=$INSTLL_ROOT_PATH/openssl
	fi
        source $current_path/params
        cd $CMAKE_SOURCE_DIR
        export PATH=$OPENSSL_SOURCE_DIR/bin:$PATH
        ./bootstrap --prefix=$INSTLL_ROOT_PATH/cmake  && make -j2 && make install
	echo "cmake has been installed"
}

install_cmake "$@"
