create function buf.json_drop(dt json,variadic sym text[] ) 
	returns json 
	as 
$$
DECLARE
	R text;
BEGIN
	select '{' || string_agg('"' || key || '":' ||  value::text, ', ') || '}' as dt
		into strict R
		from json_each(dt)
		where key not in (select * from unnest( sym ));
	return R::json;
END;
$$
language plpgsql
immutable
returns null on null input
security invoker;
