#!/bin/bash
whoami="'whoami'";
HOSTNAME="'hostname'";
lsb_release="'lsb_release -cs'";
="/etc/apt/sources.list";
HOME="$HOME/";
torrc="/etc/tor/torrc";
reservation-id="'curl -m 5 http://169.254.169.254/latest/meta-data/reservation-id'";
10periodic="/etc/apt/apt.conf.d/10periodic";
50unattended-upgrades="/etc/apt/apt.conf.d/50unattended-upgrades";
interfaces="/etc/network/interfaces";
apt="/etc/apt/trusted.gpg.d/key0xEE8CBC9E886DDD89.asc";

# 
if [ "$whoami" != "root" ]; then
echo "";
echo "";
  exit 1;
fi

# 
echo ""
echo ""
echo ""
apt-get update
apt-get install apt-transport-https
apt-get install dialog
apt-get install ca-certificates
apt-get install gnupg-curl
apt-get install lsb-release
apt-get install tlsdate
apt-get -y upgrade

# 
# 
echo ""

# 
mv /etc/apt/apt.conf.d/10periodic ${HOME}/10periodic
wget -O /tmp/50unattended-upgrades
mv /tmp/10periodic /etc/apt/apt.conf.d/10periodic

mv /etc/apt/apt.conf.d/50unattended-upgrades ${HOME}/50unattended-upgrades
wget -O /tmp/50unattended-upgrades
mv /tmp/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades

mv ${HOME}/.gnupg/gpg.conf ${HOME}/.gnupg/gpg.conf
wget -O /tmp/gpg.conf
mv /tmp/gpg.conf ${HOME}/.gnupg/gpg.conf

mv /etc/apt/sources.list ${HOME}/sources.list
wget -O /tmp/sources.list
mv /tmp/sources.list ${HOME}/sources.list

# 
echo ""
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "sudo gpg --keyserver hkps://keyserver.ubuntu.com --keyserver-options ca-cert-file=DigiCert Global Root CA --recv-key 4D4C6404"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "if [ `echo $?` -eq "1" ]; then echo '' ; sudo rm /home/ubuntu/.ssh/authorized_keys ; fi" > /etc/
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "cd /mnt ; sudo gpg --verify SHA256SUMS.gpg SHA256SUMS"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "cd /mnt ; sudo sha256sum -c SHA256SUMS 2>&1 | grep OK"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "echo $?"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "if [ `echo $?` -eq "1" ]; then echo '' ; sudo rm /home/ubuntu/.ssh/authorized_keys ; fi" > /etc/

#
echo "";
gpg --keyserver hkps://keyserver.ubuntu.com --keyserver-options ca-cert-file=DigiCert Global Root CA --recv-key 886DDD89
 gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
cat << EOF > 
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

