# SQL Challenge 11 – ORM and Database Migrations

## Problem

The objective of this challenge is to design new ORM models, define relationships between entities, and manage schema changes through migrations.

## Schema

The system contains teams, users, and tasks. A new comments entity must be integrated while preserving referential integrity.

## Approach

1. Define the Comment model.
2. Establish relationships with Task and User.
3. Create migration scripts for the new table.
4. Review generated migration code.
5. Validate upgrade and downgrade operations.

## Expected Result

The solution should successfully add the comments table, create the necessary relationships, and allow migrations to be applied and reverted correctly.
