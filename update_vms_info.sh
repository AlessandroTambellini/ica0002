#!/bin/bash

echo "Updating hosts port..." >&2

public_ip="193.40.156.67"
host_info=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv")

vm1_public_SSH_port=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 5 | head -n 1)
vm2_public_SSH_port=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 5 | sed -n '2p')

# forget old hosts
for port in $(echo "$host_info" | cut -d, -f2); do
    echo ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[$public_ip]:$port"
done

ansible_port="ansible_port=\w*"
sed -e "1 s/$ansible_port/ansible_port=$vm1_public_SSH_port/1" -e "2 s/$ansible_port/ansible_port=$vm2_public_SSH_port/1" -i hosts

echo "Done." >&2
git diff -- hosts

#
#
#

echo "Updating variables..." >&2

# read old IPs from vms_IP.txt
vm1_old_internal_IP=$(grep -m 1 "\<192.168\w*" ./vms_IP.txt)
vm2_old_internal_IP=$(grep -m 2 '\<192.168\w*' ./vms_IP.txt | tail -n 1)

# read new IPs from personal .csv file
vm1_new_internal_IP=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f2 | head -n 1)
vm2_new_internal_IP=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 2 | sed -n '2p')

# sesto campo
# substitute old IPs and ports with new ones
#sed -e "0,/public_SSH_port: \w*/{s/public_SSH_port: \w*/public_SSH_port: $vm1_public_SSH_port}" \
#    -e "s/public_SSH_port: \w*/public_SSH_port: $vm2_public_SSH_port/2" \
#    -i ./group_vars/all.yaml

# save the new IPs in vms_IP.txt
sed -e "s/$vm1_old_internal_IP/$vm1_new_internal_IP/" -e "s/$vm2_old_internal_IP/$vm2_new_internal_IP/" -i ./vms_IP.txt

echo "Done." >&2
git diff -- ./group_vars/all.yaml

#/home/alessandro/.ssh/config
#Host vm1 vm2
#StrictHostKeyChecking no
#User ubuntu