use TV
--�������� ������ ��� ���� ����������� ������� �� ������

update CITY set country_id = (select country_id from COUNTRY where COUNTRY.[name] = '������')
where CITY.country_id in (select country_id from COUNTRY where COUNTRY.[name] = '����������')

select * from city