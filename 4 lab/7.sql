use TV
--Вывести департаменты и их среднее качество видео

select DEPARTMENT.[name], avg(QUALITY.quality * 1.0) as 'среднее качество видео' from DEPARTMENT
join [CONTRACT] on [CONTRACT].department_id = DEPARTMENT.department_id
join REPORT_MAKERS on REPORT_MAKERS.contract_id = [CONTRACT].contract_id
join REPORT on REPORT.report_id = REPORT_MAKERS.report_id
join QUALITY on QUALITY.quality_id = REPORT.quality_id
group by DEPARTMENT.[name]
order by avg(QUALITY.quality * 1.0) desc