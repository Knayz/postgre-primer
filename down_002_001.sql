--alter table main_owner
--	drop constraint fk_owner_computer;

drop table computer cascade;
drop table main_owner;
		
update db_version
	set fversion = 1,
		fdate = CURRENT_TIMESTAMP;
