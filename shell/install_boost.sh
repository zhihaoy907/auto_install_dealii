#!/bin/bash
current_path=$(pwd)
set -e
install_boost() {
	./check_params.sh $@
	source $current_path/params
	source unpack_file.sh boost
	echo "export BOOST_INCLUDEDIR=$INSTLL_ROOT_PATH/boost/include" >> $current_path/params
	echo "export CPATH=$INSTLL_ROOT_PATH/boost/include:$CPATH" >> $current_path/params
	echo "export LD_LIBRARY_PATH=$INSTLL_ROOT_PATH/boost/lib:$LD_LIBRARY_PATH" >> $current_path/params
	echo "export boost_python_DIR=$INSTLL_ROOT_PATH/boost_python3" >> $current_path/params

	if [ -e $INSTLL_ROOT_PATH/boost ]; then
        echo "boost dir already exist, please remove it, now skip install it"
		return
    	fi
	echo "try to install boost..."
    	cd $BOOST_SOURCE_DIR
    	./bootstrap.sh --prefix=$INSTLL_ROOT_PATH/boost
    	./b2 && ./b2 install

	if [ -e $INSTLL_ROOT_PATH/boost_python3 ]; then
        echo "boost_python3 dir already exist, please remove it, now skip install it"
	return
    	fi
	./bootstrap.sh --with-python=python3 --prefix=$INSTLL_ROOT_PATH/boost_python3
	./b2 && ./b2 install
    	echo "boost has been installed"
}

install_boost "$@"
