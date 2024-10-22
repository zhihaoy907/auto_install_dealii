remove_file_list=("params" "temp" "cmakecache")

for file in "${remove_file_list[@]}"; do
    if [ -e $file ];then
		rm $file
	fi
done
