create temp table impression_fields as 
with fld as (
	select 
		iid,
		json_each(dt) as x
	from buf.impression
	where json_typeof(dt)='object'
)
select iid, (x).key as akey, (x).value as avalue
	from fld
union all
select
	iid,
	'url' as akey,
	dt as value,
	from buf.impression
	where json_typeof(dt) = 'string';

--забить новый столбец рандомным числами
create temp sequence enumerate;

update buf.impression
	set number = nextval('enumerate');

select * from buf.impression;



declare cont cursor for
	select iid, dt
		from buf.contents;

fetch next from cont;
fetch prior from cont;
fetch forward 5 from cont;

close cont;

