#!/bin/bash
export EC2_KEYPAIR=
export EC2_URL=
export EC2_PRIVATE_KEY=$HOME/
export EC2_CERT=$HOME/
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk/
amid-id="'curl -m 5 http://169.254.169.254/latest/meta-data/ami-id'";
availability-zone="'curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone'";
HOSTNAME="'curl -m 5 http://169.254.169.254/latest/meta-data/hostname'";
instance-id="'curl -m 5 http://169.254.169.254/latest/meta-data/instance-id'";
instance-type="'curl -m 5 http://169.254.169.254/latest/meta-data/instance-type'";
kernel-id="'curl -m 5 http://169.254.169.254/latest/meta-data/kernel-id'";
region="'curl -m 5 http://169.254.169.254/latest/meta-data/region'";
reservation-id="'curl -m 5 http://169.254.169.254/latest/meta-data/reservation-id'";
security-groups="'curl -m 5 http://169.254.169.254/latest/meta-data/security-groups'";

if [ -n "$" ]; then
        echo ""
else
	echo ""
        echo ""
        echo ""
        exit
fi

# 
echo ${region}
echo ${ami-id}
echo ${kernel-id}
echo ${instance-id}
echo ${availability-zone}
echo ${reservation-id}
echo ${instance-type}
sleep 25

# 
echo ""
volume_id=$(ec2-create-volume --encrypted --size 8 --region ${region} --availability-zone ${availability-zone} | awk {'print $'})
sleep 20
echo ""
ec2-attach-volume --instance ${instance-id} --region ${region} --device /dev/sdh ${volume_id}
sleep 20

# 
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "cd /mnt && sudo wget https://cloud-images.ubuntu.com/releases/xenial/release/SHA256SUMS && sudo wget https://cloud-images.ubuntu.com/releases/xenial/release/SHA256SUMS.gpg && sudo wget https://cloud-images.ubuntu.com/releases/xenial/release/ubuntu-16.04-server-cloudimg-amd64.tar.gz"

# 
echo ""
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "sudo gpg --keyserver keyserver.ubuntu.com --recv-key 843938DF228D22F7B3742BC0D94AA3F0EFE21092"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${$HOSTNAME} -q -t "sudo gpg --keyserver keyserver.ubuntu.com --recv-key C5986B4F1257FFA86632CBA746181433FBB75451"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "if [ `echo $?` -eq "1" ]; then echo '' ; sudo rm /home/ubuntu/.ssh/authorized_keys ; fi"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "cd /mnt ; sudo gpg --verify SHA256SUMS.gpg SHA256SUMS"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "cd /mnt ; sudo sha256sum -c SHA256SUMS 2>&1 | grep OK"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "echo $?"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "if [ `echo $?` -eq "1" ]; then echo '' ; sudo rm /home/ubuntu/.ssh/authorized_keys ; fi"

echo ""
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -t "sudo chown ubuntu:ubuntu /mnt && cd /mnt && tar -Sxvzf /mnt/ubuntu-16.04-server-cloudimg-amd64.tar.gz && sudo mkdir /mnt/src /mnt/target && sudo mount -o loop,rw /mnt/ubuntu-16.04-server-cloudimg-amd64-disk1.img /mnt/src && sudo mkfs.ext4 -F -L cloudimg-rootfs /dev/xvdh && sudo mount /dev/xvdh /mnt/target"

# 
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -v -t "sudo wget https://www.onioncloud.org/rc.local -O /mnt/src/etc/rc.local"

# 
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -v -t "sudo sed -i s/type// /mnt/src/etc/rc.local"

# 
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -v -t "sudo wget https://www.onioncloud.org/ec2-api-tools.sh -O /mnt/src/etc/ec2-api-tools.sh"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -v -t "sudo chmod +x /mnt/src/etc/ec2-api-tools.sh"

# 
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -v -t "sudo rsync -aXHAS /mnt/src/ /mnt/target"

# 
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${EC2_KEYPAIR} ubuntu@${HOSTNAME} -q -v -t "sudo umount /mnt/target && sudo umount /mnt/src"

# 
snapshot_id=$(ec2-create-snapshot --region ${region} ${volume_id} | grep ${volume_id}  | awk {'print $'})
echo "ec2-describe-snapshots --region ${region}"
ec2-describe-snapshots --region ${region} 
=$(ec2-describe-snapshots --region ${region} | grep ${snapshot_id}  | awk {'print $}')
echo $
while [ "$" != "" ]
do
=$(ec2-describe-snapshots --region ${region} | grep ${snapshot_id}  | awk {'print $}') && sleep 20
echo $
done

# 
=$(date +"%m-%d-%Y")
=$(echo `</dev/urandom tr -dc A-Za-z0-9 | head -c8`)

# 
echo ""
ec2-register --region ${region} --snapshot ${snapshot_id} --architecture=amd64 --kernel=${kernel-id} --name "ec2-api-tools-${}-${}-${}-${}" --description "ubuntu-16.04-server-cloudimg-amd64.tar.gz"

# 
ec2-detach-volume --region ${region} ${volume_id}
echo ""
echo ""
sleep 20
ec2-terminate-instances --region ${region} ${instance-id}
