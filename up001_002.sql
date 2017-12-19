CREATE TABLE main_owner(
	iid serial not null primary key, --serial автоматом создает последовательность
	ffio text not null,
	fbirth date not null,
	fsex char(1) not null check ( fsex in ('М', 'Ж') ), -- проверка
	rid_city int not null,
	rid_computer int not null,
	fcomment text,
	fother json,
	constraint fk_owner_city foreign key (rid_city) references cities(iid)--внешний ключ
);

CREATE TABLE computer (
	iid serial not null primary key,
	rid_destination short_symbol not null references comp_destination(aid),
	rid_type varchar(5) not null references comp_type(aid),
	fexclusive boolean not null,
	fcomment text,
	fother json
);

alter table main_owner
	add constraint fk_owner_computer
		foreign key (rid_computer)
		references computer( iid );
		
update db_version
	set fversion = 2,
		fdate = CURRENT_TIMESTAMP;
