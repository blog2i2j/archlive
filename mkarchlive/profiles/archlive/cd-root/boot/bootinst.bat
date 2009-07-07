@echo off
cls
set DISK=none
set BOOTFLAG=boot666s.tmp

echo 本文件用来检测当前盘符. >\%BOOTFLAG%
if not exist \%BOOTFLAG% goto readOnly

echo 请稍候，正搜索目前盘符...
for %%d in ( C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do if exist %%d:\%BOOTFLAG% set DISK=%%d
cls
del \%BOOTFLAG%
if %DISK% == none goto DiskNotFound

echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
echo                          欢迎使用Carbon的Archlive安装系统
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
echo.
echo 安装系统到%DISK%盘: 只能启动Archlive.
echo.
echo 警告！%DISK%盘引导分区将被改写.
echo 如果%DISK%盘也用来启动windows，此步骤将使你的windows无法启动。
echo.
echo 按任意键继续，关闭此窗口放弃。
pause > nul

cls
echo 写入引导记录到%DISK%盘，请稍候...

if %OS% == Windows_NT goto setupNT
goto setup95

:setupNT
\boot\syslinux\syslinux.exe -ma -d \boot\syslinux %DISK%:
goto setupDone

:setup95
\boot\syslinux\syslinux.com -ma -d \boot\syslinux %DISK%:

:setupDone
echo %DISK%盘现在应该可以启动了，安装成功。
goto pauseit

:readOnly
echo %DISK%盘被写保护，无法继续。
goto pauseit

:DiskNotFound
echo 错误：无法查找该盘。

:pauseit
echo.
echo 查看以上信息，输入任意键返回。
pause > nul

:end
