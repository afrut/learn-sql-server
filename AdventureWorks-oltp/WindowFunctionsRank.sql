-- Compute the net profit of each (sales person, product) combination using all
-- sales data

with

-- Retrieve SalesPersonName for each SalesOrderID
sp as
(
    select soh.SalesOrderID SalesOrderID
         , case
            when per.BusinessEntityID is null then 'ONLINE'
            else concat(per.[LastName], ', ', per.FirstName)
           end SalesPersonName
    from Sales.SalesOrderHeader soh
    left join Person.Person per
    on soh.SalesPersonID = per.BusinessEntityID
),

-- Compute total revenue and order quantity for each combination of (sales person, product)
sodG as
(
    select ProductID ProductID
         , SalesPersonName SalesPersonName
         , sum(LineTotal) LineTotal
         , sum(OrderQty) OrderQty
    from Sales.SalesOrderDetail sod
    join sp
    on sod.SalesOrderID = sp.SalesOrderID
    group by ProductID, SalesPersonName
),

-- Compute profit for each combination of (sales person, product)
profit as
(
    select sodG.SalesPersonName SalesPersonName
         , p.[Name] [ProductName]
         , sodG.LineTotal - (p.StandardCost * sodG.OrderQty) Profit
         , sodG.LineTotal LineTotal
         , p.StandardCost StandardCost
         , sodG.OrderQty OrderQty
    from Production.Product p
    join sodG
    on p.ProductID = sodG.ProductID
)

-- Partition the data by sales person and apply window functions on each partition
select p.*
     , rank() over (partition by SalesPersonName order by Profit desc) [RankByProfit]               -- ties have the same rank and will leave gaps
     , dense_rank() over (partition by SalesPersonName order by Profit desc) [DenseRankByProfit]    -- ties have the same rank but will not leave gaps
     , ntile(4) over (partition by SalesPersonName order by Profit desc) [QuartileByProfit]         -- create groups according to order
     , row_number() over (partition by SalesPersonName order by Profit desc) [RowNumberByProfit]    -- simple row numbers over the result set
from profit p
order by SalesPersonName
       , ProductName
