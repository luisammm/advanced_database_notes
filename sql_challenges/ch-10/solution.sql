-- ============================================================
-- CHALLENGE 10 - SOLUTION
-- Schema Backup, Metadata and Migration
-- ============================================================


-- ============================================================
-- Exercise 1 - Explore Schema Objects
-- ============================================================

-- Count objects by type

SELECT object_type,
       COUNT(*) AS total_objects
FROM user_objects
GROUP BY object_type
ORDER BY total_objects DESC;

-- View object details

SELECT object_name,
       object_type,
       created,
       last_ddl_time
FROM user_objects
ORDER BY object_name;


-- ============================================================
-- Exercise 2 - Extract DDL
-- ============================================================

BEGIN
    DBMS_METADATA.SET_TRANSFORM_PARAM(
        DBMS_METADATA.SESSION_TRANSFORM,
        'PRETTY',
        TRUE
    );

    DBMS_METADATA.SET_TRANSFORM_PARAM(
        DBMS_METADATA.SESSION_TRANSFORM,
        'SQLTERMINATOR',
        TRUE
    );

    DBMS_METADATA.SET_TRANSFORM_PARAM(
        DBMS_METADATA.SESSION_TRANSFORM,
        'STORAGE',
        FALSE
    );

    DBMS_METADATA.SET_TRANSFORM_PARAM(
        DBMS_METADATA.SESSION_TRANSFORM,
        'TABLESPACE',
        FALSE
    );
END;
/

SET LONG 100000
SET PAGESIZE 0

-- Generate DDL for all tables in the schema

SELECT DBMS_METADATA.GET_DDL(
           'TABLE',
           table_name
       )
FROM user_tables
ORDER BY table_name;


-- ============================================================
-- Exercise 3 - Portable DDL
-- ============================================================

BEGIN
    DBMS_METADATA.SET_TRANSFORM_PARAM(
        DBMS_METADATA.SESSION_TRANSFORM,
        'EMIT_SCHEMA',
        FALSE
    );
END;
/

-- Test output without schema qualification

SELECT DBMS_METADATA.GET_DDL(
           'TABLE',
           table_name
       )
FROM user_tables
WHERE ROWNUM = 1;

-- Example:
-- Before:
-- CREATE TABLE "MY_SCHEMA"."ACCOUNTS"

-- After:
-- CREATE TABLE "ACCOUNTS"

-- This makes migration between schemas easier.


-- ============================================================
-- Exercise 4 - Migration Planning
-- ============================================================

-- Inspect table definition

SELECT DBMS_METADATA.GET_DDL(
           'TABLE',
           'SALE_ITEM'
       )
FROM dual;

-- Review foreign key relationships

SELECT constraint_name,
       table_name,
       r_constraint_name
FROM user_constraints
WHERE constraint_type = 'R';

-- Migration Checklist
--
-- 1. Extract schema DDL.
-- 2. Remove schema references.
-- 3. Review foreign keys.
-- 4. Update references when moving to a new schema.
-- 5. Recreate objects in dependency order.
-- 6. Validate all relationships.
-- 7. Perform post-migration verification.


-- ============================================================
-- Exercise 5 - Dependency Analysis
-- ============================================================

-- Display dependency information

SELECT referenced_name,
       referencing_name,
       referencing_type
FROM user_dependencies
ORDER BY referenced_name;

-- Find objects that require existing tables

SELECT referencing_name,
       referencing_type
FROM user_dependencies
WHERE referenced_name IN (
    SELECT table_name
    FROM user_tables
)
ORDER BY referencing_name;

-- Example analysis:
-- Views, procedures and functions frequently depend
-- on tables and should be recreated after tables exist.


-- ============================================================
-- Exercise 6 - Backup Strategy
-- ============================================================

-- Inventory current schema

SELECT object_type,
       COUNT(*)
FROM user_objects
GROUP BY object_type;

SELECT table_name,
       num_rows
FROM user_tables
ORDER BY table_name;

-- Backup strategy:
--
-- Step 1: Document schema structure.
-- Step 2: Extract DDL using DBMS_METADATA.
-- Step 3: Export table data separately.
-- Step 4: Review dependencies.
-- Step 5: Create objects in the destination environment.
-- Step 6: Load data.
-- Step 7: Validate counts and relationships.