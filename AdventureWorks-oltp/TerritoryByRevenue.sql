-- This query ranks sales territories by revenue of sales.
use AdventureWorks

select tbl.[Name]
     , tbl.Revenue
     , dense_rank() over
        (order by tbl.Revenue desc) [Rank]
from
(
    select st.[Name]
        , sum(sod.LineTotal) Revenue
    from Sales.SalesOrderHeader soh
    join Sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID
    join Sales.SalesTerritory st
    on soh.TerritoryID = st.TerritoryID
    group by st.[Name]
) tbl
order by Revenue desc