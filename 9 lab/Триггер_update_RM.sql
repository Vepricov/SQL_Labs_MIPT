--Триггер который за каждые 3 сюжета повышенной опасности зарплата повышается в 1.4 раза, за 3 обычной понижается в 1.4 раза, если была повышена.
--А также оставляет записи в таблице TRIG_LOG описание проделанных операци для контроля действия триггера
USE TV
GO

IF OBJECT_ID ('dbo.trig_2', 'TR') IS NOT NULL
   DROP TRIGGER dbo.trig_2
GO

CREATE TRIGGER dbo.trig_2 ON REPORT_MAKERS
AFTER UPDATE
AS
IF (@@ROWCOUNT = 0)
	RETURN;
BEGIN
	DECLARE @i INT 
	SET @i = 1
	DECLARE @size INT
	SET @size = (SELECT COUNT(*) FROM inserted)
	DECLARE @TEMP TABLE
	(
		con1 INT,
		rep1 INT,
		con2 INT,
		rep2 INT,
		num INT
	)
	INSERT INTO @TEMP(con1, rep1, con2, rep2, num) SELECT *, ROW_NUMBER() OVER (ORDER BY deleted.report_id) as numb  FROM deleted, inserted
	WHILE (@i <= @size)
	BEGIN
		DECLARE @report1 INT 
		DECLARE @contract1 INT
		DECLARE @report2 INT 
		DECLARE @contract2 INT
		SET @contract1 = (SELECT con1 FROM @TEMP
		WHERE num = @i)	
		SET @report1 = (SELECT rep1 FROM @TEMP
		WHERE num = @i)	
		SET @contract2 = (SELECT con2 FROM @TEMP
		WHERE num = @i)	
		SET @report2 = (SELECT rep2 FROM @TEMP
		WHERE num = @i)
		IF ((SELECT DANGER.level FROM DANGER 
			JOIN EVENT ON EVENT.danger_id = DANGER.danger_id
			JOIN REPORT ON REPORT.event_id = EVENT.event_id
			WHERE REPORT.report_id = @report1) >= 3 AND
			(SELECT COUNT(*) FROM REPORT_MAKERS
			JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id
			AND REPORT.report_id NOT IN (SELECT rep1 FROM @TEMP WHERE num > @i)
			JOIN EVENT ON EVENT.event_id = REPORT.event_id
			JOIN DANGER ON DANGER.danger_id = EVENT.danger_id
			WHERE REPORT_MAKERS.contract_id = @contract1 AND DANGER.level >= 3
			GROUP BY REPORT_MAKERS.contract_id) % 3 = 2 AND 
			(SELECT SUM(TRIG_LOG.is_increased) FROM TRIG_LOG
			WHERE TRIG_LOG.contract_id = @contract1) != 0)
		BEGIN
			UPDATE CONTRACT SET CONTRACT.salary = CONTRACT.salary / 1.4
			WHERE CONTRACT.contract_id = @contract1
			INSERT INTO TRIG_LOG VALUES (@contract1, -1, 2, GETDATE()) 
		END
		IF ((SELECT DANGER.level FROM DANGER 
			JOIN EVENT ON EVENT.danger_id = DANGER.danger_id
			JOIN REPORT ON REPORT.event_id = EVENT.event_id
			WHERE REPORT.report_id = @report1) < 3 AND
			(SELECT COUNT(*) FROM REPORT_MAKERS
			JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id
			AND REPORT.report_id NOT IN (SELECT rep1 FROM @TEMP WHERE num > @i)
			JOIN EVENT ON EVENT.event_id = REPORT.event_id
			JOIN DANGER ON EVENT.danger_id = DANGER.danger_id
			WHERE REPORT_MAKERS.contract_id = @contract1 AND DANGER.level < 3 
			GROUP BY REPORT_MAKERS.contract_id) % 3 = 2 AND 
			(SELECT SUM(TRIG_LOG.is_increased) FROM TRIG_LOG
			WHERE TRIG_LOG.contract_id = @contract1) != 0)
		BEGIN
			UPDATE CONTRACT SET CONTRACT.salary = CONTRACT.salary * 1.4
			WHERE CONTRACT.contract_id = @contract1
			INSERT INTO TRIG_LOG VALUES (@contract1, 1, 2, GETDATE()) 
		END	
		IF ((SELECT DANGER.level FROM DANGER 
			JOIN EVENT ON EVENT.danger_id = DANGER.danger_id
			JOIN REPORT ON REPORT.event_id = EVENT.event_id
			WHERE REPORT.report_id = @report2) >= 3 AND
			(SELECT COUNT(*) FROM REPORT_MAKERS
			JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id
			AND REPORT.report_id NOT IN (SELECT rep2 FROM @TEMP WHERE num > @i)
			JOIN EVENT ON EVENT.event_id = REPORT.event_id
			JOIN DANGER ON DANGER.danger_id = EVENT.danger_id
			WHERE REPORT_MAKERS.contract_id = @contract2 AND DANGER.level >= 3
			GROUP BY REPORT_MAKERS.contract_id) % 3 = 0)
		BEGIN
			UPDATE CONTRACT SET CONTRACT.salary = CONTRACT.salary * 1.4
			WHERE CONTRACT.contract_id = @contract2
			INSERT INTO TRIG_LOG VALUES (@contract2, 1, 2, GETDATE()) 
		END
		IF ((SELECT DANGER.level FROM DANGER 
			JOIN EVENT ON EVENT.danger_id = DANGER.danger_id
			JOIN REPORT ON REPORT.event_id = EVENT.event_id
			WHERE REPORT.report_id = @report2) < 3 AND
			(SELECT COUNT(*) FROM REPORT_MAKERS
			JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id
			AND REPORT.report_id NOT IN (SELECT rep2 FROM @TEMP WHERE num > @i)
			JOIN EVENT ON EVENT.event_id = REPORT.event_id
			JOIN DANGER ON EVENT.danger_id = DANGER.danger_id
			WHERE REPORT_MAKERS.contract_id = @contract2 AND DANGER.level < 3 
			GROUP BY REPORT_MAKERS.contract_id) % 3 = 0 AND 
			(SELECT SUM(TRIG_LOG.is_increased) FROM TRIG_LOG
			WHERE TRIG_LOG.contract_id = @contract2) != 0)
		BEGIN
			UPDATE CONTRACT SET CONTRACT.salary = CONTRACT.salary / 1.4
			WHERE CONTRACT.contract_id = @contract2
			INSERT INTO TRIG_LOG VALUES (@contract2, -1, 2, GETDATE()) 
		END	
	SET @i = @i + 1
	END
END
GO