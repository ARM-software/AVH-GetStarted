#!/bin/bash

# This script aims to setup a pack folder into a new
# EFS. Run it just once.

# Please change the user_data.txt variables according
# to your info. E.g:
# - efs_mount_point_1=/mnt/efs/fs1
# - file_system_id_1=fs-066cf410af2428e2f
# - efs_dns_name=fs-066cf410af2428e2f.efs.eu-west-1.amazonaws.com
# - pack_folder=packs

################################
# PLEASE MODIFY THE VARS BELOW #
################################
# You can use any Ubuntu image
image_id="ami-0520f21724d333fa7"
instance_type="t2.micro"
# Use the Mount Point Subnet
subnet_id="subnet-025b7baebd743a68b"
# Use the AVH EFS Security Group
security_group_ids="sg-0a9aa42b4737b3f86 sg-03afe5ec007b4bcb0"
key_name="common"
user_data="file://user_data.txt"

echo "Creating an AVH EC2 instance that setup a new EFS..."
instance_id=$(aws --output text ec2 run-instances \
    --image-id ${image_id} \
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

echo "Sleeping for 180s to be sure cloud init was executed"
sleep 180

echo "Terminating instance ${instance_id}..."
aws ec2 terminate-instances \
    --instance-ids ${instance_id}

echo "Waiting for instance ${instance_id} to be terminated"
aws ec2 wait instance-terminated \
    --instance-ids ${instance_id}
