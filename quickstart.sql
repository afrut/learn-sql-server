----------------------------------------
-- Create the database.
----------------------------------------
use master                      -- Switch context to use the master database.
go                              -- Used to separate statements.
if not exists (
    select name
    from sys.databases
    where name = N'TutorialDB'  -- N'' indicates that the string is in Unicode (nvarchar).
)
create database [TutorialDB]
go

----------------------------------------
-- Create a table.
----------------------------------------
use [TutorialDB]
-- Check if an object of type 'U' (user-defined table) exists by checking its
-- id. Drop it if it exists.
if object_id('dbo.Customers','U') is not null
drop table dbo.Customers
GO

-- Create a table.
create table dbo.Customers
(
   CustomerId   int not null primary key,
   Name         [NVARCHAR](50) not null,
   Location     [NVARCHAR](50) not null,
   Email        [NVARCHAR](50) not null
);
GO

----------------------------------------
-- Insert rows.
----------------------------------------
-- Delete all content from the table first.
truncate table dbo.Customers;

-- Insert 4 rows.
-- [] enables the use of special characters or keywords as identifiers.
use [TutorialDB]
insert into dbo.Customers
    (CustomerId, [Name], [Location], Email)
values
    (1, 'Orlando', 'Australia', ''),
    (2, 'Keith', 'India', 'keith@adventure-works.com'),
    (3, 'Donna', 'Germany', 'donna@adventure-works.com'),
    (4, 'Janet', 'United States', 'janet1@adventure-works.com')
go

----------------------------------------
-- Query.
----------------------------------------
select *
from dbo.Customers;