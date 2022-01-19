use AdventureWorks;

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
select tbl.name TableName
	 , ep.name PropertyName
	 , ep.value PropertyValue
from sys.tables tbl
join sys.extended_properties ep
on tbl.object_id = ep.major_id
where tbl.type_desc = 'USER_TABLE'
  and ep.minor_id = 0
 order by tbl.name;