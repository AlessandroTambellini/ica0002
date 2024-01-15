-   Install and configure infrastructure with Ansible:

    1. Get the right ports. Therefore execute the command `./update_vms_info.sh`
       in the root of the project folder
    2. Run Ansible: `ansible-playbook infra.yaml`

-   Restore MySQL data from the backup:

    1. **Establish connection with remote vm**: In ./hosts file check the port
       used by **AlessandroTambellini-1** (where MySQL primary is located) and
       then open a terminal and type the following command:
       `ssh -p <vm_port> ubuntu@193.40.156.67`
    2. Enter privileged mode: `sudo su -`
    3. If the folder mysql is already present, delete it. Therefore navigate to
       restore location `cd /home/backup/restore` and type `ll`, if mysql folder
       is there, delete it --> `rm -rf mysql`.
    4. Then, type the following command to download data from backup server:
       `sudo -u backup duplicity --no-encryption restore rsync://AlessandroTambellini@backup.rabix.io/mysql /home/backup/restore/mysql`.
       After executing this command you may get
       `Error '[Errno 1] Operation not permitted: b'/home/backup/restore/mysql'' processing .`.
       But it's not a problem. You can read the explanation at
       https://askubuntu.com/questions/266877/why-do-i-get-an-operation-not-permitted-error-when-running-duplicity-as-sudo
    5. Finally, restore the database:
       `mysql agama < /home/backup/restore/mysql/agama.sql`

    To make sure the backup was successfull type the following commands on
    terminal to verify the database was created:

    ```sql
    mysql
    USE agama;
    SELECT * FROM item;
    ```

-   Restore InfluxDB data from the backup:

    1. **Establish connection with remote vm** In ./hosts file check the port
       used by **AlessandroTambellini-3** (where InfluxDB is located) and then
       open a terminal and type the following command:
       `ssh -p <vm_port> ubuntu@193.40.156.67`
    2. Enter privileged mode: `sudo su -`
    3. If the folder influxdb is already present, delete it. Therefore navigate
       to restore location `cd /home/backup/restore` and type `ll`, if influxdb
       folder is there, delete it --> `rm -rf influxdb`.
    4. Then, download the data from backup server to the vm:
       `sudo -u backup duplicity --no-encryption restore rsync://AlessandroTambellini@backup.rabix.io/influxdb /home/backup/restore/influxdb`

    Then, to restore the backup you will need to delete existing telegraf
    database first. It also makes sense to stop the Telegraf service so that it
    doesn't recreate the database before you could restore it. So, execute the
    following commands:

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
    2. `show databases;` and telegraf should be in the list
    3. `use telegraf;`
    4. `show measurements;` and check syslog is there
    5. You can also select few elements from syslog to verify it's not empty:
       `select * from syslog order by time desc limit 10;`
