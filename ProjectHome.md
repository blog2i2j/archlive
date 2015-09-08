<b>_Archlive, a live system base on Arch GNU/Linux and corresponding tools and repos_<br>
基于Arch GNU/Linux的live系统及相关工具及软件仓。</b><i><hr />
<a href='http://groups.google.com/group/archlive'><img src='http://groups.google.com/intl/en/images/logos/groups_logo_sm.gif' /></a><a href='http://groups.google.com/group/archlive'>***Googlegroups：Archlive ***</a></i><br>
<b>IRC：</b> irc.oftc.net #archlive  <br>
<b>QQ Group：</b> 14191139 <br>
<b>Blog：</b> <a href='http://hi.baidu.com/archlive'>http://hi.baidu.com/archlive</a> <br>
<b>Twitter：</b> <a href='http://twitter.com/carbonjiao'>http://twitter.com/carbonjiao</a>
<p>
<h2>About Archlive / 关于Archlive项目:</h2>
目前Archlive包含：<br>
1、制作基于Arch的live系统脚本——DIY你自己的Archlive！;<br>
<blockquote>hg clone <a href='http://mkarchlive.archlive.googlecode.com/hg'>http://mkarchlive.archlive.googlecode.com/hg</a> mkarchlive <br>
2、自定义repo并上传googlecode指定项目的相关repo的脚本;<br>
3、利用aufs文件系统，根据软件清单快速安装Arch GNU/Linux脚本;<br>
4、archlive-pkg 软件仓自动维护脚本；<br>
5、archlive-installer Archlive安装程序脚本。<br>
<p>
Archlive项目旨在完美化基于Arch GNU/Linux的live系统的简体中文自动化制作脚本，集成了godane的archiso-live脚本、chaox-ng脚本的优点。目前该脚本能自动化构建为简体中文用户预配置好的live系统。<br>
同时也提供根据此脚本定制的live系统iso。<br>
欢迎大家参与！欲参与者请在Issues里面留言。<br>
<p>
<b>特别软件仓库项目</b>
<a href='http://archlive-pkg.googlecode.com'>http://archlive-pkg.googlecode.com</a></blockquote>

在现有系统中使用Archlive-pkg软件仓办法：<br>
在/etc/pacman.conf中添加：<br>
<pre>
[archlive-pkg]<br>
<br>
Server = http://archlive-pkg.googlecode.com/files<br>
</pre>
然后 pacman -Sy 更新本地软件仓数据，这样就可以安装archlive-pkg软件仓中的软件了。<br>
<br>
<p>
<h2>Characters / Archlive iso特点：</h2>
Screen-shorter 抓屏  [[<a href='http://sns.linuxeye.cn/space-590-do-album-id-18.html'>http://sns.linuxeye.cn/space-590-do-album-id-18.html</a> ]] <br>
Characters  [[<a href='http://wiki.archlinux.org/index.php/Archlive(English'>http://wiki.archlinux.org/index.php/Archlive(English</a>) ]]<br>
<br>
1. 基于Arch GNU/Linux的live系统(LiveCD, LiveUSB & LiveHD), 可以支持从硬盘启动，U+方式或者GRUB或者ISOlinux方式从USB启动，启动脚本基于archiso，Chakra和larch;<br>
2. 只集成英文及简体中文locale;<br>
3. 集成小桌面环境比如icewm, fvwm2, awesome, fluxbox, lxde, openbox,部分已经配置好;<br>
4. 默认使用Wicd管理网络, 提供了相应网络工具(BT3,BT4里面的部分软件)的PKGBUILD;<br>
5. 可选采用"xakra" 配置xorg.conf，增加兼容性,默认采用Xorg配置, 默认开启无敌三键;<br>
6. 简体中文及繁体中文界面的安装程序larchin—larch项目的一部分;<br>
7. 部分程序以模块方式发布, 选择灵活同时更新也方便;<br>
8. 中文办公软件——永中Office-EIOffice 和 中标普华Office 也以模块方式提供;<br>
9. fcitx为默认输入法;<br>
10. xfce4-svn已经打了huangjiahua (Hiweed的作者，Hiweed是基于Ubuntu的中文系统) 提供的补丁. <br>
<hr />
<h2>Thanks! 致谢！</h2>
This cripts was released base on godane's old archiso-live scripts [[<a href='http://github.com/godane/archiso-live/tree/master#'>http://github.com/godane/archiso-live/tree/master#</a> ]]  [[<a href='http://godane.wordpress.com'>http://godane.wordpress.com</a> ]], I added some speical code to make the best Chinese Arch Live System, special for the newbie of linux-ers and newbie Arch-ers...<br>
<br>
本脚本基于godane的archiso-live脚本的早期版本 [[<a href='http://github.com/godane/archiso-live/tree/master#'>http://github.com/godane/archiso-live/tree/master#</a> ]]  [[<a href='http://godane.wordpress.com'>http://godane.wordpress.com</a> ]]，增加了部分中国特色的东西，以让更多的linux入门用户和刚开始用Arch的用户喜欢Arch这个优秀的发行版。<br>
<br>
<h2>Changelog / Archlive 修正记录</h2>
<a href='https://code.google.com/p/archlive/source/detail?r=5'>r5</a>-->    将mkarchlive 的hg仓独立出来; <br>
<a href='https://code.google.com/p/archlive/source/detail?r=4'>r4</a>--><a href='https://code.google.com/p/archlive/source/detail?r=5'>r5</a>  将svn转化位hg管理; <br>
<a href='https://code.google.com/p/archlive/source/detail?r=3'>r3</a>--><a href='https://code.google.com/p/archlive/source/detail?r=4'>r4</a>  增加了repo相关脚本; <br>
<a href='https://code.google.com/p/archlive/source/detail?r=2'>r2</a>--><a href='https://code.google.com/p/archlive/source/detail?r=3'>r3</a>  删除pkgbuild，独立到  <a href='http://archlive-pkg.googlecode.com'>http://archlive-pkg.googlecode.com</a>  项目；<br>
<a href='https://code.google.com/p/archlive/source/detail?r=1'>r1</a>--><a href='https://code.google.com/p/archlive/source/detail?r=2'>r2</a>  修正部分错误：mkarchlive属性及部分字符；config的部分内容。。。