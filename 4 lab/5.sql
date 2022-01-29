use TV
--Выбрать операторов, которые снимали репортажи повышенной опасности(3, 4)

select distinct EMPLOYEE.first_name, EMPLOYEE.last_name from EMPLOYEE
join [CONTRACT] on [CONTRACT].employee_id = EMPLOYEE.employee_id
join JOB on JOB.job_id = [CONTRACT].job_id and JOB.[function] = 'Оператор'
join REPORT_MAKERS on REPORT_MAKERS.contract_id = [CONTRACT].contract_id
join REPORT on REPORT.report_id = REPORT_MAKERS.report_id
join [EVENT] on [EVENT].event_id = REPORT.report_id
join DANGER on DANGER.danger_id = [EVENT].danger_id and DANGER.[level] >= 3