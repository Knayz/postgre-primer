create table db_version(
	fversion int not null,
	fdate timestamp not null
);

create domain short_symbol as char(3)
	constraint check (value ~ '[[:space:]]'); --проверить на регулярку

create table comp_destination (
	aid short_symbol not null primary key,
	ftitle text not null unique,
	fcomment text
);

insert into comp_destination (aid, ftitle)
	values ('дом', 'домашний'),
			('раб', 'рабочий');

create table comp_type(
	aid varchar(5) not null primary key,
	ftitle text not null unique,
	fcomment text
);

insert into comp_type (aid, ftitle)
	values ('desc', 'стационарный компьютер'),
			('tabl', 'планшет');

create sequence cities_iid_seq;

create table cities(
	iid int not null primary key default nextval('cities_iid_seq'),
	ftitle text not null unique,
	fcomment text
);

alter sequence cities_iid_seq -- последовательность 1, 2 ,3 четко
	owned by cities.iid;

insert into cities(iid, ftitle)
	values( -1, 'Москва'),
			(-2, 'Санкт-Петербург');

insert into db_version( fversion, fdate )
	values (1, CURRENT_TIMESTAMP);