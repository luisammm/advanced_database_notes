# Session – 2026-05-12

## Topics covered

* ORM
* SQLAlchemy
* Alembic
* Database migrations
* Model relationships

## What I understood

### ORM

Object Relational Mapping is a technique that allows applications to interact with a relational database using classes and objects instead of writing SQL for every operation. The ORM translates object operations into SQL statements behind the scenes.

For example, instead of manually querying a table, a developer can interact with a User object and let the ORM generate the appropriate SQL.

An ORM helps reduce repetitive code and improves maintainability when working with large applications.

### SQLAlchemy

SQLAlchemy is a Python ORM that allows developers to define database tables as classes and interact with records as objects. It supports relationships, constraints, validations, and query generation.

### Alembic

Alembic is a migration tool used together with SQLAlchemy. It tracks schema changes and allows databases to evolve in a controlled manner through versioned migration files.

### Database Migrations

Migrations allow database structures to change over time without losing consistency. They make it possible to keep development, testing, and production environments synchronized.

### Relationships

Relationships define how entities connect with one another. Examples include one-to-many and many-to-one associations. These relationships simplify data access through the ORM.

## What is still confusing

* More practice is needed with complex relationships involving multiple tables.
* I would like to understand how migration conflicts are resolved in larger teams.

## Questions

* How does SQLAlchemy optimize generated queries?
* What happens when two migrations modify the same table?
* When is raw SQL preferable over an ORM?

## Related concepts

* ORM
* SQLAlchemy
* Alembic
* Database Migrations
* Entity Relationships

## Resources used

* SQLAlchemy Documentation
* Alembic Documentation
* Class examples
