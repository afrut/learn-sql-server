----------------------------------------
-- Description and schema of all tables in the database.
----------------------------------------
select sch.name SchemaName
     , obj.name TableName
     , cols.name ColumnName
	 , t.name TypeName
     , case when cols.is_nullable = 0 then 'No' else 'Yes' end Nullable
     , ep.name PropertyName
     , ep.value PropertyValue
from sys.extended_properties ep
join sys.objects obj
on ep.major_id = obj.object_id
join sys.schemas sch
on obj.schema_id = sch.schema_id
join sys.columns cols
on obj.object_id = cols.object_id
and ep.minor_id = cols.column_id
join sys.types t
on cols.user_type_id = t.user_type_id
where ep.class_desc = 'OBJECT_OR_COLUMN'
  --and obj.name = 'Person'
  and sch.name not in ('dbo')
order by sch.name asc
       , obj.name asc
       , cols.name asc;