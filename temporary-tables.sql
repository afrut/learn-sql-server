use AdventureWorks;

-- Check if a temporary table is present. Drop if it is.
if object_id('tempdb..SalesPersonBySubTotal') is not null
	drop table SalesPersonBySubTotal;

-- Create a temporary table accessible only by the current session.
select case
         when subtotals.SalesPersonID is null then 'ONLINE'
         else concat(pp.LastName, ', ', pp.FirstName)
       end [Name]
     , subtotals.SubTotal
into #SalesPersonBySubTotal
from
(
   select soh.SalesPersonID
      , sum(sod.LineTotal) SubTotal
   from Sales.SalesOrderHeader soh
   join Sales.SalesOrderDetail sod
   on soh.SalesOrderID = sod.SalesOrderID
   group by soh.SalesPersonID
) subtotals
left join Person.Person pp
on subtotals.SalesPersonID = pp.BusinessEntityID
order by subtotals.SubTotal desc;

-- Create a global temporary table.
select *
into ##SalesPersonBySubTotal
from #SalesPersonBySubTotal;

-- Create a table by using the results of a query.
drop table if exists Sales.SalesPersonBySubTotal;
select *
into Sales.SalesPersonBySubTotal
from #SalesPersonBySubTotal;

-- Fetch 4th to 10th sales person ordered by subtotal.
select *
from Sales.SalesPersonBySubTotal
order by subtotal desc
offset 3 rows
fetch next 7 rows only;

-- Get top 10% and include ties in subtotal.
select top 10 percent with ties *
from Sales.SalesPersonBySubTotal
order by subtotal desc;

-- Get top 5 sales people and include ties.
select top 5 with ties *
from Sales.SalesPersonBySubTotal
order by subtotal desc;