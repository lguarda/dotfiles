# cheat sheet

## linux command

### editcap
```bash
# convert pcapng to pcap
editcap -F pcap pcapng_source.pcap  pcap_dest.pcap
```

### tshark
```bash
tshark -r input.pcap -Y "!(ip.addr == 211.111.1.1/16 && ip.dst == 212.111.1.1/16) && !(ip.addr == 212.111.1.1/16 && ip.dst ==211.111.1.1/16)" -w output.pcap
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

# sum number on each line
echo "num:1\nnum:5\nnum:10" | awk -F ":" '{ total += $2; count++ } END { print total/count }'

```
### xinput

```bash
xinput list # show devices

xinput list-props <device> # show devices

# example: enable tapping on a touch pad
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
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
# -0: slurp all file (useful for multi line regex)
# -e: allows you to provide the program as an argument rather than in a file.
# -p: places a printing loop around your command so that it acts on each line of standard input or file given in argument

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

## language

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
