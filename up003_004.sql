START TRANSACTION;

alter table main_owner
	alter column rid_city
		drop not null;

alter table main_owner
	alter column rid_computer
		drop not null;

alter table computer
	alter column fexclusive
		drop not null;

update db_version
	set fversion = 4,
		fdate = CURRENT_TIMESTAMP;

COMMIT TRANSACTION;