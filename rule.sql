--запрет удаления из таблицы computer
create rule no_comp_delete as
	on delete to computer
	do insted nothing;

--удалить правило
drop rule no_comp_delete on computer;

--помечаем запись удаленной 
--new - данные которым предстоит появится в таблице
--old - будут убраны из таблицы

create rule no_comp_delete as
	on delete to computer
	do insted 
		update computer
			set fdeleted = CURRENT_TIMESTAMP
			where iid = OLD.iid;