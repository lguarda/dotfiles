# cheat sheet

## linux command

### gcc
```bash
# add include path for compilation
 -I mylib/include
# add dynamic library path for comilation
 -L mylib
# add dynamic lib for compilation
 -lmylib
# in the binary add prefered path to lib so you don't need to use LD_LIBRARY_PATH
# neither install the lib a known path or edit /etc/ld.so.conf.d/mylib.conf
 -Wl,-R/home/user/path/to/mylib

# get default gcc std version
gcc -dM -E -x c  /dev/null | grep -i stdc_version
gcc -dM -E -x c++  /dev/null | grep -F __cplusplus

```

### ssh

From:~?
Supported escape sequences:
 ~.   - terminate connection (and any multiplexed sessions)
 ~B   - send a BREAK to the remote system
 ~C   - open a command line
 ~R   - request rekey
 ~V/v - decrease/increase verbosity (LogLevel)
 ~^Z  - suspend ssh
 ~#   - list forwarded connections
 ~&   - background ssh (when waiting for connections to terminate)
 ~?   - this message
 ~~   - send the escape character by typing it twice


### git bisec
```bash
#clone specific branch without history
git clone --depth 1  --branch=$branch git@github.com:$repo $name

# bisect
# good and bad is missleading, we can't revers the order of bad and good
git bisect start
git bisect bad
git bisec good HEAD~100 # Or the targeted commit
git bisect run sh -c '{command that return 1/0 in case of sucess/fail}'
```

### git bisect du pauvre
How to git bisect a but within a single commit
```bash
while true ; do echo -e "y\nq\n" | git checkout -p {COMMIT} ; {COMMMAND} | grep {PATTERN} && break; done 
```

### git apply patch with commit aka: checrry pick across local repository
```bash
# inside repo1
git format-patch --stdout HEAD~3 > repo2/patch

# in repo2
git am patch
```

### git remote clone from a trusted machine
```bash
ssh-add {idrsa_git}
ssh -A {remote_host}
#or put this in conf
echo 'Host remote_host
    ForwardAgent yes'
# then
ssh {remote_host}
 +# at this point any of these command will be able to use ssh agent
# of the first machine
# keep in mind that ssh agent forwarding is succeptible to Man in the middle
git clone || git fetch --all || git submodule update --init

# change remote url to https
git remote set-url origin $(git config --get remote.origin.url | perl -ne '/(github.com)[:\/]+(.+?\/.+)/g && print "https://$1/$2\n"')
# change remote url to ssh
git remote set-url origin $(git config --get remote.origin.url | perl -ne '/(github.com)[:\/]+(.+?\/.+)/g && print "git\@$1:$2.git\n"')
```

### bash
debug bash script line by line without modifying the script
```bash
bash -e <(echo 'trap read debug' && cat ./test.sh)
```

Shortcut variable
```bash
ME="${0##*/}" # current script name
MY_DIR="${0%/*}" # current script directory
```

### editcap
```bash
# convert pcapng to pcap
editcap -F pcap pcapng_source.pcap  pcap_dest.pcap
# crop pcap by time -a start time -b end time
editcap -A "2019-10-23 10:00:00" -B "2019-10-23 11:00:00"
```

### tshark
```bash
tshark -r input.pcap -Y "!(ip.addr == 211.111.1.1/16 && ip.dst == 212.111.1.1/16) && !(ip.addr == 212.111.1.1/16 && ip.dst ==211.111.1.1/16)" -w output.pcap
```

### tcpdump
```bash
# -w is the output file name date format can be used
# -W 3 -G 60 pcap roation occur every 60 second 3 time
# -z this option enable postrotate command in this case the pcap is gziped
tcpdump -i wlp58s0 -w /tmp/trace-%m-%d-%H-%M-%S-%s -W 3 -G 60 -z gzip
```

### sox
Nice usage of sox is to normalise sound level of wav file
it can also be used on mp3 with libsoxmp3 somthing
```bash
# here used for batch processing files
for file in *.wav; do sox "$file" "n_$file" norm -0.1; done
```

