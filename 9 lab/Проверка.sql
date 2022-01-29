--16(Кулишов) 2 опасных, 2 неопасных
--1(Акборисов) 2 неопсаных

SELECT DANGER.level FROM REPORT_MAKERS
JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id
JOIN EVENT ON EVENT.event_id = REPORT.event_id
JOIN DANGER ON DANGER.danger_id = EVENT.danger_id
WHERE REPORT_MAKERS.contract_id = 16

SELECT DANGER.level FROM REPORT_MAKERS
JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id
JOIN EVENT ON EVENT.event_id = REPORT.event_id
JOIN DANGER ON DANGER.danger_id = EVENT.danger_id
WHERE REPORT_MAKERS.contract_id = 1
---------
insert EVENT(event_id, [start_date], end_date, danger_id, [description], city_id) values(16, '10.08.2019', '15.08.2020', 3, 'test', 1)--опасный
insert EVENT(event_id, [start_date], end_date, danger_id, [description], city_id) values(17, '10.08.2019', '15.08.2020', 2, 'test', 1)--неопасный
insert REPORT(report_id, quality_id, [date], [type_id], event_id, duration, [name]) values(21, 3, '20.09.2020', 1, 16, '01:15:00', 'test')--опасный
insert REPORT(report_id, quality_id, [date], [type_id], event_id, duration, [name]) values(22, 3, '31.08.2020', 3, 17, '00:30:00', 'test')--неопсаный
insert REPORT(report_id, quality_id, [date], [type_id], event_id, duration, [name]) values(23, 3, '31.08.2020', 3, 17, '00:30:00', 'test')--неопасный

select * from CONTRACT 
where contract_id = 16

insert REPORT_MAKERS(contract_id, report_id) values(16, 21)

--insert REPORT_MAKERS(contract_id, report_id) values(16, 23)

--UPDATE REPORT_MAKERS SET report_id = 22 WHERE contract_id = 16 AND report_id = 21

--UPDATE REPORT_MAKERS SET report_id = 21 WHERE contract_id = 16 AND report_id = 22

--DELETE FROM REPORT_MAKERS WHERE report_id = 21 AND contract_id = 16

--UPDATE REPORT SET event_id = 17 WHERE event_id = 16

--UPDATE REPORT SET event_id = 16 WHERE event_id = 17

--UPDATE EVENT SET danger_id = 2 WHERE event_id = 16

--select * from TRIG_LOG

select * from CONTRACT 
where contract_id = 16
--------
select * from CONTRACT
where contract_id = 1

insert REPORT_MAKERS(contract_id, report_id) values(1, 22)

select * from CONTRACT
where contract_id = 1
--------
select * from CONTRACT 
where contract_id = 16

insert REPORT_MAKERS(contract_id, report_id) values(16, 23)

select * from CONTRACT 
where contract_id = 16
--------
DELETE FROM REPORT_MAKERS
WHERE contract_id = 16 AND report_id > 20

DELETE FROM REPORT_MAKERS
WHERE contract_id = 1 AND report_id > 20

DELETE FROM REPORT
WHERE report_id > 20

DELETE FROM EVENT
WHERE event_id > 15

UPDATE CONTRACT SET salary = 60000 WHERE contract_id = 16