mQENBEqg7GsBCACsef8koRT8UyZxiv1Irke5nVpte54TDtTl1za1tOKfthmHbs2I
4DHWG3qrwGayw+6yb5mMFe0h9Ap9IbilA5a1IdRsdDgViyQQ3kvdfoavFHRxvGON
tknIyk5Goa36GMBl84gQceRs/4Zx3kxqCV+JYXE9CmdkpkVrh2K3j5+ysDWfD/kO
dTzwu3WHaAwL8d5MJAGQn2i6bTw4UHytrYemS1DdG/0EThCCyAnPmmb8iBkZlSW8
6MzVqTrN37yvYWTXk6MwKH50twaX5hzZAlSh9eqRjZLq51DDomO7EumXP90rS5mT
QrS+wiYfGQttoZfbh3wl5ZjejgEjx+qrnOH7ABEBAAG0JmRlYi50b3Jwcm9qZWN0
Lm9yZyBhcmNoaXZlIHNpZ25pbmcga2V5iQE8BBMBAgAmAhsDBgsJCAcDAgQVAggD
BBYCAwECHgECF4AFAlQDRrwFCRSpj0cACgkQ7oy8noht3YnPxwgAp9e7yRer1v1G
oywrrfam3afWNy7G0bI5gf98WPrhkgc3capVVDpOe87OaeezeICP6duTE8S5Yurw
x+lbcCPZp7Co4uyjAdIjVHAhwGGhpzG34Y8Z6ebCd4z0AElNGpDQpMtKppLnCRRw
knuvpKBIn4sxDgsofIg6vo4i8nL5mrIzhDpfbW9NK9lV4KvmvB4T+X5ZzdTkQ0ya
1aHtGdMaTtKmOMVk/4ceGRDw65pllGEo4ZQEgGVZ3TmNHidiuShGqiVEbSDGRFEV
OUiF9yvR+u6h/9iqULxOoAOfYMuGtatjrZM46d8DR2O1o00nbGHWYaQVqimGd52W
rCJghAIMxbkBDQRKoO2QAQgA2uKxSRSKpd2JO1ODUDuxppYacY1JkemxDUEHG31c
qCVTuFz4alNyl4I+8pmtX2i+YH7W9ew7uGgjRzPEjTOm8/Zz2ue+eQeroveuo0hy
Fa9Y3CxhNMCE3EH4AufdofuCmnUf/W7TzyIvzecrwFPlyZhqWnmxEqu8FaR+jXK9
Jsx2Zby/EihNoCwQOWtdv3I4Oi5KBbglxfxE7PmYgo9DYqTmHxmsnPiUE4FYZG26
3Ll1ZqkbwW77nwDEl1uh+tjbOu+Y1cKwecWbyVIuY1eKOnzVC88ldVSKxzKOGu37
My4z65GTByMQfMBnoZ+FZFGYiCiThj+c8i93DIRzYeOsjQARAQABiQJEBBgBAgAP
AhsCBQJQPjNzBQkJX6zhASnAXSAEGQECAAYFAkqg7ZAACgkQdKlBuiGeyBC0EQf5
Af/G0/2xz0QwH58N6Cx/ZoMctPbxim+F+MtZWtiZdGJ7G1wFGILAtPqSG6WEDa+T
hOeHbZ1uGvzuFS24IlkZHljgTZlL30p8DFdy73pajoqLRfrrkb9DJTGgVhP2axhn
OW/Q6Zu4hoQPSn2VGVOVmuwMb3r1r93fQbw0bQy/oIf9J+q2rbp4/chOodd7XMW9
5VMwiWIEdpYaD0moeK7+abYzBTG5ADMuZoK2ZrkteQZNQexSu4h0emWerLsMdvcM
LyYiOdWP128+s1e/nibHGFPAeRPkQ+MVPMZlrqgVq9i34XPA9HrtxVBd/PuOHoaS
1yrGuADspSZTC5on4PMaQgkQ7oy8noht3Yn+Nwf/bLfZW9RUqCQAmw1L5QLfMYb3
GAIFqx/h34y3MBToEzXqnfSEkZGM1iZtIgO1i3oVOGVlaGaE+wQKhg6zJZ6oTOZ+
/ufRO/xdmfGHZdlAfUEau/YiLknElEUNAQdUNuMB9TUtmBvh00aYoOjzRoAentTS
+/3p3+iQXK8NPJjQWBNToUVUQiYD9bBCIK/aHhBhmdEc0YfcWyQgd6IL7547BRJb
PDjuOyAfRWLJ17uJMGYqOFTkputmpG8n0dG0yUcUI4MoA8U79iG83EAd5vTS1eJi
Tmc+PLBneknviBEBiSRO4Yu5q4QxksOqYhFYBzOj6HXwgJCczVEZUCnuW7kHw4kC
RAQYAQIADwIbAgUCVANGwQUJEOcnLwEpwF0gBBkBAgAGBQJKoO2QAAoJEHSpQboh
nsgQtBEH+QH/xtP9sc9EMB+fDegsf2aDHLT28YpvhfjLWVrYmXRiextcBRiCwLT6
khulhA2vk4Tnh22dbhr87hUtuCJZGR5Y4E2ZS99KfAxXcu96Wo6Ki0X665G/QyUx
oFYT9msYZzlv0OmbuIaED0p9lRlTlZrsDG969a/d30G8NG0Mv6CH/Sfqtq26eP3I
TqHXe1zFveVTMIliBHaWGg9JqHiu/mm2MwUxuQAzLmaCtma5LXkGTUHsUruIdHpl
nqy7DHb3DC8mIjnVj9dvPrNXv54mxxhTwHkT5EPjFTzGZa6oFavYt+FzwPR67cVQ
Xfz7jh6GktcqxrgA7KUmUwuaJ+DzGkIJEO6MvJ6Ibd2JiakIAKqtDaLgc796crcZ
0vwQGlf5+H3OBj/sYkyNAByDdN2ZsuO7M1FT4OZcCBHqKScbeSfJQrqSQscSAURU
+fTGxNJrEDk9S975YAXiInRk71XawUNWhEqER5vshyLOx9es5FJo/rw7v253t+vz
KElNG3NhDnAe4UOQM73W2YfbWI6cikzwiWxHttO0oHByd/nqxMUP2onXQMI8fRRn
RQmQKEzXZq46TVETp6N3WyBu30gjuz1Twq3QsS9Ga7crrhHk4E33FsU0Lq2GDTsT
7+rFxdVTTyCVQU33QEdmZYU6SIxTDllyYF1ooqfJWMtwvwFNW6YElduoCCJZNQJ5
zR1QR/k=
=iLXB
-----END PGP PUBLIC KEY BLOCK-----
EOF
apt-key add 

