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
     , sum(Profit) over (partition by sp.SalesPersonName) ProfitTotal
from #SalesProfit sp
order by sp.SalesPersonName
       , sp.SalesOrderDetailID

-- Running total of profit
select sp.*
     , sum(Profit) over (order by SalesOrderDetailID) ProfitRunningTotal
from #SalesProfit sp
order by sp.SalesOrderDetailID

-- Separate running total of profit for each sales person
select sp.*
     , sum(Profit) over (partition by SalesPersonName order by SalesOrderDetailID) ProfitRunningTotal
from #SalesProfit sp
order by sp.SalesPersonName
       , sp.SalesOrderDetailID

-- Separate running total of profit for each combination of (sales person, product)
select sp.*
     , sum(Profit) over (partition by SalesPersonName, ProductName order by SalesOrderDetailID) ProfitRunningTotal
from #SalesProfit sp
order by sp.SalesPersonName
       , sp.ProductName
       , sp.SalesOrderDetailID