START TRANSACTION;

drop function if exists update_vip_client_base();

create function update_vip_client() returns trigger as
$$
declare
begin
	update client
		set fio = NEW.fio,
			phone NEW.phone
		where iid = NEW.iid;
	update vip_client_data set
		category = NEW.category
		where iid = NEW.iid;
	return NEW;
end;
$$
language plpgsql
security definer;

create trigger update_vip_client_trigger
	instead of update of fio, phone
	on table vip_client
	for each row
	execute procedure update_vip_client();

ROLLBACK TRANSACTION;

select 
	c.iid,
	c.fio,
	c.phone,
	case
		when v.iid is not NULL then 'V'
		else 'C'
	end as is_vip
	from client c
	left outer join vip_client_data v
					on c.iid = v.iid;

select 
	iid,
	code,
	fio,
	phone,
	xmlelement( name client,
				xmlattributes(code as 'code', 'green' as 'color'),
				xmlattributes(name fio, fio),
				case
					when phone is null when null
					else xmlelement(name phone, phone)
				end
	) as data
	from client;