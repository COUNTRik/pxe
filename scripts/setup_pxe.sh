
#!/bin/bash

echo Install PXE server

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

yum -y install epel-release

yum -y install mc vim tcpdump

yum -y install dhcp-server
yum -y install tftp-server
yum -y install nfs-utils
yum -y install httpd
firewall-cmd --add-service=tftp
firewall-cmd --add-service=httpd

# disable selinux or permissive
setenforce 0

cat /vagrant/config/dhcpd.conf > /etc/dhcp/dhcpd.conf 

systemctl start dhcpd

systemctl start tftp.service
yum -y install syslinux-tftpboot.noarch
mkdir /var/lib/tftpboot/pxelinux
cp /tftpboot/pxelinux.0 /var/lib/tftpboot/pxelinux
cp /tftpboot/libutil.c32 /var/lib/tftpboot/pxelinux
cp /tftpboot/menu.c32 /var/lib/tftpboot/pxelinux
cp /tftpboot/libmenu.c32 /var/lib/tftpboot/pxelinux
cp /tftpboot/ldlinux.c32 /var/lib/tftpboot/pxelinux
cp /tftpboot/vesamenu.c32 /var/lib/tftpboot/pxelinux

mkdir /var/lib/tftpboot/pxelinux/pxelinux.cfg

cat /vagrant/config/default > /var/lib/tftpboot/pxelinux/pxelinux.cfg/default

mkdir -p /var/lib/tftpboot/pxelinux/images/CentOS-8.2/
curl -O http://ftp.mgts.by/pub/CentOS/8.2.2004/BaseOS/x86_64/os/images/pxeboot/initrd.img
curl -O http://ftp.mgts.by/pub/CentOS/8.2.2004/BaseOS/x86_64/os/images/pxeboot/vmlinuz
cp {vmlinuz,initrd.img} /var/lib/tftpboot/pxelinux/images/CentOS-8.2/


# Setup NFS auto install
# 

curl -O http://ftp.mgts.by/pub/CentOS/8.2.2004/BaseOS/x86_64/os/images/boot.iso
mkdir /mnt/centos8-install
mount -t iso9660 boot.iso /mnt/centos8-install
echo '/mnt/centos8-install *(ro)' > /etc/exports
systemctl start nfs-server.service


autoinstall(){
  # to speedup replace URL with closest mirror
  curl -O http://ftp.mgts.by/pub/CentOS/8.2.2004/isos/x86_64/CentOS-8.2.2004-x86_64-minimal.iso
  mkdir /mnt/centos8-autoinstall
  mount -t iso9660 CentOS-8.2.2004-x86_64-minimal.iso /mnt/centos8-autoinstall
  echo '/mnt/centos8-autoinstall *(ro)' >> /etc/exports
  mkdir /home/vagrant/cfg
cat /vagrant/config/ks.cfg > /home/vagrant/cfg/ks.cfg 
echo '/home/vagrant/cfg *(ro)' >> /etc/exports
  systemctl reload nfs-server.service
}
# uncomment to enable automatic installation
#autoinstall
