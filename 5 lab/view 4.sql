use TV
go
--“ип событи€(специфика), количество репортажей с этой спецификой, средн€€ опасность таких событий, среднее врем€ репортажа с этой спецификой
if (object_id('v4') is not null)
	drop view v4
go

create view v4([type], count_rep,danger_lvl_avg, time_avg_min)
as select [TYPE].[name], count(REPORT.report_id), avg(DANGER.[level] * 1.0), avg(DATEDIFF(MINUTE, '0:0:0', REPORT.duration) * 1.0)
from REPORT
join [TYPE] on [TYPE].[type_id] = REPORT.[type_id]
join [EVENT] on [EVENT].event_id = REPORT.event_id
join DANGER on DANGER.danger_id = [EVENT].danger_id
group by [TYPE].[name]
go

select * from v4