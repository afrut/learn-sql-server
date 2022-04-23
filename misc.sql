-- Switch context to use this database.
use AdventureWorks;

-- Check databases created.
select *
from sys.databases;

-- See all tables.
select *
from sys.tables;

-- See all database objects.
select *
from sys.objects;

-- See all schemas.
select *
from sys.schemas;

-- See all extended properties.
select *
from sys.extended_properties;

-- See all columns.
select *
from sys.columns;

-- See all foreign keys.
select *
from sys.foreign_keys;

-- See which columns in the parent/referenced object constitute the foreign key.
select *
from sys.foreign_key_columns;

-- See types of columns.
select *
from sys.types;