use TV
--��� �������, ���������� ���������������, ���������� ���� ��� �������, ������� ����� � ������� ��������, ����������� ����� ���� �������

select [TYPE].[name], COUNT([CONTRACT].contract_id) as '���������� ���������������', AVG(DATEDIFF(MINUTE, '0:0:0', REPORT.duration) * 1.0) as '������� ����� � ������� ��������(���)'
from [TYPE]
join REPORT on REPORT.[type_id] = [TYPE].[type_id]
join REPORT_MAKERS on REPORT_MAKERS.report_id = REPORT.report_id
join [CONTRACT] on [CONTRACT].contract_id = REPORT_MAKERS.contract_id
join JOB on JOB.job_id = [CONTRACT].job_id and JOB.[function] = '�������'
group by [TYPE].[name]
