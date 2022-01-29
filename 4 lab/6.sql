use TV
--��� ������� ������ ������� ���������� ������� � ���, � �� ������� ������� ���������

select CITY.[name], count([EVENT].event_id) as '���������� �������', isnull(avg(DANGER.[level] * 1.0), 0) as '������� ������� ���������'
from CITY
left join [EVENT] on CITY.city_id = [EVENT].city_id
left join DANGER on [EVENT].danger_id = DANGER.danger_id
group by CITY.[name]