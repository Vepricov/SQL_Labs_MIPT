use TV
--������� ��������������, ������� ������� �� ������ ������ 2018 ����

select EMPLOYEE.first_name, EMPLOYEE.last_name from EMPLOYEE
join [CONTRACT] on [CONTRACT].employee_id = EMPLOYEE.employee_id and [CONTRACT].hire_date < '01.01.2018'
join JOB on JOB.job_id = [CONTRACT].job_id and JOB.[function] = '������������'