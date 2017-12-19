start transaction;

create function hstore_agg_add(hstore, hstore) return hstore as
$$
	Begin
		if x is null then return med; end if;
		return med || x;
	END
$$
language plpgsql
immutable
called on null input
security invoker;

create aggregate hstore_agg(hstore) (
	stype = hstore,
	initcond = ''::hstore,
	sfunc = hstore_agg_add,
	ffunc = hstore_agg_fin
);

rollback transaction;