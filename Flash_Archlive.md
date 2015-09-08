# 量产Archlive图解 #

本文以我的台电4G U盘（主控芯片Alcor AU6983）为例子，图解将Archlive量产到U盘，并介绍量产Archlive的相关高级用法：将启动后的修改保存到量产后的剩余空间里的loop文件中.


# 具体实现 #

### 1、规划 ###
**量产Archlive会将Archlive的iso镜像写到U盘，启动后一般被当作USB-CDROM（启动后一般是只读模式），剩余部分仍然是可写分区，启动后被当作普通U盘。**

  * 量产后USB-CDROM LABEL(卷标)设置为 **archlive**
  * U盘剩余空间的LABEL(卷标)将设置为 **AAAAAAAA**
  * U盘剩余空间的UUID将设置为 **AAAAAAAA** (16进制，在linux中显示为 **AAAA-AAAA**)
  * USB-CDROM上的Archlive(量产后)系统启动后所做修改保存到U盘剩余空间里的 **changes.img** 文件

### 2、修改Archlive iso文件 ###
**Archlive的iso发布时候启动参数中没有 _changes=_ 参数，所以默认加载内存保存修改，系统重启后消失，是真正的只读系统。**
  * 在linux下使用 **isomaster** 打开archlive iso文件
  * 在Windows下使用 **UltraISO** 或者其他工具打开
  * 将启动配置文件 **/isolinux/isolinux.cfg** 提取出来，用支持UTF-8编码的文本编辑器编辑该文件，将
> > APPEND initrd=/archlive/boot/i686.img archlivelabel=archlive from=archlive cn session=gnome oss4 ramdisk\_size=6666 ramsize=60% quiet vga=789
> > 修改为：<br>
<blockquote>APPEND initrd=/archlive/boot/i686.img archlivelabel=archlive from=archlive <b>changes=LABEL=AAAAAAAA/changes.img</b> <b>newloop</b> cn session=gnome oss4 ramdisk_size=6666 ramsize=60% quiet vga=789<br>
<br>或者：<br>
APPEND initrd=/archlive/boot/i686.img archlivelabel=archlive from=archlive <b>changes=UUID=AAAA-AAAA/changes.img</b> <b>newloop</b> cn session=gnome oss4 ramdisk_size=6666 ramsize=60% quiet vga=789<br>
</blockquote><ul><li><b>/isolinux/isolinux.cfg</b> 中另外启动项也可以相应修改，比如英文启动菜单等<br>
</li><li>修改完成后，将修改好的文件替换 iso 中对应同名文件, 保存修改后的iso文件为 <b>Archlive.iso</b> (比如）</li></ul>

<h3>3、量产</h3>
<blockquote><h4>1、量产相关准备工作</h4>
<blockquote>需要用 <b>Chip Genius</b> 或者类似软件检测U盘的主控芯片组，然后下载对应的量产工具。我的台电4G U盘检测出主控芯片为 <b>Alcor AU6983</b> 主控芯片组，下载了对应量产工具为 <b>AlcorMP_UFD Version:10.10.1 20100930</b>
<br>

<hr>

<b>关于量产，高危动作，建议先搜索、学习相关内容，风险自负。</b><br>

<hr>

<br>
</blockquote><h4>2、运行量产工具</h4>
<blockquote>先运行量产工具，再插入U盘，检测到U盘信息如下图<br>
</blockquote><blockquote><img src='http://archlive.googlecode.com/hg/screenshots/Flash/Flash-01.jpg' />
<blockquote>选择 <b>设定</b>
</blockquote><img src='http://archlive.googlecode.com/hg/screenshots/Flash/Flash-02.jpg' />
<ul><li>载方式设定<b>中选择</b>autorun<b>， 则加载iso文件为上面保存的 Archlive.iso<br>
</li></ul><img src='http://archlive.googlecode.com/hg/screenshots/Flash/Flash-03.jpg' />
<img src='http://archlive.googlecode.com/hg/screenshots/Flash/Flash-04.jpg' />
<blockquote>这步很关键，如下图设置，参数跟</b>规划<b>里对应：<br>
</blockquote><img src='http://archlive.googlecode.com/hg/screenshots/Flash/Flash-05.jpg' />
<blockquote>其它设置同一般的量产教程<br>
</blockquote><img src='http://archlive.googlecode.com/hg/screenshots/Flash/Flash-06.jpg' />
<img src='http://archlive.googlecode.com/hg/screenshots/Flash/Flash-07.jpg' />
<blockquote>量产完成<br>
</blockquote><img src='http://archlive.googlecode.com/hg/screenshots/Flash/Flash-08.jpg' /></blockquote></blockquote></b>

<h3>4、重新启动</h3>
<blockquote>体验。。。<br>
</blockquote><blockquote>如果出现错误，重新启动，在启动参数中加入 <b>debug</b> ， 分步骤启动，反馈错误提示。