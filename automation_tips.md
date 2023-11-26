# Commands to manage services on vm

- [Verify a service is automatically started](#verify-a-service-is-automatically-started)
- [Troubleshooting commands](#troubleshooting-commands)
- [Remove a service](#remove-a-service)

## Verify a service is automatically started

example using **uWSGI**

1. test if Ansible will start uWSGI if that was stopped

   ```shell
   # (on VM)
   systemctl stop uwsgi
   ```

   ```shell
   # (control node --> machine from which you use Ansible)
   ansible-playbook infra.yaml
   ```

   ```shell
   # (on VM)
   # make sure the service was started
   systemctl status uwsgi
   ```

2. test if Ansible will start uWSGI on system boot

   ```shell
   # (control node)
   ansible-playbook infra.yaml
   ```

   ```shell
   # (on VM)
   systemctl disable uwsgi # uwsgi will not start at boot
   reboot
   ```

   once the machine booted, verify uWSGI is running

   ```shell
   # (on VM)
   systemctl status uwsgi
   ```

## Troubleshooting commands

- DNS

  - `named-checkzone rabix.io /var/lib/bind/db.rabix.io`: check zone config is syntactically correct
  - `named-checkconf /etc/bind/named.conf.options`: check named is syntactically correct

- Jinja

  - https://j2live.ttl255.com/ : check your syntax template is correct

- logs

  - `journalctl` command
  - `/var/log` folder
  - `systemctl` command

- Networking

  - `ss -ntlp`: info about TCP sockets, to check the port usage by service name or service ID
  - `ss -nul` info about UDP sockets, " " "

- nginx
  - `nginx -t`: check nginx config file is syntactically correct

## Remove a service

example using **grafana-server**

```shell
service grafana-server stop
apt purge grafana
rm -rf /etc/grafana
rm -rf /var/lib/grafana
rm /etc/apt/sources.list.d/grafana.list
```
