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
#git diff -- hosts

#
#   update YAML variables
#   

echo "Updating variables..." >&2

vm1_public_URL=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 6 | head -n 1)
vm2_public_URL=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 6 | sed -n '2p')
vm1_internal_IP=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 2 | head -n 1)

third_octet=$(echo "$vm1_internal_IP" | awk -F'.' '{print $3}')
if [[ $third_octet -eq 42 ]]; then
    virtual_ipaddress="${vm1_internal_IP/42/100}"
elif [[ $third_octet -eq 43 ]]; then
    virtual_ipaddress="${vm1_internal_IP/43/101}"
else
    virtual_ipaddress=""
fi

URL1=$vm1_public_URL URL2=$vm2_public_URL yq -i '
    .vm1_public_URL = strenv(URL1) |
    .vm2_public_URL = strenv(URL2)
' ./group_vars/all.yaml

iIP1=$vm1_internal_IP yq -i '
    .dns_forwarders[0] = strenv(iIP1)
' ./group_vars/all.yaml

vip=$virtual_ipaddress yq -i '
    .virtual_ipaddress = strenv(vip)
' ./group_vars/all.yaml

#git diff -- ./group_vars/all.yaml
echo "Done." >&2

echo -e "ports: \nvm1: $vm1_public_SSH_port\nvm2: $vm2_public_SSH_port"
