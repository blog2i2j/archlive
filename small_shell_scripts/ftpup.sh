#!/bin/bash
# 译者:龙力勤
# 最新更新:2009-08-16
# 出自懒人运维:http://www.lazysa.com
# Eamil:longkaty@sina.com
# 用途:文件目录复制。
# 描述:shell脚本递归复制目录下所有文件，并上传到FTP上
# 更多关于此脚本的讨论，请参考:http://www.lazysa.com/2009/08/792.html
# 用法:./scriptname.sh
 
FTP="/usr/bin/ncftpput"
CMD=""
AUTHFILE="/root/.myupload"
 
if [ -f $AUTHFILE ] ; then
  # use the file for auth
  CMD="$FTP -m -R -f $AUTHFILE $myf $remotedir $localdir"
else
  echo "*** To terminate at any point hit [ CTRL + C ] ***"
  read -p "Enter ftpserver name : " myf
  read -p "Enter ftp username : " myu
  read -s -p "Enter ftp password : " myp
  echo ""
  read -p "Enter ftp remote directory [/] : " remotedir
  read -p "Enter local directory to upload path [.] : " localdir
  [ "$remotedir" == "" ] && remotedir="/" || :
  [ "$localdir" == "" ] && localdir="." || :
  CMD="$FTP -m -R -u $myu -p $myp $myf $remotedir $localdir"
fi
 
$CMD