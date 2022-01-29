use TV
--Поменять описание канала ТНТ

update CHANNEL set descriprion = 'Кино, сериалы'
where [name] = 'ТНТ'

select * from CHANNEL