START TRANSACTION;

--insert into computer (rid_destination, rid_type,
--						fexclusive, fother, rid_owner)

with n as (
			insert into main_owner(ffio, fbirth, fsex)
				values ('Сидорова', '1792-09-22', 'Ж')
				returning iid
) 
	insert into computer (rid_destination, rid_type, fexclusive
						fother, rid_owner)
		select 
			c.rid_destination,
			c.rid_type,
			c.fexclusive,
			c.fother,
			n.iid as rid_owner
		from computer c, n
		where c.rid_owner = 5;

COMMIT TRANSACTION;