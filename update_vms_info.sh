#!/bin/bash

echo "Updating hosts port..." >&2

#
#   forgot old ports
#

public_ip="193.40.156.67"
host_info=$(curl "http://<your_URL>")

for port in $(echo "$host_info" | cut -d, -f2); do
    echo ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[$public_ip]:$port"
done

#
#   update hosts file
#

ansible_port="ansible_port=\w*"
vm1_public_SSH_port=$(curl "http://<your_URL>" | awk -F ',' 'NR==1 {print $5}')
vm2_public_SSH_port=$(curl "http://<your_URL>" | awk -F ',' 'NR==2 {print $5}')
vm3_public_SSH_port=$(curl "http://<your_URL>" | awk -F ',' 'NR==3 {print $5}')

sed -e "1 s/$ansible_port/ansible_port=$vm1_public_SSH_port/1" \
    -e "2 s/$ansible_port/ansible_port=$vm2_public_SSH_port/1" \
    -e "3 s/$ansible_port/ansible_port=$vm3_public_SSH_port/1" \
    -i hosts

echo "Done." >&2

#
#   update YAML variables
#   

echo "Updating variables..." >&2

vm1_internal_IP=$(curl "http://<your_URL>" | awk -F ',' 'NR==1 {print $2}')
vm3_public_URL=$(curl "http://<your_URL>" | awk -F ',' 'NR==3 {print $6}')

URL2=$vm3_public_URL yq -i '
    .vm3_public_URL = strenv(URL2)
' ./group_vars/all.yaml

iIP1=$vm1_internal_IP yq -i '
    .dns_forwarders[0] = strenv(iIP1)
' ./group_vars/all.yaml

echo "Done." >&2

echo -e "ports: \n \
        vm1: $vm1_public_SSH_port\n \
        vm2: $vm2_public_SSH_port\n \
        vm3: $vm3_public_SSH_port"
