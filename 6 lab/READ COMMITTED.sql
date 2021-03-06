use TV
--Грязное чтение READ COMMITTED (1)

UPDATE EMPLOYEE SET country_id = 2
WHERE EMPLOYEE.employee_id = 25

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION 
SELECT * FROM EMPLOYEE
WHERE EMPLOYEE.employee_id = 25

SELECT * FROM EMPLOYEE
WHERE EMPLOYEE.employee_id = 25

SELECT * FROM EMPLOYEE
WHERE EMPLOYEE.employee_id = 25
COMMIT

--Грязное чтение READ COMMITTED (2)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION 
UPDATE EMPLOYEE
SET country_id = 1
WHERE EMPLOYEE.employee_id = 25
ROLLBACK

--Неповторяющееся чтение READ COMMITTED (1)

UPDATE [EVENT] SET danger_id = 1
WHERE [EVENT].event_id = 4

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRANSACTION 
SELECT * 
FROM [EVENT] 
WHERE [EVENT].event_id = 4

SELECT * 
FROM [EVENT] 
WHERE [EVENT].event_id = 4
COMMIT 

--Неповторяющееся чтение READ COMMITTED(2)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION
UPDATE [EVENT]
SET danger_id = 2
WHERE [EVENT].event_id = 4
COMMIT