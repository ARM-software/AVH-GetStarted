#!/bin/bash -e
set -e

################################
# PLEASE MODIFY THE VARS BELOW #
################################
# You can use any AVH AMI
avh_image_id="ami-07b00fa9adbbd2af5"
instance_type="t2.micro"
# Use the Mount Point Subnet
subnet_id="subnet-025b7baebd743a68b"
# Use the AVH EFS Security Group & some SSH inbound SG
security_group_ids="sg-0a9aa42b4737b3f86 sg-03afe5ec007b4bcb0"
key_name="common"

# private key absolute path associated with the key_name field
private_key_location="/c/Users/sampel01/OneDrive - Arm/.ssh/mcu_open_common.pem"

# EFS-related info
efs_dns_name=fs-014b24a7f24f3d529.efs.eu-west-1.amazonaws.com
file_system_id=fs-014b24a7f24f3d529
mount_point=/mnt/efs/fs1
packs_folder=packs
user_data="file://user_data.txt"

# Local path location (in this case expected in the same folder)
pack_name=Active-Semi.PAC52XX.2.1.0.pack

echo "Creating an AVH EC2 instance..."
instance_id=$(aws --output text ec2 run-instances \
    --image-id ${avh_image_id} \
    --instance-type ${instance_type} \
    --subnet-id ${subnet_id}  \
    --security-group-ids ${security_group_ids} \
    --key-name ${key_name} \
    --associate-public-ip-address \
    --user-data ${user_data} | awk '/INSTANCES/{print $9}')

echo "Waiting instance ${instance_id} to be running..."
aws ec2 wait instance-running \
    --instance-ids ${instance_id}

echo "Waiting instance ${instance_id} to be status OK..."
aws ec2 wait instance-status-ok \
    --instance-ids ${instance_id}

echo "Getting EC2 Public DNS for SSH & SCP"
public_dns=$(aws --output text ec2 describe-instances \
    --instance-ids ${instance_id} |  awk '/INSTANCES/{print $15}')
echo "EC2 Public DNS is $public_dns"

echo "Waiting for EFS mount point to be present..."
until ssh -i "${private_key_location}" -oStrictHostKeyChecking=no ubuntu@${public_dns} "df -h | grep ${file_system_id}"
do
    sleep 5
done

echo "Mount the EFS Pack folder to the /home/ubuntu/packs"
ssh -i "${private_key_location}" ubuntu@${public_dns} "rm -rf ~/packs && mkdir ~/packs"
ssh -i "${private_key_location}" ubuntu@${public_dns} "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns_name}:/${packs_folder} /home/ubuntu/${packs_folder}"

# list of PACK files you want to copy to the AVH EC2 instance (e.g. Active-Semi.PAC52XX.2.1.0)
scp -i "${private_key_location}" ${pack_name} ubuntu@${public_dns}:/tmp/.

# Install the local pack files into EFS packs folder
ssh -i "${private_key_location}" ubuntu@${public_dns} "CMSIS_PACK_ROOT=~/${packs_folder} /opt/ctools/bin/cpackget pack add /tmp/${pack_name}"

echo "Terminating instance ${instance_id}..."
aws ec2 terminate-instances \
    --instance-ids ${instance_id}

echo "Waiting for instance ${instance_id} to be terminated"
aws ec2 wait instance-terminated \
    --instance-ids ${instance_id}
