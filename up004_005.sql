START TRANSACTION;

alter table main_owner
	drop column rid_computer;

alter table cumputer
	add column rid_owner int
		references main_owner(iid);

update db_version
	set fversion = 5,
		fdate = CURRENT_TIMESTAMP;

COMMIT TRANSACTION;