### awk
```bash
# Change separator
awk -F ", "

# Column printing
echo "a, b, c" | awk -F ", " '{print $1" "$3}' #print "a c"

# Search filter
echo "one story\ntwo bullshit" | awk '/one/' # print "one story"
echo "one story\ntwo bullshit\nthree bullshit story" | awk '/story/ && /three/' # print "three bullshit story"

# Sort by date and variable example
echo "2018-12-11T00:00:01,000000Z,data1
2018-12-11T00:00:02,000000Z,data2
2018-12-11T00:00:03,000000Z,data3" |

awk -F "," -v date="2018-12-11T00:00:01,000000Z" -v date2="2018-12-11T00:00:02,000000Z" '$1>date && $1<date2'

# Sort by column
echo "c,3,data3
a,2,data2
d,3,data4
b,1,data1" |

sort --field-separator=',' --key=2

# Sort by column and uniq by column

echo "c,3,data3
a,2,data2
d,3,data4
b,1,data1" |

sort --field-separator=',' --key=2 | awk -F"," '!_[$2]++'

# Call system command in awk

echo "a,b,c\ne,b,z" | awk -F ',' '{system("colorize.sh " $1",");printf "%s,",$2;system("colorize.sh " $3);printf "\n"}' | sort --field-separator=',' --key=2

# apply regex on field before print
echo "one;def;veg\neth;bhf;ftr\none;5e3232;as\n123;eeee;eeee" | awk -F';' '$1=="one" && $2 ~ /.e.*/ {print $3}'

# sum number on each line
echo "num:1\nnum:5\nnum:10" | awk -F ":" '{ total += $2; count++ } END { print total/count }'
```

### crontab
```bash
# to start write contab
crontab -e
# to start write contab as root
sudo crontab -e
```
```crontab
# to perform contab on reboot
@reboot command
# every 5 minute
*/5 * * * * command
# else go to https://crontab.guru
```

### xinput
```bash
xinput list # show devices

xinput list-props <device> # show devices

# example: enable tapping on a touch pad
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
```

### rsync
```bash
# copy file to a "sudo" location #root
rsync --rsync-path="sudo rsync" ./file  user@tart:/opt/p1/ptm/scripts/guest/
```

### tpmfs
```bash
sudo mkdir /mnt/tmpfs && sudo mount -t tmpfs -o size=512m tmpfs /mnt/tmpfs
sudo umount /mnt/tmpfs
```

### perl command line
```bash
# advanced sed regex

# -i: replace in file instead of print stdout
# -0: slurp all file useful for multi line regex you can find -0777 on the web but -0 work
# -e: allows you to provide the program as an argument rather than in a file.
# -p: places a printing loop around your command so that it acts on each line of standard input or file given in argument
# -n: same as -p but only print your match

# advanced sed
# regex option /m multi line
# regex option /g global, don't stop on first match
perl -i -0 -pe 's/match/replace/mg' file_to_sed
#same as
sed -i -r "s/match/replace/g" file_to_sed

# advanced grep (with true regex)
git --no-pager shortlog -esn | perl -ne '/<(.*)>/ && print "$1\n"'
#same as (without group selection)
git --no-pager shortlog -esn | grep -Po "<.*>"

# multiline first match
echo "abc=3\ndef=4"| perl -0 -ne 'm/(\w+)=(\d)/g && print "$2|$1\n";'

# multiline and multi match
echo "abc=3\ndef=4"| perl -0 -ne 'while(m/(\w+)=(\d)/g){print "$2|$1\n";}'
```

### parted onliner
```bash
# Basic example for creating *standard* linux partitions
# create MBR partitioning
parted /dev/sda -- mklabel msdos
# create boot partition
parted /dev/sda -- mkpart primary 1MiB 512MiB
# use the rest for lvm partition
parted /dev/sda -- mkpart primary 512MiB 100%
# add boot flag to the boot partition
parted /dev/sda set 1 boot on

# setup encryption on for the entire lvm
cryptsetup luksFormat /dev/sda2
# open encrypted partition
cryptsetup luksOpen /dev/sda2 crypted

# start lvm partition
pvcreate /dev/mapper/crypted
# create lvm partition named fde
vgcreate fde /dev/mapper/crypted
# create lvm sub partition
lvcreate -n root fde -L 8GB
lvcreate -n home fde -l 100%FREE

# set boot partition to ext2
mkfs.ext2 /dev/sda1
# other to ext4
mkfs.ext4 /dev/fde/root
mkfs.ext4 /dev/fde/home
```

### progress onliner
```bash
# change the pid then copypaste this script to get file progress information
pid=90700; for i in /proc/$pid/fd/*;do
a=$(sudo stat -L $i | perl -ne '/Size:\s+(\d+)/ && print "$1\n"');
f=$(sudo stat -L $i | perl -ne '/File:\s+(.*)/ && print "$1\n"')
b=$(sudo cat /proc/$pid/fdinfo/`basename $i`| perl -ne '/^pos:\s*(\d*)/ && print "$1\n"');
if [ "$a" -gt "0" ] ; then echo "file $f: $(bc -l <<< $b/$a)"; fi;
done
```

### dd (aka:bootable usb key maker)
https://askubuntu.com/questions/372607/how-to-create-a-bootable-ubuntu-usb-flash-drive-from-terminal
```bash
sudo umount /dev/sd<?><?>
```

