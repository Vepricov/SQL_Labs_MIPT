use TV
--Удалить из базы данных всех работников с именем Илья

delete from REPORT_MAKERS
where contract_id in (select [CONTRACT].contract_id from [CONTRACT]
where [CONTRACT].employee_id in (select EMPLOYEE.employee_id from EMPLOYEE
where EMPLOYEE.last_name = 'Илья'))

delete from [CONTRACT]
where [CONTRACT].employee_id in (select EMPLOYEE.employee_id from EMPLOYEE
where EMPLOYEE.last_name = 'Илья')

delete from EMPLOYEE
where EMPLOYEE.last_name = 'Илья'

select * from EMPLOYEE