USE TV
GO

SELECT session_id FROM sys.dm_exec_sessions WHERE login_name = 'login_test'

kill 51


EXECUTE sp_droplogin 'login_test'
EXECUTE sp_dropuser 'user_test'

CREATE LOGIN login_test WITH PASSWORD = '0000'
CREATE USER user_test FOR LOGIN login_test

------

--Проверка прав доступа у user_test
EXECUTE AS user = 'user_test'
BEGIN TRAN

SELECT * FROM EMPLOYEE

SELECT EMPLOYEE.first_name FROM EMPLOYEE

UPDATE [CONTRACT] 
	SET hire_date = '25.10.2020' WHERE contract_id = 1

INSERT DANGER(danger_id, [level], [description]) VALUES(5, 5, 'Атомная война')

DELETE FROM REPORT_MAKERS 
	WHERE CONTRACT_id = 1

ROLLBACK
REVERT
------

--Присвоить новому пользователю права SELECT, INSERT, UPDATE в полном объеме на одну таблицу

GRANT INSERT, SELECT, UPDATE ON DANGER TO user_test

EXECUTE AS USER = 'user_test'
BEGIN TRAN

SELECT * FROM DANGER
SELECT * FROM CHANNEL

UPDATE DANGER
	SET [description] = 'Безболезненно' 
	WHERE danger_id = 1

INSERT DANGER(danger_id, [level], [description]) VALUES(5, 5, 'Атомная война')

DELETE FROM DANGER 
	WHERE danger_id = 1

ROLLBACK
REVERT

REVOKE INSERT, SELECT, UPDATE TO user_test
-----

--Для одной таблицы новому пользователю присвоим права SELECT и UPDATE только избранных столбцов.
GRANT SELECT, UPDATE ON REPORT (event_id, [type_id], [name]) TO user_test

EXECUTE AS USER = 'user_test'
BEGIN TRAN

SELECT * FROM REPORT

SELECT event_id, [type_id], [name] FROM REPORT

UPDATE REPORT	
 	SET quality_id = 1
	WHERE event_id = 3

UPDATE REPORT
 	SET [type_id] = 3
	WHERE event_id = 3

ROLLBACK
REVERT

REVOKE SELECT, UPDATE TO user_test
------

--Для одной таблицы новому пользователю присвоим только право SELECT.

GRANT SELECT ON EMPLOYEE TO user_test;

EXECUTE AS USER = 'user_test'

SELECT * FROM CHANNEL

SELECT * FROM EMPLOYEE

UPDATE EMPLOYEE
	SET country_id = 2
	WHERE employee_id =  1

REVERT

REVOKE SELECT TO user_test
------

--Присвоим новому пользователю право доступа (SELECT) к представлению, созданному в лабораторной работе №5.

GRANT SELECT ON v3 TO user_test

EXECUTE AS USER = 'user_test'

SELECT * FROM v1

SELECT * FROM v3

REVERT

REVOKE SELECT TO user_test
------

--Cоздать стандартную роль уровня базы данных, присвоить ей право доступа (SELECT, UPDATE на некоторые столбцы) к представлению,
--созданному в лабораторной работе №5, назначить новому пользователю созданную роль.

CREATE ROLE role_test
GRANT SELECT, UPDATE ON v3 (reporter_first_name, reporter_last_name, report_date) TO role_test

EXECUTE sp_addrolemember 'role_test', 'user_test'

EXECUTE AS USER = 'user_test'
BEGIN TRAN

SELECT reporter_first_name, reporter_last_name, report_date  FROM v3

UPDATE v3 SET reporter_first_name = 'Топоровкий', reporter_last_name = 'Владислав'
	WHERE report_date = '31.12.2019'

ROLLBACK
REVERT
-----

EXECUTE sp_droprolemember 'role_test', 'user_test'

EXECUTE sp_droprole 'role_test'

EXECUTE sp_dropuser 'user_test'

EXECUTE sp_droplogin 'login_test'