use TV
go
--√од, мес€ц, город, страна, количество репортажей из этой страны в мес€ц, средн€€ продолжительность репортажа.
if (object_id('v2') is not null)
	drop view v2
go

create view v2 ([year], [month], city, country, count_rep_contry, avg_duravion)
as select datepart(YEAR, REPORT.[date]), datepart(MONTH, REPORT.[date]), CITY.[name], COUNTRY.[name], count(REPORT.report_id * 1.0), 
avg(DATEPART(HOUR, REPORT.duration) * 60 * 1.0 + DATEPART(MINUTE, REPORT.duration) * 1.0)
from REPORT
join [EVENT] on REPORT.event_id = [EVENT].event_id
join CITY on CITY.city_id = [EVENT].city_id
join COUNTRY on COUNTRY.country_id = CITY.country_id
join REPORT_MAKERS on REPORT_MAKERS.report_id = REPORT.report_id
join [CONTRACT] on [CONTRACT].contract_id = REPORT_MAKERS.contract_id
join JOB on JOB.job_id = [CONTRACT].job_id and JOB.[function] = '–епортЄр'
join EMPLOYEE on EMPLOYEE.employee_id = [CONTRACT].employee_id
group by datepart(YEAR, REPORT.[date]), datepart(MONTH, REPORT.[date]), CITY.[name], COUNTRY.[name]
go

select * from v2

--¬ывести города в пор€дке возрастани€ общего кол-ва репортажей в них и это кол-во
select v2.city, sum(v2.count_rep_contry) as sum_report from v2
group by v2.city
order by sum_report