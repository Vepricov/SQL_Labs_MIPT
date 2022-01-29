use TV
--Удалить телеканал СТС

delete from BROADCAST
where channel_id in (select CHANNEL.channel_id from CHANNEL where CHANNEL.[name] = 'СТС')

delete from CHANNEL
where [name] = 'СТС'

select * from CHANNEL