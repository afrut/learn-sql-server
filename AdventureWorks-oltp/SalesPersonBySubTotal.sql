use AdventureWorks;

-- Check that the SalesOrderHeader.SubTotal is properly computed from
-- SalesOrderDetail.LineTotal for every SalesOrderID. If no errors, then the
-- following query returns no rows.
select *
from
(
   select soh.SalesOrderID
      , soh.SubTotal s1
      , soh.SubTotal s2
      , case when abs(soh.SubTotal - soh3.SubTotal) < 0.01 then 1 else 0 end Equal
   from Sales.SalesOrderHeader soh
   join
   (
      select soh2.SalesOrderID
         , sum(sod.LineTotal) SubTotal
      from Sales.SalesOrderHeader soh2
      join Sales.SalesOrderDetail sod
      on soh2.SalesOrderID = sod.SalesOrderID
      group by soh2.SalesOrderID
   ) soh3
   on soh.SalesOrderID = soh3.SalesOrderID
) rs
where rs.Equal = 0;

-- Rank all employees in descending order according to the subtotal of their
-- sales orders.
select case
         when subtotals.SalesPersonID is null then 'ONLINE'
         else concat(pp.LastName, ', ', pp.FirstName)
       end [Name]
     , subtotals.SubTotal
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