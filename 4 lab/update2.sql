use TV
--Изменить страну для всех белорусских городов на Россию

update CITY set country_id = (select country_id from COUNTRY where COUNTRY.[name] = 'Россия')
where CITY.country_id in (select country_id from COUNTRY where COUNTRY.[name] = 'Белоруссия')

select * from city