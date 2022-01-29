use TV
go
--Список корреспондентов, время выпуска новостей, дата, длительность сюжета этого корреспондента в этом выпуске.
if (object_id('v3') is not null)
	drop view v3
go

create view v3(reporter_first_name, reporter_last_name, report_date, report_time, durarion)
as select EMPLOYEE.first_name, EMPLOYEE.last_name ,convert(date, BROADCAST.broadcast_time), convert(time(0), BROADCAST.broadcast_time), REPORT.duration
from EMPLOYEE
join [CONTRACT] on [CONTRACT].employee_id = EMPLOYEE.employee_id
join JOB on JOB.job_id = [CONTRACT].job_id and JOB.[function] = 'Репортёр'
join REPORT_MAKERS on REPORT_MAKERS.contract_id = [CONTRACT].contract_id
join REPORT on REPORT.report_id = REPORT_MAKERS.report_id
join BROADCAST on BROADCAST.report_id = REPORT.report_id
go

select * from v3

--Выбрать репортёров, у которых стредняя продолжительность выпуска больше 40 минут и вывести это время
select v3.reporter_first_name, v3.reporter_last_name, avg(DATEDIFF(MINUTE, '0:0:0', v3.durarion) * 1.0) as avg_duration from v3
group by v3.reporter_first_name, v3.reporter_last_name
having avg(DATEDIFF(MINUTE, '0:0:0', v3.durarion) * 1.0) > 30