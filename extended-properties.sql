use AdventureWorks;

-- See the extended properties of the columns of the Person table.
select obj.name
	 , cols.name
	 , ep.value
from sys.extended_properties ep
join sys.objects obj
on ep.major_id = obj.object_id
join sys.columns cols
on obj.object_id = cols.object_id
and ep.minor_id = cols.column_id
where obj.name = 'Person'
  and ep.class_desc = 'OBJECT_OR_COLUMN';