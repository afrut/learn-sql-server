-- Usage of the rows and range clauses in window functions

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
     -- Sum over all rows before and including current row in a partition
     , sum(Profit) over (partition by SalesPersonName order by SalesOrderDetailID rows unbounded preceding) ProfitTotal1

     -- Sum over 5 rows before and including current row in a partition
     , sum(Profit) over (partition by SalesPersonName order by SalesOrderDetailID rows 5 preceding) ProfitTotal2

     -- Sum over all rows and all rows after current row in a partition
     , sum(Profit) over (partition by SalesPersonName order by SalesOrderDetailID rows between unbounded preceding and unbounded following) ProfitTotal3

     -- Sum over 3 rows before, 3 rows after and including current row in a partition
     , sum(Profit) over (partition by SalesPersonName order by SalesOrderDetailID rows between 3 preceding and 3 following) ProfitTotal4

     -- Sum over current row and 3 rows after in a partition
     , sum(Profit) over (partition by SalesPersonName order by SalesOrderDetailID rows between current row and 3 following) ProfitTotal5

     -- Same as rows unbounded preceding
     , sum(Profit) over (partition by SalesPersonName order by SalesOrderDetailID range unbounded preceding) ProfitTotal6

     -- Sum over all rows with the same SalesOrderDetailID as the current row
     , sum(Profit) over (partition by SalesPersonName order by SalesOrderDetailID range current row) ProfitTotal7

     -- Sum over all rows before and all rows with the same SalesOrderDetailID value as current row
     , sum(Profit) over (partition by SalesPersonName order by SalesOrderDetailID range between unbounded preceding and current row) ProfitTotal8

     -- Sum over all rows after and all rows with the same SalesOrderDetailID as current row
     , sum(Profit) over (partition by SalesPersonName order by SalesOrderDetailID) range between unbounded following and current row) ProfitTotal9
from #SalesProfit sp
order by sp.SalesOrderDetailID