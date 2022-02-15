-- These queries which product sell the most or generate the most reveneue.

select p.[Name] ProductName
     , sum(sod.OrderQty) OrderQtyTotal
     , sum(sod.LineTotal) LineTotal
from Sales.SalesOrderDetail sod
join Production.Product p
on sod.ProductID = p.ProductID
group by p.[Name]
-- order by OrderQtyTotal desc        -- By number of units sold
order by LineTotal desc            -- By revenue associated with product