where <?><?> is a letter followed by a number, look it up by running lsblk.

It will look something like
```
sdb      8:16   1  14.9G  0 disk
├─sdb1   8:17   1   1.6G  0 part /media/username/usb volume name
└─sdb2   8:18   1   2.4M  0 part
```

Then, next (this is a destructive command and wipes the entire USB drive with the contents of the iso, so be careful):

```bash
sudo dd bs=4M if=path/to/input.iso of=/dev/sd<?> conv=fdatasync  status=progress
```
where input.iso is the input file, and /dev/sd<?> is the USB device you're writing to (run lsblk to see all drives to find out what <?> is for your USB).
Note:for mac use lowercase for bs=4m:
```bash
sudo dd if=inputfile.img of=/dev/disk<?> bs=4m && sync
```
If USB drive does not boot (this happened to me), it is because the target is a particular partition on the drive instead of the drive. So the target needs to be /dev/sdc and not dev/sdc <?> For me it was /dev/sdb .

### socat
```bash
# this is pretty self explanatory, this will redirect the ip/port 127.0.0.1:8888
# to the ip/port 10.206.172.161:10000
socat TCP-LISTEN:8888,fork,bind=127.0.0.1 TCP:10.206.172.161:10000
```
### btrfs

Format to btrfs
```bash
# obviously
mkfs.btrfs /dev/xxx # -f force overwrite
```
Create subvolume
```bash
# most btrfs operation can only me performed when the volume is mounted
mount /dev/xxx /mnt

# btrfs support minumun lenght argument like vim command
btrfs subvolume create /mnt/@
btrfs su cr /mnt/@home
# it can be interesting to create boot subvolume in order to snapshot kernel
btrfs su cr /mnt/@boot
umount /mnt

mount -o noatime,compress=zstd,space_cache,subvol=@ /dev/sda3 /mnt
mkdir /mnt/{boot,home,var,opt,tmp,.snapshots}
mount -o noatime,compress=zstd,space_cache,subvol=@home /dev/sda3 /mnt/home
```

Workaround in order to make os-prober detect OS with btrfs subvolume
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=983107an
```bash
# I don't know exactly what os-prober to to find os depending on partition scheme it may be posible that only boot symlink is mandatory
sudo mount -t btrfs -o subvol=/,defaults /dev/nvme1n1p1 /mnt
cd /mnt
sudo ln -sf @/boot boot
sudo ln -sf @/etc  etc
sudo ln -sf @/usr  usr
sudo ln -sf @/lib  lib
sudo btrfs subvol set-default /mnt/@
# to revert defualt
#sudo btrfs subvol set-default "" /
# When you need to mount the root btrf
# sudo mount /dev/xxx -o subvol=/ /mnt
# This will mount root btfs wihtout change default subvolume
cd /
sudo umount /mnt
```

### snapper
First we need to create a config, the default config name is root, if you only
whant to snapshot un subvolume just don't change the same so you don't have to
retype -c config_name before every snapper command

```bash
# So creating the default config
snapper create-config / # here we will create config for / subvolume
# configuration can be edited on /etc/snapper/{root: what you type in -c option}
# Note: this will also create /.snapshots subvolumes
```
Don't forget to enable cron service, and that's it
``` bash
# It seems that if you don't create-config and
# only copy the config snapper don't detect it so create it first with
snapper -c root create-config
# inorder to list the snapshot
snapper -c root list # i will remove -c root since it's the default for next example
# create manual snapshot
snapper create --description "your description"
# list file difference
snapper status 2..5
# pretty self explanatory 2 and 5 are id found i list command .. mean everything
# in between those snapshots
# print actual diff for each file
snapper diff 2..5
```

Now this is greate we a have a wonderfull tool that create snapshot for us
unfortulately i don't know how to roll back thos snapshot with this tool
But we don't care it's realy easy with btrfs command
```bash
# The bad but quick solution that can be done on the file system we booted on
# rsync /.snapshots/56/snapshot/{what i want to rollback} /{what i want to rollback}
```
If you want to do a "safe" full rollback of a snapshot here what you need to do
First boot from another device that got btrfs command
```bash
# start by mounting root subvolume
mount -o subvol=/ /dev/xxx /mnt
# delete the subvolume you want to rollback
btrfs subvol detete /mnt/@
# then
btrfs subvol snap /mnt/@snashots/56/snapshot /mnt/@
# those final argument need to be read as source -> destination
```
Now the /mnt/@ is a the stats of snapshot id 56 you can reboot

