#!/bin/bash
# 该脚本从Fedora cvs仓库获取最新的内核补丁
# 由于不知道Fedora的cvs具体地址，采用如此办法
#
startdir=$(pwd)
cd /tmp
wget -O kernel.spec "http://cvs.fedoraproject.org/viewvc/rpms/kernel/F-12/kernel.spec?revision=1.1796"
links -no-g -source http://cvs.fedoraproject.org/viewvc/rpms/kernel/F-12/ >list
cat kernel.spec | grep "^Patch*" | cut -d " " -f 2 | grep -v "%" >order
[ -f patchlist ] && rm -f patchlist
i=0
cat order | while read patchname; do
	patch_revision=$(grep "$patchname?revision=" list | awk 'BEGIN{FS="a href=\""} {print $2}' | awk 'BEGIN{FS="&amp"} {print $1}')
	if [ $i -gt 9 ] && [ $i -lt 99 ]; then
		echo "f0${i}_${patchname}::\"http://cvs.fedoraproject.org${patch_revision}\"" >>patchlist
	elif [ $i -gt 99 ]; then
		echo "f${i}_${patchname}::\"http://cvs.fedoraproject.org${patch_revision}\"" >>patchlist
	
	else
		echo "f00${i}_${patchname}::\"http://cvs.fedoraproject.org${patch_revision}\"" >>patchlist
	fi
	let i+=1
done
cp -v /tmp/patchlist $startdir/patchlist