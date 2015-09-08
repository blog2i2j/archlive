# Quick Buils Scripts 快速制作脚本 #

将以下脚本复制到一个文本文件中，比如autobuild\_archlive

获取该脚本最新版本：
wget http://archlive.googlecode.com/hg/small_shell_scripts/autobuild_archlive

运行
sh ./autobuild\_archlive

**特别注意：** 制作archlive 必须确保目标系统安装aufs squashfs 文件系统内核模块，否则报错！
  1. 如果使用Arch 官方编译的内核，需要另外加装archlive-pkg repo中的 aufs2-git这个包;
  1. 使用Arch 官方编译的内核，目标系统启动过程中会出现方块！——因为没有中文字符支持！
  1. 为确保成功，最好使用 archlive-pkg repo中的内核。

既可以在/0907 (/月日)目录下产生你自己的archlive，最后的日志会自动打包为mkarchlive\_build\_log.tgz

图片如下：

![http://archlive.googlecode.com/hg/screenshots/build_archlive/111.png](http://archlive.googlecode.com/hg/screenshots/build_archlive/111.png)

![http://archlive.googlecode.com/hg/screenshots/build_archlive/112.png](http://archlive.googlecode.com/hg/screenshots/build_archlive/112.png)

![http://archlive.googlecode.com/hg/screenshots/build_archlive/113.png](http://archlive.googlecode.com/hg/screenshots/build_archlive/113.png)

![http://archlive.googlecode.com/hg/screenshots/build_archlive/114.png](http://archlive.googlecode.com/hg/screenshots/build_archlive/114.png)

![http://archlive.googlecode.com/hg/screenshots/build_archlive/115.png](http://archlive.googlecode.com/hg/screenshots/build_archlive/115.png)

![http://archlive.googlecode.com/hg/screenshots/build_archlive/116.png](http://archlive.googlecode.com/hg/screenshots/build_archlive/116.png)

![http://archlive.googlecode.com/hg/screenshots/build_archlive/117.png](http://archlive.googlecode.com/hg/screenshots/build_archlive/117.png)

![http://archlive.googlecode.com/hg/screenshots/build_archlive/118.png](http://archlive.googlecode.com/hg/screenshots/build_archlive/118.png)

```

#!/bin/bash
#
######################################################################################
#  Author: Carbon Jiao <http://archlive.googlecode.com> <http://archlive-pkg.googlecode.com>
#  Write this scripts to simplify the procedure of make your own Live system (LiveHD LiveUSB 
#  or LiveCD) with mkarchlive scripts.								  
#  作者 Carbon Jiao <http://archlive.googlecode.com><http://archlive-pkg.googlecode.com>    
#  写该脚本的目的是为了简化 使用mkarchlive脚本制作自己的基于Arch GNU/Linux的Live系统(LiveHD
#  LiveUSB or LiveCD)的过程.									   
#  2009-09-07 1st Revision									   
######################################################################################
#
#
APPNAME=$(basename "${0}")
cmdline=$@
# Checking the envirment...
# 检查语言环境
lang=$(locale | grep LANG | awk -F "=" '{print $2}')

# Default value, you can use "-r <workdir>" to change it.
# 默认工作目录， 可以使用 -r <workdir> 来更改.
workdir="/$(date +%m%d)"

usage (){
	echo ""
   if [ "${lang%_*}x" = "zhx" ]; then
	echo "用法： sh ./${APPNAME} [选项]"
	echo "选项："
	echo "       -r <workdir>   workdir为工作目录——本脚本所有操作均局限于该目录下;"
	echo "       -h         本帮助信息."
   else
	echo "Usage: sh ./${APPNAME} [Options]"
	echo "Options:"
	echo "       -r <workdir>   workdir is the working directory, all actions from this scripts under this folder;"
	echo "       -h         This help."
   fi
   exit $1
}

# Check the input
# 检测输入的选项
while getopts 'r:h:?' arg; do
   case "${arg}" in
	r) workdir="${OPTARG}" ;;
        h|?) usage 0 ;;
        *) if [ "${lang%_*}x" = "zhx" ]; then
		echo "错误: 无效参数 '${arg}'"
	   else
		echo "Wrong option '${arg}'"
	   fi
	   usage 1 ;;
   esac
done

if [ "x${workdir}" = "x" ]; then
	if [ "${lang%_*}x" = "zhx" ]; then
		echo "没有指定工作目录? 使用默认工作目录"/$(date +%m%d)" "
	else
		echo "No workdir pointed out? Use the default "/$(date +%m%d)" "
	fi
	workdir="/$(date +%m%d)"
fi

shift `expr $OPTIND - 1`
if [ "x$@" != "x" ]; then
	if [ "${lang%_*}x" = "zhx" ]; then
		echo "错误：无法识别的参数或命令: $@"
	else
		echo "Wrong: Unexpected options or command:$@"
	fi
	usage 1
fi

# Confirm to continue
# 确认后继续
if [ "${lang%_*}x" = "zhx" ]; then
	echo -n -e "本脚本可能需要sudo来安装Mercurial(如果还没有安装), 会产生目录${workdir}, \
		\n所有操作将局限于该目录中，请确保硬盘 / 分区有足够空间——如果包含X，需要3G左右空间. \
		\n输入"y"继续: "
else
	echo -n -e "This scripts will use sudo install Mercurial(If haven't installed), and will create folder ${workdir}, \
		\nAll actions will be operated within this folder. Ensue your / partion have enough free space. \
		\n——Need about 3GB if you build Archlive with X. \n \
		\nInput "y" to continue: "
fi
read confirm
case $confirm in
	Y|y) ;;
	*) if [ "${lang%_*}x" = "zhx" ]; then
		echo "输入无效，退出脚本..."
		exit 1
	   else
		echo "No "Y" or "y" inputed, exit the scripts..."
		exit 1
	   fi
	;;
esac

# Checking the hg tools
# 检查获取mkarchlive脚本的工具是否存在
hgrevision=$(hg -v 2>/dev/null | head -1 | awk '{print $5}')
hgrevision=${hgrevision%)}

# Install Mercurial if not installed
# 如果没有hg功能，则安装Mercurial
if [ "x${hgrevision}" = "x" ]; then
	if [ "${lang%_*}x" = "zhx" ]; then echo "系统还没有装Mercurial."; else echo "No mercurial installed."; fi
	if [ -f /etc/pacman.conf ]; then
		if [ "${lang%_*}x" = "zhx" ]; then
			echo "现在安装mercurial - 一个版本管理程序..."
		else
			echo "Start to install Mercurial-- A scalable distributed SCM tool ..."
		fi
		sudo pacman -S --noconfirm mercurial >/dev/null
		if [ $? -eq 0 ]; then
			if [ "${lang%_*}x" = "zhx" ]; then echo "Mercurial 安装完成!"; else echo "Mercurial installing finished!"; fi
		else
			if [ "${lang%_*}x" = "zhx" ]; then
				echo "安装Mercurial失败，请自行手动安装..."
			else
				echo "Install Mercurial failed, try again after you installed Mercurial." 
			fi
		fi
	else
		if [ "${lang%_*}x" = "zhx" ]; then
			echo "宿主系统不是Arch，请先安装mercurial再执行本脚本..."
		else
			echo "Host system is not Arch GNU/Linux, try again after you installed Mercurial -- A scalable distributed SCM tool." 
		fi
		exit 1
	fi
fi

hgrevision=$(hg -v 2>/dev/null | head -1 | awk '{print $5}')
hgrevision=${hgrevision%)}

echo "Mercurial版本为 ${hgrevision}..."

# Create working directory (mkarchlive scripts and archlive working tmp all store in this foder.)
# 创建工作目录 (制作脚本及制作工作目录均存于此目录下.)
if [ -d ${workdir} ]; then
	if [ "${lang%_*}x" = "zhx" ]; then
		echo "工作目录${workdir}已经存在，是否删除？不删除则继续在改目录下制作archlive..."
	else
		echo "Working directory ${workdir} already exist, delete? You can rebuild Archlive without delete this folder..."
	fi
	sudo rm -ri ${workdir}
fi
sudo install -dm777 ${workdir}
sudo chown -R 1001:100 ${workdir}

# Check out the scripts
# 检出制作代码
cd ${workdir}
hg clone http://mkarchlive.archlive.googlecode.com/hg mkarchlive

# Start to build
# 开始自动创建
cd mkarchlive
log=${workdir}/$(whoami)-$(date +'%F-%H%M%S').log
sudo sh ./mkarchlive -f all ${workdir} 2>&1 | tee ${log}

# Clean the working directories
# 清理系统
cd ../
sudo umount -l ${workdir}/union 2>&1 >/dev/null
if [ "${lang%_*}x" = "zhx" ]; then
	echo "现在工作缓存目录...也可以不删除缩减下次制作时间..."
else
	echo "Now, clean the $workdir, you also keep these directories to save time when you create Archlive next time."
fi
sudo rm -ri ${workdir}/{img_*,*_modules,sync,union}  2>&1 >/dev/null
tar -czvpf mkarchlive_build_log.tgz log ${log} list  2>&1 >/dev/null

if [ "${lang%_*}x" = "zhx" ]; then
	echo "如果制作过程中有什么其他问题，将mkarchlive_build_log.tgz发邮件到 carbonjiao alt gmail dot com，感谢支持！"
else
	echo "If you have some problems, you can send the log file "mkarchlive_build_log.tgz" to carbonjiao alt gmail dot com, thanks for your support!"
fi
```