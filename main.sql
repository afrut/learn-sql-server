-- Enable SQLCMD Mode. On SSMS, Query > SQLCMD Mode.
-- Run other .sql scripts.
-- :r D:\src\learn-sql-server\quickstart.sql
-- :r D:\src\learn-sql-server\misc.sql

-- Create sample databases.
drop database if exists Northwind;
drop database if exists pubs;
drop database if exists AdventureWorks;
drop database if exists AdventureWorksDW;
drop database if exists BikeStores;
:r D:\src\learn-sql-server\sample-databases\Northwind\instnwnd.sql
:r D:\src\learn-sql-server\sample-databases\Pubs\instpubs.sql
:r D:\src\learn-sql-server\sample-databases\AdventureWorks-oltp\instawdb.sql
:r D:\src\learn-sql-server\sample-databases\AdventureWorksDW-olap\instawdbdw.sql
:r D:\src\learn-sql-server\sample-databases\BikeStores\instbikestores.sql