## distro
### arch
``` bash
# This is my minumun arch install command
pacstrap /mnt base base-devel linux linux-firmware vim networkmanager btrfs-progs
```
#### pacman
```bash
pacman -Ss pkg # apt search pkg
pacman -Sy # apt update
pacman -S pkg # apt install pkg
pacman -Qu pkg # apt --list-upgradable
```
### nixos
```bash
# https://nixos.org/nixos/manual/
# http://stesie.github.io/2016/08/nixos-pt1
# mount different partition to /mnt
mount /dev/fde/root /mnt
mkdir -p /mnt/boot/ /mnt/home
mount /dev/fde/home /mnt/home
mount /dev/sda1 /mnt/boot
# generate /etc/nixos/{configuration.nix,hardware-configuration.nix}
nixos-generate-config --root /mnt
```
Then edit configuration.nix to setup boot
``` nix
{
  # BIOS BOOT (MBR)
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  # Tell initrd to unlock LUKS on /dev/sda2
  boot.initrd.luks.devices = [
    { name = "crypted"; device = "/dev/sda2"; preLVM = true; }
  ];
}
```
### deb-pkg
How to edit debian package
```bash
dpkg-deb -R package.deb dir
# make some modification to the raw directory
# than repackage
dpkg-deb -b dir package.deb
```
## program
### virtualization
#### Virtualbox
```bash
# ipmport ova to virtuabox
vboxmanage import --vsys 0 --memory 4096 --cpus 2 --vmname "vmname" vm.ova
# -n for dry run
```
#### lxc/lxd
```yaml
config: {}
networks:
- config:
    ipv4.address: auto
    ipv6.address: auto
  description: ""
  name: lxdbr0
  type: ""
  project: default
storage_pools:
- config:
    size: 10GB
  description: ""
  name: default
  driver: btrfs
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      network: lxdbr0
      type: nic
    root:
      path: /
      pool: default
      type: disk
  name: default
cluster: null
```
### DevOps
#### Ansible
```bash
# run ansible for one specific host with variable in command line
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i "192.168.56.106," -u ptm free_vm.yml --extra-vars "variable_host=all USER=ptm"
```
### Game
#### xboxdrv
xbox drv can emulate xbox input from another /dev/input/event
example below to with taranisqx7 mapping
```bash
sudo xboxdrv --evdev "/dev/input/event20" --evdev-keymap "BTN_A=a,BTN_B=b,BTN_C=x" --evdev-absmap "ABS_X=x1,ABS_Y=y1,ABS_RX=x2,ABS_RY=y2" --mimic-xpad --axismap "" --silent --detach-kernel-driver
# i don't understand why but it's not working for the first 2~3 minute
```

## language

### C/C++

#### asan
nice resources: https://github.com/google/sanitizers/wiki/AddressSanitizer
common issue:
- trace back is to short compile with `-fno-omit-frame-pointer` and/or run the program with ASAN_OPTIONS=fast_unwind_on_malloc=0

### lua

#### random
http://lua-users.org/wiki/MathLibraryTutorial
``` lua
math.random(100) -- return random number 1 to 100
math.random(0,3) --  0 to 3
math.randomseed(1234) -- use seed
```

#### memory usage
http://lua-users.org/wiki/MathLibraryTutorial
``` lua
collectgarbage("count") --returns the total memory in use by Lua (in Kbytes)
```

#### table for each loop
``` lua
for key,value in pairs({base="lol",[5]=1, [3]="as",[0]=123,[1]="ab", [2]=123}) do
    print(key, value)
end
-- use when the key or value _ is unused
for _,value in pairs({base="lol",[5]=1, [3]="as",[0]=123,[1]="ab", [2]=123}) do
    print(value)
end
-- ipaire is used for array part of lua table
-- it will only use continuous key from 1 to N
for key,value in ipairs({base="lol",[5]=1, [3]="as",[0]=123,[1]="ab", [2]=123}) do
    print(key,value)
end
```

#### read from stdin
csv example

``` lua
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

for line in io.lines() do
    local field1, field2, field3 = unpack(split(line, ";"))
    print(field1, field2, field3)
```

#### arg access
``` lua
local some_env_var = os.getenv("SOME_ENV_VAR")
print(some_env_var)
print(arg[1]) --name of the file
print(arg[2]) --first argument
print(arg[3]) --second argument
-- etc
```

## 3d printer
### anet a8 plus
```bash
# flashing klipper on anet a8 plus
avrdude -p atmega1282p -c arduino -b  115200 -P /dev/ttyUSB0 -U out/klipper.elf.hex
```

### klipper
prob command:
start z offset prob calibration (difference betwen teh nozzle and the prob)
```
PROBE_CALIBRATE
```
manualy move z axis
```
TESTZ Z=-1
```
```
ACCEPT or ABORT
```


