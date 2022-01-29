use TV
--Обновить страну Шляпочника Никиты

update EMPLOYEE set country_id = (select country_id from COUNTRY where COUNTRY.[name] = 'Украина')
where EMPLOYEE.first_name = 'Шляпочник' and EMPLOYEE.last_name = 'Никита'

select * from EMPLOYEE