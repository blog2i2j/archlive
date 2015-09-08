# 关于archldr #

archldr 为wubi的变种，是Arch类Linux系统在windows下的图形安装器，旨在将Arch类Linux系统类似于ubuntu在windows下安装到loop设备中.

获取源码：
```
hg clone http://archldr.archlive.googlecode.com/hg/ archldr.archlive 
```


# 实现目标 #
将archldr图形界面下用户原则输出到grub2的启动命令行中（wubi为输出到presed中），Arch类系统启动过程中根据命令行参数来安装到loop系统。
需要传递的参数(详细见 data/grub.install.cfg):
iso\_path  archldr初始安装后，将archlive iso拷贝的路径
root      安装的目标root loop文件 root.disk 路径
rootsize  目标root loop文件root.disk大小，以MB为单位
swap      目标交换分区loop文件 swap.disk 路径
swapsize  目标交换分区loop文件 swap.disk 大小，以MB为单位
username  目标系统中用户名
password  目标系统中上面用户名对应密码
locale    目标系统locale
timezone  目标系统timezone
keyboard\_layout  目标系统键盘布局

# 目前未解决问题 #
  * 初始修改的src/wubi/backends/common/backend.py 出现错误，无法运行, 错误如下：<br>
<pre><code>05-16 10:35 DEBUG  CommonBackend: Parsing isolist=C:\windows\TEMP\pyl8CC4.tmp\data\isolist.ini<br>
05-16 10:35 DEBUG  CommonBackend:   Adding distro Archlive-x86_64<br>
05-16 10:35 ERROR  root: __init__() takes at least 22 non-keyword arguments (7 given)<br>
Traceback (most recent call last):<br>
  File "\lib\wubi\application.py", line 55, in run<br>
  File "\lib\wubi\backends\common\backend.py", line 153, in fetch_basic_info<br>
  File "\lib\wubi\backends\common\backend.py", line 169, in get_distros<br>
  File "\lib\wubi\backends\common\backend.py", line 723, in parse_isolist<br>
TypeError: __init__() takes at least 22 non-keyword arguments (7 given)<br>
</code></pre></li></ul>

<ul><li>获取命令行的以上参数来安装系统的脚本还未完成：<br>    live系统安装，将安装源挂载到/union，安装目标（上面的root.disk）挂载到/install；将 /union 下的文件复制到 /install下，修改相关配置文件，重新制作内核镜像；修改启动配置文件grub.cfg...