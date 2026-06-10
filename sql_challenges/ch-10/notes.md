# Notes

## What I learned

This challenge helped me understand how Oracle stores metadata about database objects and how that information can be extracted for documentation or migration purposes.

I learned that DBMS_METADATA can generate the exact SQL statements required to recreate tables, constraints, indexes, and other database objects.

The exercise also showed the importance of understanding dependencies between objects before performing migrations or backups.

## Alternative approaches

* Using Oracle Data Pump utilities.
* Using schema export tools.
* Using manual DDL scripts maintained in version control.

## Performance considerations

Metadata extraction generally has a low performance impact, but large schemas may require additional planning when exporting and migrating database objects.

Dependency analysis becomes more important as the number of database objects increases.
