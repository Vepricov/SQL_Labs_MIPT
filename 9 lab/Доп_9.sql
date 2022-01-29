--таблица 4 поля
--логин дата название базы данных название таблицы как только 

drop table dbo.test_trig
go

drop trigger test ON ALL SERVER 
go

create table dbo.test_trig
(
[login] varchar(2000),
[DB_name] varchar(2000),
[table] varchar(100),
date datetime
)
go

create trigger test
ON ALL SERVER
for CREATE_TABLE
as
begin
insert dbo.test_trig([login], [DB_name], [table], [date]) values (ORIGINAL_LOGIN(),
(select EVENTDATA().value('(/EVENT_INSTANCE/DatabaseName)[1]','nvarchar(max)')), (select EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(max)')), (select GETDATE()))
end

drop table TV..test2
create table TV..test2(id int)

go
drop table master..test1
go


create table master..test1
(
A INT
)

go
select *
from dbo.test_trig
