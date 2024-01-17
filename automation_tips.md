# Automation Tips

-   [Verify a service is automatically started](#verify-a-service-is-automatically-started)
-   [Remove a service](#remove-a-service)
-   [Test the infrastructure](#test-the-infrastructure)

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

## Remove a service

example using **grafana-server**

```shell
service grafana-server stop
apt purge grafana
rm -rf /etc/grafana
rm -rf /var/lib/grafana
rm /etc/apt/sources.list.d/grafana.list
```

## Check DNS is working

From any vm try to ping `<vm-name>-<domain>`, `<vm-name>`. The pinging should
work with any "vm-name" of your vms

## Test the infrastructure

To test if everything is working in the infrastracture, run the script
`./pre-exam.sh` which is going to output on file `./pre-exam.txt` and the result
shoud be:

-   many changes on 1st run
-   0 changes on 2nd run
-   0 changes on 3rd run (after reboot)
