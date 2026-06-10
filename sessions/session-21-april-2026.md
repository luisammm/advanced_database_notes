# Session – 2026-04-21

## Topics covered

* Transactions
* ACID properties
* Savepoints
* Stored procedures
* Functions

## What I understood

### Transactions

A transaction groups multiple database operations into a single unit of work. The main idea is that all operations succeed together or all changes are reverted. This prevents inconsistent data when an error occurs during a process.

### ACID Properties

**Atomicity**
A transaction is completed entirely or not executed at all.

**Consistency**
The database must remain in a valid state before and after a transaction.

**Isolation**
Transactions running at the same time should not interfere with each other.

**Durability**
Once a transaction is committed, the changes remain saved even if the system fails later.

### Savepoints

A savepoint creates an intermediate checkpoint inside a transaction. It allows rolling back only part of the work instead of cancelling the entire transaction.

### Stored Procedures

Stored procedures are reusable programs stored inside the database. They help centralize business logic, reduce duplicated code, and simplify repetitive operations.

### Functions

Functions are database objects that return a value. They are commonly used for calculations, transformations, and reusable expressions inside queries.

## What is still confusing

* Nothing at the moment.

## Questions

* None.

## Related concepts

* Transactions
* ACID
* Savepoints
* Stored Procedures
* Functions

## Resources used

* Oracle Documentation
* Class examples
