use TV
go
--Работник, специфика, средняя степень опасности сюжетов, количество сюжетов в месяц.
if (object_id('v1') is not null)
	drop view v1
go

create view v1(first_name, last_name, job,  danger_lvl_avg, report_count)
as select EMPLOYEE.first_name, EMPLOYEE.last_name, JOB.[function], isnull(avg(DANGER.[level] * 1.0), 0), 
count(REPORT.report_id)
from EMPLOYEE
left join [CONTRACT] on [CONTRACT].employee_id = EMPLOYEE.employee_id
left join REPORT_MAKERS on REPORT_MAKERS.contract_id = [CONTRACT].contract_id
left join REPORT on REPORT.report_id = REPORT_MAKERS.report_id
left join [EVENT] on [EVENT].event_id = REPORT.event_id
left join DANGER on [EVENT].danger_id = DANGER.danger_id
left join JOB on JOB.job_id = [CONTRACT].job_id
group by EMPLOYEE.first_name, EMPLOYEE.last_name,  JOB.[function], [CONTRACT].hire_date
go

select * from v1

--1)Выбрать Репортёров, у которых больше 1 репортажа и стредняя степень опасности больше 1.5
select v1.first_name, v1.last_name from v1
where v1.danger_lvl_avg > 1.5 and v1.report_count > 2

--2)Найти среднюю степень опасности событий у операторов, у которых было 1, 2, 3, 4 репортажа.
select avg(a.danger_lvl_avg) as '1', avg(b.danger_lvl_avg) as '2', avg(c.danger_lvl_avg) as '3', avg(d.danger_lvl_avg) as '4' from v1 as a
join v1 as b on b.report_count = 2 and b.job = 'Оператор'
join v1 as c on c.report_count = 3 and c.job = 'Оператор'
join v1 as d on d.report_count = 4 and d.job = 'Оператор'
where a.report_count = 1 and a.job = 'Оператор'