说明：
1、需要有基本的安装环境
(1):gcc python3 gfrotran cmake Matio x11 m4
(2):c++:build-essential
(3):zlib:zlib1g-dev
(4):cmake:libnghttp2-dev libidn2-0-dev libpsl-dev libssh2-1-dev(trilinos特性中的cmake依赖)
(5):xml2-config:libxml2-dev(trilinos特性依赖)
sudo apt install gcc cmake build-essential gfortran zlib1g-dev libnghttp2-dev libidn2-0-dev libpsl-dev libssh2-1-dev libxml2-dev python3 libmatio-dev libx11-dev m4 -y

2、编译dealii支持的选项 petsc、p4est、trilinos,使用--prefix指定安装目录,参考命令如下所示:
./install_dealii.sh --prefix=~/Desktop/software/dealii --with-p4est --with-petsc --with-trilinos

3、如果报错找不到某些文件重新执行安装命令即可

4、当编译时出现报错：collect2: fatal error: ld terminated with signal 9 [Killed]
考虑增加内存或使用以下命令增加临时内存
sudo dd if=/dev/zero of=/swapfile bs=1M count=4096
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
如果出现报错：dd: failed to open '/swapfile': Text file busy，先执行下面的命令再重新创建交换分区：
sudo swapoff /swapfile
sudo rm /swapfile

5、安装完毕之后如果想设置环境变量参考params.txt。为避免params.txt中的参数冗余，执行安装命令前先执行./cleanfile.sh

6、删除构建的解压文件执行./cleandir.sh

