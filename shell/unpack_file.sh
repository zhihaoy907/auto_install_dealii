#!/bin/bash
# 说明：解压文件并重命名，若存在多个版本择解压最高的版本
# 如：存在mpich-4.2.tar.gz和mpich-4.1.tar.gz则会将mpich-4.2.tar.gz解压为mpich
# 当前仅支持.zip、.tar、.tar.gz文件格式解压
# 使用命令形如：unpack_file.sh mpich
set -e

SOURCE_VAR=$(echo "$1" | tr '[:lower:]' '[:upper:]')_SOURCE_DIR
SOURCE_PATH=$(pwd)/../opensource
if  ! grep -q "$SOURCE_VAR=" "params" ; then
	echo "export $SOURCE_VAR=$SOURCE_PATH/$1" >> params
fi
if [[ -d "$SOURCE_PATH/$1" ]]; then
	echo "Directory $1 already exists, skipping extraction."
	return 
fi

install_files=$(find ../opensource/ -type f \( -name "*$1*.tar.gz" -o -name "*$1*.tar" -o -name "*$1*.zip" \) -not -name "petsc-pkg-fblaslapack-e8a03f57d64c.tar.gz")
files=()

for install_file in $install_files; do
    file="${install_file##*/}"
    files+=("$file")
done

files_str=$(IFS=' ' ; echo "${files[*]}")
if [[ -z "$install_files" ]]; then
    echo "没有找到任何 $1 压缩包。"
    exit 1
fi

versions=()
files_with_versions=()

# 提取版本号
for file in "${files[@]}"; do
    name_version_pattern='^([^_-]+)-(.*)\.(tar\.gz|zip|tar)$'
    if [[ "$(basename $file)" =~ $name_version_pattern ]]; then
        files_with_versions+=("${BASH_REMATCH[2]}")
    fi
done

echo "versions: ${files_with_versions[@]}"

# 找出最高版本的文件
highest_version=""
highest_file=""
if [[ ${#files_with_versions[@]} -eq 1 ]]; then
    highest_version="${files_with_versions[0]}"
else
    for version in "${files_with_versions[@]}"; do
        if [[ -z "$highest_version" || "$version" > "$highest_version" ]]; then
            highest_version="$version"
        fi
    done
fi
for file in "${files[@]}"; do
	echo "file:$file"
    if [[ $file == *$highest_version* ]]; then
        highest_file=$file
    fi
done

# 解压最高版本的压缩包
echo "最高版本的 $1 压缩包为：$highest_file"
current_path=$(pwd)
cd ../opensource
if [[ "$highest_file" =~ \.tar\.gz$ ]]; then
    tar -xzf "$highest_file"
	current_name=$(basename "$highest_file" .tar.gz)
elif [[ "$highest_file" =~ \.tar$ ]]; then
    tar -xf "$$highest_file"
	current_name=$(basename "$highest_file" .tar)
elif [[ "$highest_file" =~ \.zip$ ]]; then
    unzip "$highest_file"
	current_name=$(basename "$highest_file" .zip)
else
    echo "不支持的压缩包格式：$highest_file"
    exit 1
fi
if [[ $1 == trilinos ]];then
	mv Trilinos-trilinos-release-13-4-0 $1
else
	mv "$current_name" "$SOURCE_PATH/$1"
fi

echo "已解压最高版本的 $1 压缩包：$highest_file"
