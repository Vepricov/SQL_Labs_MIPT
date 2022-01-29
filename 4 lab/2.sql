use TV
--Выбрать список сюжетов, их длительность, корреспондент для выпуска новостей в '18:00'.

select REPORT.[name], REPORT.duration, EMPLOYEE.first_name, EMPLOYEE.last_name, CHANNEL.[name] from REPORT
join REPORT_MAKERS on REPORT_MAKERS.report_id = REPORT.report_id
join [CONTRACT] on [CONTRACT].contract_id = REPORT_MAKERS.contract_id
join EMPLOYEE on EMPLOYEE.employee_id = [CONTRACT].employee_id
join JOB on JOB.job_id = [CONTRACT].job_id and JOB.[function] = 'Репортёр'
join BROADCAST on REPORT.report_id = BROADCAST.report_id and convert(time, BROADCAST.broadcast_time) = '18:00'
join CHANNEL on CHANNEL.channel_id = BROADCAST.channel_id
