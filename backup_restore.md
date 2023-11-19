- Install and configure infrastructure with Ansible:

  <!-- I think I need to describe how to setup ansible in another machine and build all the infrastrucure -->

  ansible-playbook infra.yaml

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
