use TV
--������� ���������, ������� ���� ����� � 2019 ����

delete from REPORT_MAKERS
where report_id in (select report_id from REPORT
where REPORT.[date] < '01.01.2020')

delete from BROADCAST
where report_id in (select report_id from REPORT
where REPORT.[date] < '01.01.2020')

delete from REPORT
where [date] < '01.01.2020'

select * from REPORT