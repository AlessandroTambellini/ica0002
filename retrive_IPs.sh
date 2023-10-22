#!/bin/bash

#url="http://193.40.156.67/students/AlessandroTambellini.html"
#
#search_word="192.168.\{1,3\}.\{1,3\}"
#
#temp_file="$(mktemp)"
#curl -s "$url" > "$temp_file"
#
## The -o option tells grep to only print the matched part of the line
#if grep -o "$search_word" "$temp_file" > "test.txt"; then
#  echo "The word '$search_word' was found in the HTML content."
#else
#  echo "The word '$search_word' was not found in the HTML content."
#fi
#
## my name.csv
## Clean up the temporary file
#rm "$temp_file"

#public_ip = "193.40.156.67"

echo "Updating..." >&2

host_info=$(curl "http://193.40.156.67/students/AlessandroTambellini.csv" | cut -d, -f1,5)

# forget old hosts
for port in $(echo "$host_info" | cut -d, -f2); do
    echo ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[$public_ip]:$port"
done

echo $host_info 

# write new inventory
# substitute "," with "ansible_port="
hosts=$(cat << EOF
$(echo "$host_info" | sed 's/,/ ansible_port=/')
$(cat hosts | grep -v '^AlessandroTambellini-[0-9 ]*ansible')
EOF
)

echo "$hosts" > hosts.backup

echo "Done." >&2
git diff -- hosts

#/home/alessandro/.ssh/config
#Host vm1 vm2
#StrictHostKeyChecking no
#User ubuntu