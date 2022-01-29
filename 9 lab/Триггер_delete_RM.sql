--Триггер который за каждые 3 сюжета повышенной опасности зарплата повышается в 1.4 раза, за 3 обычной понижается в 1.4 раза, если была повышена.
--А также оставляет записи в таблице TRIG_LOG описание проделанных операци для контроля действия триггера
USE TV
GO

IF OBJECT_ID ('dbo.trig_3', 'TR') IS NOT NULL
   DROP TRIGGER dbo.trig_3
GO

CREATE TRIGGER dbo.trig_3 ON REPORT_MAKERS
AFTER DELETE
AS
IF (@@ROWCOUNT = 0)
	RETURN;
BEGIN
	DECLARE @i INT 
	SET @i = 1
	DECLARE @size INT
	SET @size = (SELECT COUNT(*) FROM deleted)
	DECLARE @TEMP TABLE
	(
		con INT,
		rep INT,
		num INT
	)
	INSERT INTO @TEMP SELECT *, ROW_NUMBER() OVER (ORDER BY report_id) as numb FROM deleted
	WHILE (@i <= @size)
	BEGIN
		DECLARE @report INT 
		DECLARE @contract INT
		SET @contract = (SELECT con FROM @TEMP
		WHERE num = @i)	
		SET @report = (SELECT rep FROM @TEMP
		WHERE num = @i)		
		IF ((SELECT DANGER.level FROM DANGER 
			JOIN EVENT ON EVENT.danger_id = DANGER.danger_id
			JOIN REPORT ON REPORT.event_id = EVENT.event_id
			WHERE REPORT.report_id = @report) >= 3 AND
			(SELECT COUNT(*) FROM REPORT_MAKERS
			JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id
			AND REPORT.report_id NOT IN (SELECT rep FROM @TEMP WHERE num > @i)
			JOIN EVENT ON EVENT.event_id = REPORT.event_id
			JOIN DANGER ON DANGER.danger_id = EVENT.danger_id
			WHERE REPORT_MAKERS.contract_id = @contract AND DANGER.level >= 3
			GROUP BY REPORT_MAKERS.contract_id) % 3 = 2 AND 
			(SELECT SUM(TRIG_LOG.is_increased) FROM TRIG_LOG
			WHERE TRIG_LOG.contract_id = @contract) != 0)
		BEGIN
			UPDATE CONTRACT SET CONTRACT.salary = CONTRACT.salary / 1.4
			WHERE CONTRACT.contract_id = @contract
			INSERT INTO TRIG_LOG VALUES (@contract, -1, 3, GETDATE()) 
		END
		IF ((SELECT DANGER.level FROM DANGER 
			JOIN EVENT ON EVENT.danger_id = DANGER.danger_id
			JOIN REPORT ON REPORT.event_id = EVENT.event_id
			WHERE REPORT.report_id = @report) < 3 AND
			(SELECT COUNT(*) FROM REPORT_MAKERS
			JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id
			AND REPORT.report_id NOT IN (SELECT rep FROM @TEMP WHERE num > @i)
			JOIN EVENT ON EVENT.event_id = REPORT.event_id
			JOIN DANGER ON EVENT.danger_id = DANGER.danger_id
			WHERE REPORT_MAKERS.contract_id = @contract AND DANGER.level < 3 
			GROUP BY REPORT_MAKERS.contract_id) % 3 = 2 AND 
			(SELECT SUM(TRIG_LOG.is_increased) FROM TRIG_LOG
			WHERE TRIG_LOG.contract_id = @contract) != 0)
		BEGIN
			UPDATE CONTRACT SET CONTRACT.salary = CONTRACT.salary * 1.4
			WHERE CONTRACT.contract_id = @contract
			INSERT INTO TRIG_LOG VALUES (@contract, 1, 3, GETDATE()) 
		END	
	SET @i = @i + 1
	END
END
GO