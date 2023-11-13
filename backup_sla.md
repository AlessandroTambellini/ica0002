# Backup procedure

This file describe the backup approach for:

- Database servers
- InfluxDB
- Ansible repository

Basically, apart from the Ansible repo, the only services recovered are the ones containing data.
There's no need to backup other services like nginx or Bind, because these can be easily recreated from scratch via Ansible

<!--
TODO:
for each service you should write these info:

- Backup coverage
- RPO (recovery point objective)
- Versioning and retention -- how many backup versions are stored and for how long
- Usability checks -- how is backup usability verified
- Restoration criteria -- when should backup be restored
- RTO (recovery time objective)
-->
