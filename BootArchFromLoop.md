If U r Chinese, you can see http://www.linuxsir.org/bbs/thread375524.html

# Boot Arch GNU/Linux from loop device/file #

## Why need? ##
  * If you have many systems installed in your computer, and don't want your partition table not so complex, then you need it;
> > Like me, Windows Xp and Windows 7 (in VHD), Arch GNU/Linux X86\_64, Arch GNU/Linux i686 and Deepinlinux (base on Ubuntu) installed.
  * If you a Arch installer or other developers, just want to test to install your Arch without change present partitions, then you need it;
  * ...Anything else you can make out...

## Background: ##
  * Official init-scripts of Arch GNU/Linux don't support boot Arch GNU/Linux from loop devices;
  * Need bootloader such as GRUB2, support boot from loop devices;

## TARGET: ##

> Boot Arch GNU/Linux from a loop file.


&lt;hr&gt;


## Actions to achieve the target: ##

> ### 1. Create loop file ###
```
 dd if=/dev/zero of=/mnt/sda9/Arch/Arch-i686.img bs=1M count=3500 
```
> > This can create a loop file "Arch-i686.img" under directory /mnt/sda9/Arch/, with size 3.5GB


> ### 2. Create file-systems in loop file ###
```
 mkfs.reiserfs /mnt/sda9/Arch/Arch-i686.img
```
> > Here use reiserfs for example, also can use ext2 ext3 ext4 ....
    * And I had test btrfs, can't be supported at present, maybe there are some bugs for grub2-btrfs, which can browser btrfs partition or loop file, while can't loading kernel and initrd-img.


> ### 3. Install or move Arch GNU/Linux into loop file ###
```
 sudo mount /mnt/sda9/Arch/Arch-i686.img /tmp/install 
```
> > Then you can install Arch GNU/Linux into directory "/tmp/instal", you can see WIKI for details.
> > Here just use move for example:
```
 cd / && sudo tar cvpf - / --exclude=/mnt --exclude=/media --exclude=/sys \
--exclude=/proc --exclude=/var/abs --exclude=/var/cache/pacman/pkg \
--exclude=/var/lib/pacman/sync | sudo tar xvpf - -C /tmp/install 
```


> ### 4. Edit some settings ###
> > #### a). Create directory sys for later usage ####
```
 sudo mkdir /tmp/install/sys
```
> > #### b). Change /tmp/install/etc/fstab for the root line to: ####
```
 /dev/loop0          /             reiserfs          defaults   0    1
```


> ### 5. Create new boot image ###
> > This is the most import...
> > > #### a). create a install script: /tmp/install/lib/initcpio/install/automount,  content as: ####
```
install ()
{
    BINARIES="blkid"
    FILES=""
    SCRIPT="automount"
}

help ()
{
cat<<HELPEOF
  This hook auto mount the root device base on cmdline.
  Can support:
    1. Boot from normal harddisk or USB disk;
    2. Boot from CD-ROM or DVD-ROM;
    3. Boot from loop device file (made by dd or other tools);
    4. Boot from squashfs files;
   ...
HELPEOF
}
```
> > > #### b) Create a hook: /tmp/install/lib/initcpio/hooks/automount, as: ####
```
run_hook ()
{
    # Boot parameters as: real_root=loop=/dev/sda1 loopfile=Arch/Arch-i686.img
    case ${real_root} in loop\=*) 
    loop=${real_root/loop=}
    if [ -e $loop ]; then
        fstype=$(blkid -u filesystem -o value -s TYPE -p "${loop}")
        if [ "${readwrite}" = "no" ]; then rwopt="ro"; else rwopt="rw"; fi
        mount -t $fstype -o $rwopt $loop $HOST
        if [ -f $HOST/$loopfile ]; then
            loopfile="$HOST/$loopfile"
            fstype=$(blkid -u filesystem -o value -s TYPE -p "${loopfile}")
            if [ "${fstype}" = "squashfs" ]; then rwopt="ro"; fi
            mount -t $fstype -o $rwopt $loopfile $UNION
            mkdir -p $UNION$HOST
            mkdir -p $UNION$loop
            mount -o bind $HOST $UNION$loop
            MOUNTED=1
        fi
    fi
    ;;
    esac
}
```
        * Only for example, so keep it simple...
        * You can change as you like, at your own risk... Haha
        * Welcome experts to develop this script...
> > > #### c) Edit /tmp/install/etc/mkinitcpio.conf, add "automount" in HOOKS line as: ####
```
  HOOKS="base udev autodetect pata scsi sata filesystems automount" 
```
> > > #### d) Edit /tmp/install/lib/initcpio/init ####
> > > > Add below code before "# set default mount handler"
```
export HOST="/host"
export UNION="/new_root"
mkdir -p $HOST
# Change to "MOUNTED=1" when root mounted successfully.
export MOUNTED="0"
```
> > > > Change "${mount\_handler} /new\_root" to:
```
# If hook scripts success mounted root, then skip Arch default mount handler. 
if [ "$MOUNTED" = "0" ]; then ${mount_handler} $UNION; fi 
```

> > > #### e) Re-create boot kernel image (initrd) ####
```
sudo mount -o bind /sys /tmp/install/sys
sudo chroot /tmp/install mkinitcpio -p kernel26 
```
Then, till now, loop file created successfully.

> ### 6. Change boot loader configuration file ###
> > There are many boot methods, such as:
    1. Boot from GRUB2 directly;
    1. ntldr --> g2ldr
    1. grub --> grub2
> > ....
> > I use method 2), need use mkimage to make boot loader file "g2ldr".
> > Any way, the configuration file is almost same. Need to change grub.cfg (configuration file of grub2), section of Arch on loop as:
```
menuentry "Arch i686 (on loop)" {
    insmod part_msdos
    insmod reiserfs
    insmod loopback
    loopback loop0 (hd0,msdos9)/Arch/Arch-i686.img
    set root=(loop0)
    linux /boot/vmlinuz26 real_root=loop=/dev/sda9 loopfile=Arch/Arch-i686.img  quiet 
    initrd /boot/kernel26-fallback.img
}
```

**Then you can reboot, then select "Arch i686 (on loop)" to boot from loop file.**



&lt;hr&gt;


# After ... #
**Develop "automount", then you can boot from squashfs file,  and mount memory or other loop file, also you can make it as ROM system, if you like...** Also can develop automount, so that Arch GNU/Linux can support lubi, wubi...



&lt;hr&gt;


# In this initiate, and welcome to explore. . . #