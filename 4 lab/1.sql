use TV
--Выбрать список репортажей из 'Москвы' за год, корреспондента, их представляющего и время репортажа.

select REPORT.[name], EMPLOYEE.first_name, EMPLOYEE.last_name, REPORT.duration from REPORT
join [EVENT] on REPORT.event_id = [EVENT].event_id and [EVENT].[start_date] >= '01.01.2020' and [EVENT].end_date <= '31.12.2020'
join CITY on [EVENT].city_id = CITY.city_id and CITY.name = 'Москва'
join REPORT_MAKERS on REPORT_MAKERS.report_id = REPORT.report_id
join [CONTRACT] on [CONTRACT].contract_id = REPORT_MAKERS.contract_id
join EMPLOYEE on EMPLOYEE.employee_id = [CONTRACT].employee_id
join JOB on JOB.job_id = [CONTRACT].job_id and JOB.[function] = 'Репортёр'