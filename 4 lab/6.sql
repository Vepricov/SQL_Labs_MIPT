﻿use TV
--Для каждого города вывести количество событий в нем, и их средний уровень опасности

select CITY.[name], count([EVENT].event_id) as 'Количество событий', isnull(avg(DANGER.[level] * 1.0), 0) as 'Средний уровень опасности'
from CITY
left join [EVENT] on CITY.city_id = [EVENT].city_id
left join DANGER on [EVENT].danger_id = DANGER.danger_id
group by CITY.[name]