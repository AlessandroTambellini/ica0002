#!/bin/bash

echo "Updating..." >&2

host_info=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d, -f1,5)

vm1_name=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d, -f1 | head -n 1)
vm1_internal_IP=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f2 | head -n 1)
vm1_port=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 5 | head -n 1)

vm2_name=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 1 | sed -n '2p')
vm2_internal_IP=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 2 | sed -n '2p')
vm2_port=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d "," -f 5 | sed -n '2p')

# forget old hosts
for port in $(echo "$host_info" | cut -d, -f2); do
    echo ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[$public_ip]:$port"
done

vm_name="AlessandroTambellini-\w*"
vm_port="ansible_port=\w*"
sed -e "1 s/$vm_port/ansible_port=$vm1_port/1" -e "2 s/$vm_port/ansible_port=$vm2_port/1" -i hosts

echo "Done." >&2
git diff -- hosts

#/home/alessandro/.ssh/config
#Host vm1 vm2
#StrictHostKeyChecking no
#User ubuntu