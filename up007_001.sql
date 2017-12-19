START TRANSACTION;

create type oredered_json as (
	ord int, 
	val json
);

create function json_ordered_array( arr json ) 
	returns setof ordered_json as
$$
DECLARE
	k int;
BEGIN
	for k in 0..json_array_length(arr)-1 loop
		return next (k, arr->k);
	end loop;
END;
$$
language plpgsql
immutable
returns null on null input
security invoker; 

ROLLBACK TRANSACTION;

drop rule if exists update_program on programs;

create rule update_program as
	on insert to programs
	where ( NEW.code in ( select code from programs ) )
	do instead
		update programs
			set aval = NEW.aval,
				is_actual = NEW.is_actual
				where code = NEW.code;

START TRANSACTION;

create table vip_client_data (
	iid int not null primary key references client(iid),
	category char(1) not null check (category in ('A', 'B', 'C')  ) default 'C'
);

create table vip_client (
	iid int,
	fio text,
	phone text,
	category char(1)
);

create rule "_RETURN" as
	on select to vip_client
	do instead
		select c.iid, c.fio, c.phone, v.category
			from client c
			inner join vip_client_data v
				on v.iid = c.iid;
ROLLBACK TRANSACTION;

START TRANSACTION;

create function insert_vip_client() returns trigger as $$
DECLARE
	id int;
BEGIN
	with dat as (
		insert into client( fio, phone )
			values ( NEW.fio, NEW.phone )
		returning iid 
	) select iid 
		into strict id 
		from dat;
	insert into vip_client_data (iid, category)
		values (id, NEW.category);
	retrun NEW;
END;
$$
language plpgsql
security definer;

create trigger insert_vip_client_trigger
	instead of insert
	on vip_client
	for each row
	execute procedure insert_vip_client();

ROLLBACK TRANSACTION;

start transaction;

create function delete_vip_client() returns tirgger as
$$
declare
begin
	delete from vip_client_data
		where iid = OLD.iid;
	delete from client
		where iid = OLD.iid;
	return OLD;
end;
$$
language plpgsql
security definer;

create trigger delete_vip_client trigger
	instead of delete
	on vip_client
	for each row
	execute procedure delete_vip_client();

rollback transaction;
