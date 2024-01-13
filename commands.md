## SSH

-   ssh -p<port_number> ubuntu@193.40.156.67
-   ssh -p<my_port_number> ubuntu@193.40.156.67 uptime
-   ssh-keygen -R "ip":"port" -f /home/"your_user"/.ssh/known_hosts --> when I
    have problems with a key

## ANSIBLE COMMANDS

-   ansible-playbook infra.yaml
-   ansible-vault encrypt_string "password" --> encrypt password with
    ansible_vault
-   ansible-playbook infra.yaml -tmonitoring --> run tasks with specified tag
-   ansible-playbook infra.yaml -t "i, dns" --> more tags at once
-   ansible-playbook infra.yaml -vvv --> see full traceback
-   ansible-doc --> like man for linux

## PACKAGES

-   1. https://packages.ubuntu.com/
    2. then set the distribution to focal
-   dpkg -l --> packages list

## DNS

-   named-checkzone rabix.io /var/cache/bind/db.rabix.io --> Check the dns zone
    is syntattically configured correctly. If the output is OK, the syntax is
    correct (it works just on vm where the file is not binary)
-   named-checkconf /etc/bind/named.conf.options // If no output, the syntax is
    correct
-   if I have problems with the dns, just set /etc/resolv.conf nameserver to
    8.8.8.8 to at least download the stuff you need
-   you could have conflicting services runnning on the same port. So you need
    to first manually stop these services
-   cat /var/log/syslog | grep named
-   host & dig commands

## JINJA

-   check Jinja2 templates: https://j2live.ttl255.com/

## TROUBLESHOOTING

-   sudo tail /var/log/uwsgi/app/agama.log
-   sudo tail /var/log/nginx/access.log
-   cat /var/log/syslog
-   journalctl -u prometheus-nginx-exporter.service --no-pager
-   less /etc/resolv.conf // nameserver config
-   service bind9 status
-   systemctl status bind9
-   ps ax --> running processes
-   cat /etc/passwd --> find out the directory of each user
-   sudo mysql -e "SELECT \* FROM agama.item" agama ---> if the database exists
    there's no output
-   less /etc/apt/sources.list.d/"something".list --> to check keys
-   git diff file --> diff from last commit
-   less /var/log/syslog | grep named --> dns logs
-   docker logs <container-name>
-   nc -vz <IP> <port> --> check if service is listening on specified ip and
    port
-   curl -L http://<exporter hostname>:<exporter_port>/metrics --> check exposed
    exporter metrics

## SEARCHING/FILTERING

-   cat "file" | wc -l --> count the lines
-   "path_to_file"/file --> empty the file
-   telegraf config | grep -v "^#\|^$\|^ #" --> check default telegraf config
    (nicely)

## NETWORKING

-   ss -ntlp ==> check TCP ports
-   ss -nulp ==> check UDP ports
-   curl localhost:9113 | grep -v ^# ==> view page content without the comments
-   dig google.com --> dns info about google.com
-   ping 1.1.1.1 --> test the network is reachable

### Check if vault_password is setup correctly

1. echo WORKS > ansible-vault-test.txt
2. ansible-vault encrypt ansible-vault-test.txt
3. ansible-vault view ansible-vault-test.txt
4. rm ansible-vault-test.txt

### Check syntax

-   nginx -t
-   named-checkzone rabix.io /var/cache/bind/db.rabix.io --> Check the dns zone
    is syntattically configured correctly. If the output is OK, the syntax is
    correct (it works just on vm where the file is not binary)
-   named-checkconf /etc/bind/named.conf.options // If no output, the syntax is
    correct
