#!/bin/bash

set -e
TARGET=""
MBR=""

# 查找我们使用的分区或者U盘
MYMNT=$(cd -P $(dirname $0) ; pwd)
while [ "$MYMNT" != "" -a "$MYMNT" != "." -a "$MYMNT" != "/" ]; do
   TARGET=$(egrep "[^[:space:]]+[[:space:]]+$MYMNT[[:space:]]+" /proc/mounts | cut -d " " -f 1)
   if [ "$TARGET" != "" ]; then break; fi
   MYMNT=$(dirname "$MYMNT")
done

if [ "$TARGET" = "" ]; then
   echo "无法查找欲安装的设备."
   echo "请确保你已经挂载设备."
   exit 1
fi

MBR=$(echo "$TARGET" | sed -r "s/[0-9]+\$//g")
NUM=${TARGET:${#MBR}}
cd "$MYMNT"

clear
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo "                       欢迎使用Carbon的Archlive安装系统                        "
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
echo
echo "安装系统到 $TARGET 只能启动Archlive."
if [ "$MBR" != "$TARGET" ]; then
   echo
   echo "警告！$MBR引导分区将被改写."
   echo "如果你用$MBR启动现存系统，原引导记录将无法正常工作."
   echo "只能Archlive能被正常启动，请谨慎!"
fi
echo
echo "按任意键继续， Ctrl+C放弃..."
read junk
clear

echo "读入文件系统，稍慢，请耐心等待..."
sync

# 如果设备不支持superfloppy格式(USB-ZIP)，则安装lilo
if [ "$MBR" != "$TARGET" ]; then
   echo "创建分区记录到$MBR..."
   ./boot/syslinux/lilo -S /dev/null -M $MBR ext # this must be here to support -A for extended partitions
   echo "激活分区$TARGET..."
   ./boot/syslinux/lilo -S /dev/null -A $MBR $NUM
   echo "更新引导记录$MBR..." # this must be here because LILO mbr is bad. mbr.bin is from syslinux
   cat ./boot/syslinux/mbr.bin > $MBR
fi

echo "创建引导记录到$TARGET..."
./boot/syslinux/syslinux -d boot/syslinux $TARGET

echo "$TARGET 可以引导了，安装结束."

echo
echo "查看以上信息，输入任意键返回..."
read junk
