﻿use TV
--Неповторяющееся чтение REPEATABLE READ (1)

UPDATE [EVENT] SET danger_id = 1
WHERE [EVENT].event_id = 4

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION 
SELECT * 
FROM [EVENT] 
WHERE [EVENT].event_id = 4

SELECT * 
FROM [EVENT] 
WHERE [EVENT].event_id = 4
COMMIT 

--Неповторяющееся чтение REPEATABLE READ(2)

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
UPDATE [EVENT]
SET danger_id = 2
WHERE [EVENT].event_id = 4
COMMIT

--Фантом REPEATABLE READ (1)

DELETE FROM [CONTRACT]
WHERE [CONTRACT].contract_id = 51

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION 

SELECT * 
FROM [CONTRACT]
WHERE [CONTRACT].hire_date > '01.08.2018'

SELECT * 
FROM [CONTRACT]
WHERE [CONTRACT].hire_date > '01.08.2018'
COMMIT

--Фантом REPEATABLE READ (2)

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION 

INSERT [CONTRACT](contract_id, employee_id, job_id, hire_date, department_id) VALUES(51, 50, 5, '25.09.2018', 10)
COMMIT