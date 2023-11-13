#!/bin/bash

echo "Updating hosts port..." >&2

#
#   forgot old ports
#

public_ip="193.40.156.67"
host_info=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv")

for port in $(echo "$host_info" | cut -d, -f2); do
    echo ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[$public_ip]:$port"
done

#
#   update hosts file
#

ansible_port="ansible_port=\w*"
vm1_public_SSH_port=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 5 | head -n 1)
vm2_public_SSH_port=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 5 | sed -n '2p')

sed -e "1 s/$ansible_port/ansible_port=$vm1_public_SSH_port/1" -e "2 s/$ansible_port/ansible_port=$vm2_public_SSH_port/1" -i hosts

echo "Done." >&2
git diff -- hosts

#
#   update YAML variables
#   

echo "Updating variables..." >&2

vm1_public_URL=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 6 | head -n 1)
vm2_public_URL=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 6 | sed -n '2p')
# TODO: I don't know if backup server IP is in this file
backup_server_ip=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 7 | sed -n '2p')

echo $vm1_public_URL

URL1=$vm1_public_URL URL2=$vm2_public_URL yq -i '
    .vms.vm1.public_URL = strenv(URL1) |
    .vms.vm2.public_URL = strenv(URL2)
' ./group_vars/all.yaml

SSH1=$vm1_public_SSH_port SSH2=$vm2_public_SSH_port yq -i '
    .vms.vm1.public_SSH_port = strenv(SSH1) |
    .vms.vm2.public_SSH_port = strenv(SSH2)
' ./group_vars/all.yaml

BACKUP_IP=$backup_server_ip yq -i '
    .backup_server_ip = strenv(BACKUP_IP)
' ./group_vars/all.yaml

# git diff -- ./group_vars/all.yaml

echo "Done." >&2