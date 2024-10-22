remove_dir=("cmake" "dealii" "mpich" "netcdf-c" "openssl" "p4est" "trilinos" "zlib" "boost" "netcdf-c" "petsc" "lapack" "curl" "netcdf" "netcdf-fortran" "hdf5")

for dir in "${remove_dir[@]}"; do
    if [ -e ../opensource/$dir ];then
        rm -rf ../opensource/$dir
    fi
done

