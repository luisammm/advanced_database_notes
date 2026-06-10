# Session – 2026-04-28

## Topics covered

* Database backups
* Schema backups
* Data backups
* Database migration
* DBMS_METADATA
* Exporting DDL statements
* Dependency management

## What I understood

### Database Backups

Database backups are copies of database information that can be used to restore the system in case of failure, corruption, or accidental data loss.

### Schema Backups

A schema backup stores the structure of database objects such as tables, indexes, views, and constraints without necessarily including the data.

### Data Backups

Data backups focus on preserving the records stored inside database tables so they can be recovered when needed.

### Database Migration

Database migration is the process of moving database structures and data between environments while maintaining consistency and integrity.

### DBMS_METADATA

DBMS_METADATA is an Oracle package that allows us to extract the DDL statements used to create database objects. It is useful for documentation, backups, and migrations.

### Dependency Management

Database objects often depend on one another. Understanding these dependencies helps avoid errors when migrating or recreating schemas.

## What is still confusing

* I would like more practice understanding complex object dependencies during migrations.
* Some migration scenarios involving large databases are still new to me.

## Questions

* What is the best strategy for backing up databases with very large amounts of data?
* How can dependency issues be detected automatically before a migration?

## Related concepts

* Backup and Recovery
* DBMS_METADATA
* DDL
* Database Migration

## Resources used

* Oracle Documentation
* Class examples