#
echo "";
apt-get update
apt-get -y install tor tor-geoipdb tor-arm deb.torproject.org-keyring obfsproxy obfs4proxy

#
echo "";
cp /etc/tor/torrc /etc/tor/torrc

=20
=120
=2
=""
=""
=""

=(1 "" 2 "" 3 "")

=$(dialog --clear \ --backtitle "" \ --title "" \ --menu "" \ \ "" \ 2>&1 >/dev/tty)

clear
	case in
	1)
	cat << EOF > ${torrc}
	Nickname $
	SocksPort 0
	ORPort 443
	ORListenAddress 0.0.0.0:9001
	BridgeRelay 1
	ServerTransportPlugin obfs2,obfs3 exec /usr/bin/obfsproxy --managed
	ServerTransportPlugin obfs4 exec /usr/bin/obfs4proxy --managed
	ServerTransportListenAddr obfs2 0.0.0.0:52176
	ServerTransportListenAddr obfs3 0.0.0.0:40872
	ServerTransportListenAddr obfs4 0.0.0.0:46396
	AccountingStart week 1 10:00
	AccountingMax 10 GB
	BandwidthRate 20KB
	BandwidthBurst 1GB
	ExitPolicy reject *:*
	EOF
	;;
	2)
	cat << EOF > ${torrc}
	Nickname $
	SocksPort 0
	ORPort 443
	ORListenAddress 0.0.0.0:9001
	BridgeRelay 1
	ServerTransportPlugin obfs2,obfs3 exec /usr/bin/obfsproxy --managed
	ServerTransportPlugin obfs4 exec /usr/bin/obfs4proxy --managed
	ServerTransportListenAddr obfs2 0.0.0.0:52176
	ServerTransportListenAddr obfs3 0.0.0.0:40872
	ServerTransportListenAddr obfs4 0.0.0.0:46396
	AccountingStart week 1 10:00
	AccountingMax 10 GB
	BandwidthRate 20KB
	BandwidthBurst 1GB
	ExitPolicy reject *:*
	EOF
	;;
	3)
	cat << EOF > ${torrc}
	SocksPort 0
	ORPort 443
	ORListenAddress 0.0.0.0:9001
	BridgeRelay 1
	PublishServerDescriptor 0
	AccountingStart week 1 10:00
	AccountingMax 10 GB
	ExitPolicy reject *:*
	EOF
	;;
	esac
clear

# 
echo ""
iptables -F
iptables -t nat PREROUTING ACCEPT [0:0]
iptables -t nat POSTROUTING ACCEPT [77:6173]
iptables -t nat OUTPUT ACCEPT [77:6173]
iptables -t nat -A PREROUTING -i eth0 -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 9001 
iptables COMMIT
iptables save

# 
cat << EOF > /etc/rc.local
#!/bin/sh -e
sudo screen tcpdump -v -i any -s 0 -w ${HOME}/eth0.cap
EOF
echo ""
echo "" > /etc/ubuntu-16.04-server-cloudimg-amd64.tar.gz.sh
echo ""
sleep 20
reboot
fi
