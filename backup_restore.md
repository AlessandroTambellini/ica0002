- Install and configure infrastructure with Ansible:

  0. Check your ssh keys with `ls -la ~/.ssh`. If they're not present,
     generate a new keypair by running `ssh-keygen`. Once created add them to your GitHub account: settings --> SSH and GPG keys --> New SSH key

  1. Install Ansible in Python virtual env

  ```shell
  python3 -m venv ~/ansible-venv
  ~/ansible-venv/bin/pip install ansible==6.7.0
  ~/ansible-venv/bin/ansible --version
  ```

  2. Add the path to `~/.profile`

  ```shell
  PATH="$HOME/ansible-venv/bin:$PATH"
  ```

  3. Check Ansible is there

  ```shell
  ansible --version
  ```

  4. Test access to vm

  ```shell
  ssh -p<port> ubuntu@193.40.156.67 uptime
  ```

  5. Clone GitHub repo

  ```shell
  git clone git@github.com:<github_username>/ica0002
  ```

  6. Run Ansible in repo directory

  ```shell
  ansible-playbook infra.yaml
  ```

- Restore MySQL data from the backup:

  1. `sudo -u backup duplicity --no-encryption restore rsync://AlessandroTambellini@backup.rabix.io/mysql /home/backup/restore/mysql`
  2. enter privileged mode: `sudo su -`
  3. `mysql agama < /home/backup/restore/mysql/agama.sql`

  To make sure the result of the backup restore is correct follow the following instructions:

  - verify the last date of modification of /home/backup/restore/mysql/agama.sql correspond to when you executed the command\n
  - type the following commands:

  ```sql
  mysql
  USE agama;
  SELECT * FROM item;
  ```

  and check the data is right there

- Restore InfluxDB data from the backup:

  First, download the data from backup server to vm:
  `sudo -u backup duplicity --no-encryption restore rsync://AlessandroTambellini@backup.rabix.io/influxdb /home/backup/restore/influxdb`

  Then, To restore the backup you will need to delete existing telegraf database first. It also makes sense to stop the Telegraf service so that it doesn't recreate the database before you could restore it. So, execute the following commands:

  ```bash
  service telegraf stop
  influx -execute 'DROP DATABASE telegraf'
  influxd restore -portable -database telegraf /home/backup/restore/influxdb
  ```

  You may get these errors if restoring the database:

  ```bash
  error updating meta: DB metadata not changed. database may already exist
  restore: DB metadata not changed. database may already exist
  ```

  It's a known issue with InfluxDB restore, you can ignore these.

  The data should now be restored. To check it type:

  1. `influx`
  2. `show databases`
     and telegraf should be in the list
  3. `show measurements` and check syslog is there
