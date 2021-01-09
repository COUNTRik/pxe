# Настройка PXE

Материал основан на [этой статье](https://jc0b.computer/posts/public/pxe-server-centos7/).

Запустим сачала *pxeserver*

	$ vagrant up pxeserver

Вместе с ним будет произведена установка и первоначальная настройка pxe сервера. Все действия описаны в комментариях к скрипту *pxe.sh*.

Теперь запустим в *pxeserver* dhcp, xinetd, httpd

	# systemctl enable dhcpd
	# systemctl start dhcpd

	# systemctl start httpd
	# systemctl enable httpd

	# systemctl start xinetd
	# systemctl enable xinetd

Теперь запустим *pxeclient* 

	$ vagrant up pxeclient

После на его экране должно появится меню с установкой *PXE Boot Menu*