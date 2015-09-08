# DIY Archlive #

## 1、取得脚本 ##
> hg clone http://mkarchlive.archlive.googlecode.com/hg mkarchlive<br></li></ul>

<h2>2、DIY Archlive 直通车 ##

> 获取到mkarchlive制作脚本后<br>
<blockquote>cd mkarchlive && (sudo sh ./mkarchlive all 2>&1 | tee ./log) <br>
(以上脚本解释：进入到mkarchlive目录, 并以root身份运行mkarchlive, 制作archlive的临时工作目录及<br>成品存放目录均在/YYDD 目录(archlive.conf文件定义)下， 并将制作日志存储于mkarchlive目录下的log中）<br>
如果不希望看到跳动的输出，可以将以上命令中的 " | tee ./log "改成 "> ./log" 即可“安静”地运行了！<p>
<h2>3、DIY Archlive 高级</h2></blockquote>

<blockquote>通过以下三种途径来定制：<br>
A. 修改配置文件mkarchlive/profiles/archlive/archlive.conf 来自定义软件仓、自定义软件清单、自定义主题、添加附加字体等<br>
B. 自编译软件，添加到软件清单中<br>
C. 修改mkarchlive/profiles/archlive/overlay文件夹下内容个性化定制（如果没有则mkarchlive会自动archlive googlecode下载archlive定制的overlay)<p>
<h2>4、定制参数优先级</h2></blockquote>

<blockquote>命令行输入参数 > archlive.conf定义参数 > 默认参数<br>
(以上优先级针对同一参数在多次定义时)<p>
<h2>5、制作完成后清理</h2></blockquote>

<blockquote>直接删除工作目录就可以了<br>
如果在制作过程中因为某些原因出现错误而终止或者Ctrl+C结束mkarchlive的执行，要删除工作目录<br>必须先卸载挂载于工作目录/union下的aufs文件系统，比如工作目录为 /archlive  则要<br> sudo umount /archlive/union && sudo rm -rf /archlive 来删除工作目录<br></blockquote>


截屏： <br>
<img src='http://archlive.googlecode.com/files/2009-09-07-091615.png' />
<img src='http://archlive.googlecode.com/files/2009-09-07-091646.png' />