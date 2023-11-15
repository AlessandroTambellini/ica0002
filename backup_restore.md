- Install and configure infrastructure with Ansible:

  ansible-playbook infra.yaml

- Restore MySQL data from the backup:

  sudo -u backup duplicity restore rsync://AlessandroTambellini@backup.rabix.io/mysql /home/backup/restore/mysql
  mysql agama < /home/backup/restore/mysql/agama.sql

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

  To restore the backup you will need to delete existing telegraf database first. It also makes sense to stop the Telegraf service so that it doesn't recreate the database before you could restore it:

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

  It's a known issue with InfluxDB restore, you can ignore these

  sudo -u backup duplicity restore <args>
  <another-command>
  <yet-another-command>

<add a few words here how the result of backup restore can be checked>
