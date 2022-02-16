-- These queries answer: which are the most profitable products?
select tbl.ProductName
     , tbl.Margin
     , dense_rank() over
        (order by tbl.Margin desc) [Rank]
from
(
    select product.[Name] ProductName
         , product.ListPrice - product.StandardCost Margin
    from Production.Product product
) tbl
order by tbl.[Margin] desc