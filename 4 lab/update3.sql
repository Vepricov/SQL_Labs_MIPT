use TV
--�������� ������ ���������� ������

update EMPLOYEE set country_id = (select country_id from COUNTRY where COUNTRY.[name] = '�������')
where EMPLOYEE.first_name = '���������' and EMPLOYEE.last_name = '������'

select * from EMPLOYEE