select json_array_elements(dt) from buf.contents; -- если в ячейке json с массивом объектов и их надо разфигачить по одному

create table buf.cont_items(
	iid bigserial not null primary key,
	rid_contents int not null references buf.contents(iid),
	dt json not null
);

START TRANSACTION;

with n as (
	select
		iid,
		json_array_elements(dt) as dt
	from buf.contents
	where iid not in ( select rid_contents from buf.cont_items )
)
	insert into buf.cont_items ( rid_contents, dt )
		select iid, dt from n;

ROLLBACK TRANSACTION;

select
	iid,
	dt::jsonb ? 'description' as has_description, -- вернет t если есть такое поле или f если нет
	coalesce(dt->>'description', dt->>'descr') as fdescription, -- выдернуть значение если поле имеет тип json ->  получить в виде json ->> в виде текста
	-- coalesce вернет первое значение не null
	dt->'url_chain',
	dt
from buf.cont_items;

with n as (
	select
			iid,
			json_each(dt) as x -- пройтись по массиву и разбить по ключам и значениям
		from buf.cont_items
)
select iid, (x).key as key, (x).value as value
	from n;	

	with n as (
	select
			iid,
			json_each(dt) as x -- пройтись по массиву и разбить по ключам и значениям
		from buf.cont_items
)
select iid, 
	to_json('{' || string_agg( (x).key || ':' || (x).value::text, ',') || '}')
	from n
	where (x).key not in('description', 'descr')
	group by;	