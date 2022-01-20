use AdventureWorks;

select fk.name
     , parentSchema.name ParentSchemaName
     , parentObject.name ParentName
     , parentColumns.name ParentColumn
     , refSchema.name RefSchemaName
     , refObject.name RefName
     , refColumns.name RefColumn
from sys.foreign_keys fk
join sys.foreign_key_columns fkc
on fk.object_id = fkc.constraint_object_id

-- Join to get parent's names.
join sys.objects parentObject
on fkc.parent_object_id = parentObject.object_id
join sys.schemas parentSchema
on parentObject.schema_id = parentSchema.schema_id
join sys.columns parentColumns
on fkc.parent_object_id = parentColumns.object_id
and fkc.parent_column_id = parentColumns.column_id

-- Join to get referenced's names.
join sys.objects refObject
on fkc.referenced_object_id = refObject.object_id
join sys.schemas refSchema
on refObject.schema_id = refSchema.schema_id
join sys.columns refColumns
on fkc.referenced_object_id = refColumns.object_id
and fkc.referenced_column_id = refColumns.column_id

-- Show what a table's foreign keys are.
where 
      (parentSchema.name = 'Sales' and parentObject.name = 'SalesPersonQuotaHistory')
   or (parentSchema.name = 'Sales' and parentObject.name = 'SalesPerson')

-- Show what foreign keys reference a certain table's column
-- where refSchema.name = 'Person'
--   and refObject.name = 'Person'
--   and refColumns.name = 'BusinessEntityID'

order by parentSchema.name asc
       , parentObject.name asc
       , parentColumns.name asc;