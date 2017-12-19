START TRANSACTION;

create table active_comps(

	iid int,
	rid_destination short_symbol,
	rid_type varchar(5),
	fexlusive boolean,
	fcomment text,
	fother json,
	rid_owner int

);
-- если один селект заменяет другой то его надо называть _RETURN
create rule "_RETURN" as
	on select to active_comps
	do instead
		select iid, rid_destination, rid_type, fexlusive, fcomment
				fother, rid_owner
		from computer
		where fdeleted is NULL;

create rule new_active_comp as
	on insert to active_comps
	do instead
		insert into computer(
			iid, rid_destination, rid_type, fexlusive, fcomment
				fother, rid_owner
		) select
			iid, rid_destination, rid_type, fexlusive, fcomment
					fother, rid_owner
			from NEW;

COMMIT TRANSACTION;

--или
START TRANSACTION;

create view active_comps as
		select iid, rid_destination, rid_type, fexlusive, fcomment
				fother, rid_owner
		from computer;

COMMIT TRANSACTION;