use AdventureWorks;

----------------------------------------
-- Inspect extended properties.
----------------------------------------
-- See the extended properties of the columns of the Person table.
select obj.name TableName
     , cols.name ColumnName
     , ep.name PropertyName
     , ep.value PropertyValue
from sys.extended_properties ep
join sys.objects obj
on ep.major_id = obj.object_id
join sys.columns cols
on obj.object_id = cols.object_id
and ep.minor_id = cols.column_id
where ep.class_desc = 'OBJECT_OR_COLUMN'
  and obj.name = 'Person'
order by obj.name asc
       , cols.name asc;

-- See all extended properties of all user tables.
select sch.name SchemaName
     , tbl.name TableName
     , ep.name PropertyName
     , ep.value PropertyValue
from sys.tables tbl
join sys.extended_properties ep
on tbl.object_id = ep.major_id
join sys.schemas sch
on tbl.schema_id = sch.schema_id
where tbl.type_desc = 'USER_TABLE'
  and ep.minor_id = 0
 order by tbl.name;



----------------------------------------
-- Modify extended properties.
----------------------------------------
use BikeStores;

-- Add an extended property to a column.
exec sp_addextendedproperty  
     @name = N'ColumnDescription' 
    ,@value = N'TestPropertyValue' 
    ,@level0type = N'Schema', @level0name = 'hr' 
    ,@level1type = N'Table',  @level1name = 'candidates'
    ,@level2type = N'Column', @level2name = 'fullname'
go

-- Add an extended property to a table.
exec sp_addextendedproperty  
     @name = N'TableDescription' 
    ,@value = N'Some description' 
    ,@level0type = N'Schema', @level0name = 'hr' 
    ,@level1type = N'Table',  @level1name = 'candidates'
go

-- Drop an extended property from a table.
exec sp_dropextendedproperty  
     @name = N'TableDescription' 
    ,@level0type = N'Schema', @level0name = 'hr' 
    ,@level1type = N'Table',  @level1name = 'candidates'
go