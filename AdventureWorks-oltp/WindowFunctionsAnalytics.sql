-- Uses for aggregate window functions.

-- Create a temporary table that associates each SalesOrderID with a sales person.
if object_id('tempdb..#SalesPersonName') is not null
     drop table #SalesPersonName
select soh.SalesOrderID SalesOrderID
     , case
          when soh.SalesPersonID is null then 'ONLINE'
          else concat(person.LastName, ', ', person.FirstName)
          end SalesPersonName
     , soh.OrderDate OrderDate
into #SalesPersonName
from Sales.SalesOrderHeader soh
left join Person.Person person
on soh.SalesPersonID = person.BusinessentityID


-- Create a temporary table with the profit of each item in each sale
if object_id('tempdb..#SalesProfit') is not null
     drop table #SalesProfit
select sod.SalesOrderDetailID SalesOrderDetailID
     , spn.OrderDate OrderDate
     , spn.SalesPersonName SalesPersonName
     , prod.Name ProductName
     , sod.LineTotal LineTotal
     , prod.StandardCost StandardCost
     , sod.OrderQty OrderQty
     , sod.LineTotal - (prod.StandardCost * sod.OrderQty) Profit
into #SalesProfit
from Sales.SalesOrderDetail sod
join Production.product prod
on sod.ProductID = prod.ProductID
join #SalesPersonName spn
on sod.SalesOrderID = spn.SalesOrderID



-- sum can be replaced by other aggregate functions: count, avg, min, max

-- Total profit for each sales person
select sp.*
     -- Cumulative distribution - the fraction of rows that have a Profit <= current row
     , cume_dist() over (partition by sp.SalesPersonName order by Profit) ProfitCumeDist

     -- First value in the partition
     , first_value(sp.ProductName) over (partition by sp.SalesPersonName order by Profit) ProfitFirstValue

     -- Last value in the partition
     , last_value(sp.ProductName) over (partition by sp.SalesPersonName order by Profit) ProfitLastValue

     -- 3 values after the current row. Return 0 if it doesn't exist
     , lead(Profit, 3, 0) over (partition by sp.SalesPersonName order by Profit) ProfitLead3

     -- 3 values before the current row. Return 0 if it doesn't exist
     , lag(Profit, 3, 0) over (partition by sp.SalesPersonName order by Profit) ProfitLag3

     -- Percentage rank - relative standing of a value in the partiion. Similar to cumulative distribution
     , percent_rank() over (partition by SalesPersonName order by Profit) ProfitPctRank

     -- Returns the value corresponding to the 95th percentile
     , percentile_disc(0.95) within group (order by Profit) over (partition by SalesPersonName) ProfitPctDisc
from #SalesProfit sp
order by sp.SalesPersonName
       , sp.Profit