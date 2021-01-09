
#!/bin/bash

echo Install PXE server

# Авторизуемся для получения root прав
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Устанавливаем нужные пакеты
yum -y install epel-release

yum -y install mc vim tftp tftp-server syslinux xinetd httpd dhcp wget

# Добавляем исключение в firewall
firewall-cmd --add-service=tftp
firewall-cmd --add-service=httpd

# disable selinux or permissive
setenforce 0

# Создаем папку для установки из репозитория
mkdir /var/www/html/centos7-minimal-2009

# Скачиваем образ с зеркала, монтируем и копируем в папку для установки
wget https://mirror.yandex.ru/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso -O /tmp/centos7-minimal-2009.iso

mount -o loop,ro /tmp/centos7-minimal-2009.iso /mnt

cp -a /mnt/* /var/www/html/centos7-minimal-2009/
# chmod -R 644 /var/www/html/centos7-minimal-2009/

# Копируем конфиг для tftp сервера
cat /vagrant/config/tftp > /etc/xinetd.d/tftp

# Копируем необходимые файлы CentOS для нашего tftp сервера
cp -a /usr/share/syslinux/* /var/lib/tftpboot/

mkdir /var/lib/tftpboot/centos7-minimal-2009
cp /mnt/images/pxeboot/vmlinuz  /var/lib/tftpboot/centos7-minimal-2009/
cp /mnt/images/pxeboot/initrd.img  /var/lib/tftpboot/centos7-minimal-2009/

# Настраиваем поведение нашего pxe сервера
mkdir /var/lib/tftpboot/pxelinux.cfg
cat /vagrant/config/default > /var/lib/tftpboot/pxelinux.cfg/default

# Настраиваем dhcp сервер
cat /vagrant/config/dhcpd.conf > /etc/dhcp/dhcpd.conf

# systemctl enable dhcpd
# systemctl start dhcpd

# systemctl start httpd
# systemctl enable httpd

# systemctl start xinetd
# systemctl enable xinetd