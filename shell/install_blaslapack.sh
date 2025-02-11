#!/bin/bash
current_path=$(pwd)

install_blaslapack(){
	source $current_path/params
	source unpack_file.sh lapack
    	if [ -e $INSTLL_ROOT_PATH/lib/liblapack.a ]; then
        	echo "blaslapack already exist, please remove it, now skip install it"
        	return
    	fi
	if [ ! -e $INSTLL_ROOT_PATH/lib ]; then
   		mkdir -p $INSTLL_ROOT_PATH/lib
	fi
	if [ ! -e $INSTLL_ROOT_PATH/include ]; then
		mkdir -p $INSTLL_ROOT_PATH/include
    	fi

    	echo "try to install blaslapack..."
    	set -e
    	cd $SOURCE_PATH/lapack
    	make -j8
    	cd LAPACKE
    	make -j8
    	cp ../*.a $INSTLL_ROOT_PATH/lib
    	cp include/*.h $INSTLL_ROOT_PATH/include
    	echo "export LIBRARY_PATH=$LIBRARY_PATH:$INSTLL_ROOT_PATH/lib" >> $current_path/params
    	echo "export CPATH=$CPATH:$INSTLL_ROOT_PATH/include" >> $current_path/params
}

install_blaslapack "$@"
