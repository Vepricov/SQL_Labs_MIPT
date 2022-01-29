use TV
--Корреспондент, страна, среднее время репортажа, количество репортажей, средняя степень опасности репортажа.

select EMPLOYEE.first_name, EMPLOYEE.last_name, COUNTRY.[name], avg(DATEDIFF(MINUTE, '0:0:0', REPORT.duration) * 1.0) as 'среднее время репортажа(мин)',
count(REPORT_MAKERS.contract_id) as 'количество репортажей', avg(DANGER.[level] * 1.0) as 'средняя степень опасности репортажа'
from EMPLOYEE
join COUNTRY on COUNTRY.country_id = EMPLOYEE.country_id
join [CONTRACT] on [CONTRACT].employee_id = EMPLOYEE.employee_id
join JOB on JOB.job_id = [CONTRACT].job_id and JOB.[function] = 'Репортёр'
join REPORT_MAKERS on REPORT_MAKERS.contract_id = [CONTRACT].contract_id
join REPORT on REPORT_MAKERS.report_id = REPORT.report_id
join [EVENT] on [EVENT].event_id = REPORT.event_id
join DANGER on DANGER.danger_id = [EVENT].danger_id
group by EMPLOYEE.first_name, EMPLOYEE.last_name, COUNTRY.[name]