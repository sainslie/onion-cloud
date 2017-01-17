#!/bin/bash
="`whoami`";
="`lsb_release -c|cut -f2`";
="/etc/apt/sources.list";
="";
="/etc/tor/torrc";
="`curl -m 5 http://169.254.169.254/latest/meta-data/reservation-id | sed 's/-//'`";
="/etc/apt/apt.conf.d/10periodic"
="/etc/apt/apt.conf.d/50unattended-upgrades"
="/etc/network/interfaces"
="/etc/apt/trusted.gpg.d/886DDD89.asc"

# 
if [ "$" != "root" ]; then
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
apt-get install apt-transport-tor
apt-get install tlsdate
apt-get install ca-certificates
apt-get -y upgrade

# 
# 
echo ""

# 
cp /etc/apt/apt.conf.d/10periodic /etc/apt/apt.conf.d/10periodic
wget https://www.onioncloud.org/10periodic
mv /home/ubuntu/10periodic /etc/apt/apt.conf.d/10periodic
cp /etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
wget https://www.onioncloud.org/50unattended-upgrades
mv /home/ubuntu/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades

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
case "" in
   "" ) echo "";;
   "" ) echo "";;
   "" ) echo "";;
   * )
echo "";
echo "";
echo "";
echo "";
echo "";
exit 2;
    ;;
esac

# 
cp /home/ubuntu/.gnupg/gpg.conf /home/ubuntu/.gnupg/gpg.conf
wget https://www.onioncloud.org/gpg.conf
mv /home/ubuntu/gpg.conf /home/ubuntu/.gnupg/gpg.conf

# 
cp /etc/apt/sources.list /etc/tor/sources.list
wget https://www.onioncloud.org/sources.list
mv /home/ubuntu/sources.list /etc/apt/sources.list

# 
echo ""
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ${} ubuntu@${} -q -t "sudo gpg --keyserver hkps://keyserver.ubuntu.com --recv-key 4D4C6404"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ${} ubuntu@${} -q -t "if [ `echo $?` -eq "1" ]; then echo '' ; sudo rm /home/ubuntu/.ssh/authorized_keys ; fi" > /etc/
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ${} ubuntu@${} -q -t "cd /mnt ; sudo gpg --verify SHA256SUMS.gpg SHA256SUMS"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ${} ubuntu@${} -q -t "cd /mnt ; sudo sha256sum -c SHA256SUMS 2>&1 | grep OK"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ${} ubuntu@${} -q -t "echo $?"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ${} ubuntu@${} -q -t "if [ `echo $?` -eq "1" ]; then echo '' ; sudo rm /home/ubuntu/.ssh/authorized_keys ; fi" > /etc/

#
echo "";
sudo gpg --keyserver hkps://keyserver.ubuntu.com --recv 886DDD89
sudo gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
cat << EOF > 
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.10 (GNU/Linux)

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
=10NR
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

#
if [  == "" ]; then
echo "";
cat << EOF > 
# 

#
Nickname $

# 
# 
SocksPort 0

# 
ORPort 443

# 
# 
ORListenAddress 0.0.0.0:9001

# 
BridgeRelay 1

# 
ServerTransportPlugin obfs2,obfs3 exec /usr/bin/obfsproxy --managed
ServerTransportPlugin obfs4 exec /usr/bin/obfs4proxy --managed
ServerTransportListenAddr obfs2 0.0.0.0:52176
ServerTransportListenAddr obfs3 0.0.0.0:40872
ServerTransportListenAddr obfs4 0.0.0.0:46396

# 
# 
# 
AccountingStart week 1 10:00
AccountingMax 10 GB
BandwidthRate 20KB
BandwidthBurst 1GB

# 
# 
ExitPolicy reject *:*
EOF

echo ""
echo "" > /etc/
echo ""
sleep 20
reboot
fi

#
if [  == "" ]; then
echo "";
cat << EOF > 
# 

#
Nickname $

# 
# 
SocksPort 0

# 
ORPort 443

# 
# 
ORListenAddress 0.0.0.0:9001

# 
BridgeRelay 1

# 
ServerTransportPlugin obfs2,obfs3 exec /usr/bin/obfsproxy --managed
ServerTransportPlugin obfs4 exec /usr/bin/obfs4proxy --managed
ServerTransportListenAddr obfs2 0.0.0.0:52176
ServerTransportListenAddr obfs3 0.0.0.0:40872
ServerTransportListenAddr obfs4 0.0.0.0:46396

# 
# 
# 
AccountingStart week 1 10:00
AccountingMax 10 GB
BandwidthRate 20KB
BandwidthBurst 1GB

# 
# 
ExitPolicy reject *:*
EOF

echo ""
echo "" > /etc/
echo ""
sleep 20
reboot
fi

# 
if [ $ == "" ]; then
echo "";

# 
cat << EOF > 
SocksPort 0
ORPort 443
ORListenAddress 0.0.0.0:9001
BridgeRelay 1
PublishServerDescriptor 0
AccountingStart week 1 10:00
AccountingMax 10 GB
ExitPolicy reject *:*
EOF

# 
cat << EOF > /etc/rc.local
#!/bin/sh -e
sudo screen tcpdump -v -i any -s 0 -w /root/
EOF
echo ""
echo "" > /etc/
echo ""
sleep 20
reboot
fi
