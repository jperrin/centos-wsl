# This is a minimal-ish kickstart for Windows Subsystem for Linux
# It will not produce a bootable system
# To use this kickstart, run the following command
# livemedia-creator --make-tar --no-virt\
#   --project "CentOS Stream" --releasever "8" \
#   --ks=centos-stream-wsl.ks \
#   --image-name=centos-stream-wsl.tar.xz

# Basic setup information
url --url="https://mirrors.edge.kernel.org/centos/8-stream/BaseOS/x86_64/os/"
install
keyboard us
rootpw --lock --iscrypted locked
timezone --isUtc --nontp UTC
selinux --disabled
firewall --disabled
network --bootproto=dhcp --device=link --activate --onboot=on
shutdown
bootloader --disable
lang en_US

# Repositories to use
repo --name="CentOSbase" --baseurl=https://mirrors.edge.kernel.org/centos/8-stream/BaseOS/x86_64/os/
## Uncomment for rolling builds
repo --name="AppStream" --baseurl=https://mirrors.edge.kernel.org/centos/8-stream/AppStream/x86_64/os/
repo --name="wslu" --baseurl=https://download.opensuse.org/repositories/home:/wslutilities/CentOS_8/
repo --name="epel" --baseurl=https://mirrors.kernel.org/fedora-epel/8/Everything/x86_64/
# Disk setup
zerombr
clearpart --all --initlabel
part / --size 3000 --fstype ext4

# Package setup
%packages --instLangs=en --nocore
centos-release
binutils
-brotli
bash
hostname
rootfiles
glibc-minimal-langpack
less
-gettext*
-firewalld
-os-prober*
tar
findutils
wget
curl
man
man-pages 
-iptables
iputils
iproute
bash-completion
-kernel
-dosfstools
-e2fsprogs
-fuse-libs
-gnupg2-smime
-libss
-pinentry
-trousers
-xkeyboard-config
-xfsprogs
-qemu-guest-agent
vim-enhanced
tar
tree
file
ncurses
sudo
yum
yum-utils
git
wslu
-grub\*
%end


%post --log=/anaconda-post.log
# Post configure tasks for wsl
#add the wslu repo
cat >/etc/yum.repos.d/wslutilities.repo <<EOF
[home_wslutilities]
name=home:wslutilities (CentOS_8)
type=rpm-md
baseurl=https://download.opensuse.org/repositories/home:/wslutilities/CentOS_8/
gpgcheck=1
gpgkey=https://download.opensuse.org/repositories/home:/wslutilities/CentOS_8/repodata/repomd.xml.key
enabled=1
EOF





##Setup locale properly
# Commenting out, as this seems to no longer be needed
#rm -f /usr/lib/locale/locale-archive
#localedef -v -c -i en_US -f UTF-8 en_US.UTF-8

## Systemd fixes
# no machine-id by default.
:> /etc/machine-id
# Fix /run/lock breakage since it's not tmpfs in docker
# Make sure login works

#Generate installtime file record
/bin/date +%Y%m%d_%H%M > /etc/BUILDTIME


%end
