#!/bin/bash
current_path=$(pwd)

install_openssl() {
    ./check_params.sh $@
    source $current_path/params
    source unpack_file.sh openssl
    if [ -e $INSTLL_ROOT_PATH/openssl ]; then
        echo "openssl dir already exist, please remove it, now skip install it"
        echo "export PATH=$OPENSSL_ROOT_DIR/bin:$PATH" >> $current_path/params
        echo "export LD_LIBRARY_PATH=$OPENSSL_ROOT_DIR/lib:$LD_LIBRARY_PATH" >> $current_path/params
        echo "export CPATH=$OPENSSL_ROOT_DIR/include:$CAPTH" >> $current_path/params
        echo "export OPENSSL_ROOT_DIR=$OPENSSL_ROOT_DIR/software/openssl" >> $current_path/params
        return
    fi
    echo "try to install openssl..."
    echo "export OPENSSL_ROOT_DIR=$INSTLL_ROOT_PATH/openssl" >> $current_path/params
    echo "export PATH=$INSTLL_ROOT_PATH/openssl/bin:$PATH" >> $current_path/params
    echo "export CPATH=$INSTLL_ROOT_PATH/openssl/include:$CPATH" >> $current_path/params
    echo "export LD_LIBRARY_PATH=$INSTLL_ROOT_PATH/openssl/lib64:$LD_LIBRARY_PATH" >> $current_path/params
    echo "openssl has been installed"
    set -e
    source $current_path/params
    cd $OPENSSL_SOURCE_DIR
    ./Configure --prefix=$INSTLL_ROOT_PATH/openssl
    make && make install
}

install_openssl "$@"
