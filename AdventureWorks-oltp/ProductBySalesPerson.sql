-- These queries answer: What are the top products sold by each sales person?

use AdventureWorks

-- -- Are all orders without a SalesPerson online orders?
-- -- Find all rows where a sales person did not enter the order and the order was
-- -- not entered online. If this returns 0 rows, then all orders without sales
-- -- person are entered online.
-- select soh.SalesPersonID
--      , soh.OnlineOrderFlag
-- from Sales.SalesOrderHeader soh
-- where soh.SalesPersonID is null
--   and soh.OnlineOrderFlag = 0

-- --------------------------------------------------------------------------------
-- For each SalesPerson, find the top 3 products sold by OrderQty.
-- --------------------------------------------------------------------------------
select *
from
(
    -- Compute the rank.
    select tbl2.SalesPersonName
        , product.[Name]
        , tbl2.OrderQty
        , dense_rank() over
            (partition by tbl2.SalesPersonName order by tbl2.OrderQty desc) as Rank
    from
    (
        -- Group by SalesPersonName, and ProductID while summing OrderQty.
        select SalesPersonName
            , ProductID
            , sum(OrderQty) [OrderQty]
        from
        (
            -- For every row in SalesOrderDetail, get SalesPersonName, ProductID, and
            -- OrderQty.
            select case when soh.SalesPersonID is null then 'ONLINE' else concat(person.LastName, ', ', person.FirstName) end [SalesPersonName]
                , product.ProductID
                , sod.OrderQty OrderQty
            from Sales.SalesOrderDetail sod
            join Sales.SalesOrderHeader soh
            on sod.SalesOrderID = soh.SalesOrderID
            join Production.Product product
            on sod.ProductID = product.ProductID
            left join Sales.SalesPerson sp
            on soh.SalesPersonID = sp.BusinessEntityID
            left join Person.Person person
            on soh.SalesPersonID = person.BusinessEntityID
        ) tbl
        group by tbl.SalesPersonName
            , tbl.ProductID
    ) tbl2
    join Production.Product product
    on tbl2.ProductID = product.ProductID
) tbl3
where tbl3.[Rank] <= 3
order by tbl3.SalesPersonName asc
    , tbl3.OrderQty desc


-- --------------------------------------------------------------------------------
-- For each SalesPerson, find the top 3 products sold by LineTotal.
-- --------------------------------------------------------------------------------
select *
from
(
    -- Compute the rank.
    select tbl2.SalesPersonName
        , product.[Name]
        , tbl2.LineTotal
        , dense_rank() over
            (partition by tbl2.SalesPersonName order by tbl2.LineTotal desc) as Rank
    from
    (
        -- Group by SalesPersonName, and ProductID while summing LineTotal.
        select SalesPersonName
            , ProductID
            , sum(LineTotal) [LineTotal]
        from
        (
            -- For every row in SalesOrderDetail, get SalesPersonName, ProductID, and
            -- LineTotal.
            select case when soh.SalesPersonID is null then 'ONLINE' else concat(person.LastName, ', ', person.FirstName) end [SalesPersonName]
                , product.ProductID
                , sod.LineTotal LineTotal
            from Sales.SalesOrderDetail sod
            join Sales.SalesOrderHeader soh
            on sod.SalesOrderID = soh.SalesOrderID
            join Production.Product product
            on sod.ProductID = product.ProductID
            left join Sales.SalesPerson sp
            on soh.SalesPersonID = sp.BusinessEntityID
            left join Person.Person person
            on soh.SalesPersonID = person.BusinessEntityID
        ) tbl
        group by tbl.SalesPersonName
            , tbl.ProductID
    ) tbl2
    join Production.Product product
    on tbl2.ProductID = product.ProductID
) tbl3
where tbl3.[Rank] <= 3
order by tbl3.SalesPersonName asc
    , tbl3.LineTotal desc