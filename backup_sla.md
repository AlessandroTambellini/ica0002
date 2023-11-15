# Backup procedure

## Backup covereage

The backup services covers the following services:

- MySQL
- InfluxDB
- Ansible repository

**explanation**: this document describes the backup processes for all the services containing data. This document doesn't cover the backup process for services like nginx or Bind, because they can be easily recreated from scratch via Ansible.

## RPO

- MySQL: 24 hours
- InfluxDB: 24 hours

Two types of backup can be produced: full and incremental.
Full backup contains the whole backed up data and can be solely used to restore require data or service.
Incremental backup stores only the difference in the data relative to the last incremental backup produced.

**time**: automatically everyday at 22:00 UTC time

## Versioning and retention

MySQL and InfluxDB backups are retained for 28 days.
**time**: the oldest backup is deleted at 23:00 UTC time
**explanation**: at 22:00 there's the full backup, therefore, only once the full backup happened we can delete the data

## Usability

Usability of the last MySQL and InfluDB repository backup is regularly tested every week

## Restoration criteria

Backup restoration of MySQL and InfluxDB should be done only if verified at least one of the following scenarios:

- corrupted data
- modified by unauthorized 1st/3rd party
- stolen data

## RTO

Backup service is expected to take maximum 2 hours to fully recover all the data.
**explanation**: Our infrastructure is small and its recovery with Ansible should be swift. The only potential slowing factors we're aware of are bandwidth and storage limitations.
