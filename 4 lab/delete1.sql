use TV
--������� �� ���� ������ ���� ���������� � ������ ����

delete from REPORT_MAKERS
where contract_id in (select [CONTRACT].contract_id from [CONTRACT]
where [CONTRACT].employee_id in (select EMPLOYEE.employee_id from EMPLOYEE
where EMPLOYEE.last_name = '����'))

delete from [CONTRACT]
where [CONTRACT].employee_id in (select EMPLOYEE.employee_id from EMPLOYEE
where EMPLOYEE.last_name = '����')

delete from EMPLOYEE
where EMPLOYEE.last_name = '����'

select * from EMPLOYEE