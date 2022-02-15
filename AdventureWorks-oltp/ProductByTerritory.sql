-- These queries rank products sold for each territory.
use AdventureWorks

select *
from
(
    -- Compute rank
    select tbl.TerritoryName
        , tbl.ProductName
        , tbl.OrderQtyTotal
        , tbl.LineTotal
        , dense_rank() over
            (partition by tbl.TerritoryName order by tbl.LineTotal desc) [Rank]
    from
    (
        -- Group by product and territory
        select st.[Name] TerritoryName
            , p.[Name] ProductName
            , sum(sod.OrderQty) OrderQtyTotal
            , sum(sod.LineTotal) LineTotal
        from Sales.SalesOrderDetail sod
        join Sales.SalesOrderHeader soh
        on sod.SalesOrderID = soh.SalesOrderID
        join Sales.SalesTerritory st
        on soh.TerritoryID = st.TerritoryID
        join Production.Product p
        on sod.ProductID = p.ProductID
        group by st.[Name]
            , p.[Name]
    ) tbl
) tbl2
where tbl2.[Rank] <= 3
order by tbl2.TerritoryName