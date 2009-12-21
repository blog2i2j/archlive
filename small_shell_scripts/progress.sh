#!/bin/sh
#输出"."进度条函数，兼容bsh、ksh、bash
#首先trap 1 2 3 15信号，重要

trap 'kill $BG_PID;echo;exit' 1 2 3 15

function dots
{
	stty -echo >/dev/null 2>&1
	while true; do
		echo -e ".\c"
		sleep 1
	done
	stty echo
	echo
}

#---------------------------------------------
# 主程序开始
#---------------------------------------------
#首先使dots函数后台运行
dots &
BG_PID=$!
#开始程序主体，本例中执行休眠10秒
#注意必要时使用 >/dev/null 2>&1关闭输出和错误回显，避免破坏显示
sleep 10
#程序结尾注意kill dots，否则dots会一直执行
kill $BG_PID