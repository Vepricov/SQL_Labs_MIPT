use TV
--Тип события, количество корреспондентов, освещающих этот тип событий, среднее время в выпуске новостей, посвященное этому типу события

select [TYPE].[name], COUNT([CONTRACT].contract_id) as 'количество корреспондентов', AVG(DATEDIFF(MINUTE, '0:0:0', REPORT.duration) * 1.0) as 'среднее время в выпуске новостей(мин)'
from [TYPE]
join REPORT on REPORT.[type_id] = [TYPE].[type_id]
join REPORT_MAKERS on REPORT_MAKERS.report_id = REPORT.report_id
join [CONTRACT] on [CONTRACT].contract_id = REPORT_MAKERS.contract_id
join JOB on JOB.job_id = [CONTRACT].job_id and JOB.[function] = 'Репортёр'
group by [TYPE].[name]
