use TV
--������� ��������� ���

delete from BROADCAST
where channel_id in (select CHANNEL.channel_id from CHANNEL where CHANNEL.[name] = '���')

delete from CHANNEL
where [name] = '���'

select * from CHANNEL