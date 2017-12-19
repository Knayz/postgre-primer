create table request_contents(
	iid serial not null primary key,
	fmd5 char(32) not null check (fmd5 ~ '[a-f0-9]+$' ),
	mimetype text,
	file_ext text,
	fcomment text,
	fother json
);

create table request(
	iid serial not null primary key,
	furl text not null,
	fenter timestamp not null,
	fleave timestamp not null,
	rid_comp int not null references computer(iid),
	fuseragent text,
	fipaddr inet,
	freferrer text,
	fcomment text,
	fother json
);

create table content_of_request(
	rid_request int not null references request(iid),
	rid_content int not null references request_contents(iid),
	constraint pk_content_of_request primary key(rid_request, rid_content)
);

update db_version
	set fversion = 3,
		fdate = CURRENT_TIMESTAMP;
