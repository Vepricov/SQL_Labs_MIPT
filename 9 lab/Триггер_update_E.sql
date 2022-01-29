--Триггер который за каждые 3 сюжета повышенной опасности зарплата повышается в 1.4 раза, за 3 обычной понижается в 1.4 раза, если была повышена.
--А также оставляет записи в таблице TRIG_LOG описание проделанных операци для контроля действия триггера
USE TV
GO

IF OBJECT_ID ('dbo.trig_4', 'TR') IS NOT NULL
   DROP TRIGGER dbo.trig_4
GO

CREATE TRIGGER dbo.trig_4 ON EVENT
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
		ev INT,
		lvl1 INT,
		lvl2 INT,
		num INT
	)
	INSERT INTO @TEMP(ev, lvl1, lvl2, num) SELECT deleted.event_id, deleted.danger_id, inserted.danger_id, ROW_NUMBER() OVER (ORDER BY deleted.event_id) as numb 
	FROM deleted JOIN inserted ON deleted.event_id = inserted.event_id
	WHILE (@i <= @size)
	BEGIN
		DECLARE @event INT 
		DECLARE @level_id1 INT
		DECLARE @level_id2 INT
		SET @event = (SELECT ev FROM @TEMP
		WHERE num = @i)	
		SET @level_id1 = (SELECT lvl1 FROM @TEMP
		WHERE num = @i)	
		SET @level_id2 = (SELECT lvl2 FROM @TEMP
		WHERE num = @i)	
		IF ((@level_id1 < 3 AND @level_id2 >= 3) OR (@level_id1 >= 3 AND @level_id2 < 3))
		BEGIN
			DECLARE @size_rep INT
			DECLARE @j INT
			SET @j = 1
			SET @size_rep = (SELECT COUNT(*) FROM REPORT_MAKERS
			JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id AND REPORT.event_id = @event)
			DECLARE @TEMP1 TABLE
			(
				con INT,
				num INT
			)
			INSERT INTO @TEMP1 SELECT REPORT_MAKERS.contract_id, ROW_NUMBER() OVER (ORDER BY REPORT_MAKERS.contract_id) as numb1  FROM REPORT_MAKERS
			JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id AND REPORT.event_id = @event
			GROUP BY REPORT_MAKERS.contract_id
			WHILE (@j <= @size_rep)
			BEGIN
				DECLARE @contract INT
				SET @contract = (SELECT con FROM @TEMP1
				WHERE num = @j)	
				IF (@level_id1 >= 3 AND 
					(SELECT COUNT(*) FROM REPORT_MAKERS
					JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id
					JOIN EVENT ON EVENT.event_id = REPORT.event_id
					JOIN DANGER ON DANGER.danger_id = EVENT.danger_id
					WHERE REPORT_MAKERS.contract_id = @contract AND (DANGER.level >= 3 OR EVENT.event_id = @event)
					GROUP BY REPORT_MAKERS.contract_id) % 3 = 0 AND 
					(SELECT SUM(TRIG_LOG.is_increased) FROM TRIG_LOG
					WHERE TRIG_LOG.contract_id = @contract) != 0)
				BEGIN
					UPDATE CONTRACT SET CONTRACT.salary = CONTRACT.salary / 1.4
					WHERE CONTRACT.contract_id = @contract
					INSERT INTO TRIG_LOG VALUES (@contract, -1, 4, GETDATE()) 
				END
				IF (@level_id1 < 3 AND
					(SELECT COUNT(*) FROM REPORT_MAKERS
					JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id
					JOIN EVENT ON EVENT.event_id = REPORT.event_id
					JOIN DANGER ON EVENT.danger_id = DANGER.danger_id
					WHERE REPORT_MAKERS.contract_id = @contract AND (DANGER.level < 3 OR EVENT.event_id = @event)
					GROUP BY REPORT_MAKERS.contract_id) % 3 = 0 AND 
					(SELECT SUM(TRIG_LOG.is_increased) FROM TRIG_LOG
					WHERE TRIG_LOG.contract_id = @contract) != 0)
				BEGIN
					UPDATE CONTRACT SET CONTRACT.salary = CONTRACT.salary * 1.4
					WHERE CONTRACT.contract_id = @contract
					INSERT INTO TRIG_LOG VALUES (@contract, 1, 4, GETDATE()) 
				END	
				IF (@level_id2 >= 3 AND
					(SELECT COUNT(*) FROM REPORT_MAKERS
					JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id
					JOIN EVENT ON EVENT.event_id = REPORT.event_id
					JOIN DANGER ON DANGER.danger_id = EVENT.danger_id
					WHERE REPORT_MAKERS.contract_id = @contract AND (DANGER.level >= 3 OR EVENT.event_id = @event)
					GROUP BY REPORT_MAKERS.contract_id) % 3 = 0)
				BEGIN
					UPDATE CONTRACT SET CONTRACT.salary = CONTRACT.salary * 1.4
					WHERE CONTRACT.contract_id = @contract
					INSERT INTO TRIG_LOG VALUES (@contract, 1, 4, GETDATE()) 
				END
				IF (@level_id2 < 3 AND
					(SELECT COUNT(*) FROM REPORT_MAKERS
					JOIN REPORT ON REPORT.report_id = REPORT_MAKERS.report_id
					JOIN EVENT ON EVENT.event_id = REPORT.event_id
					JOIN DANGER ON EVENT.danger_id = DANGER.danger_id
					WHERE REPORT_MAKERS.contract_id = @contract AND (DANGER.level < 3 OR EVENT.event_id = @event)
					GROUP BY REPORT_MAKERS.contract_id) % 3 = 0 AND 
					(SELECT SUM(TRIG_LOG.is_increased) FROM TRIG_LOG
					WHERE TRIG_LOG.contract_id = @contract) != 0)
				BEGIN
					UPDATE CONTRACT SET CONTRACT.salary = CONTRACT.salary / 1.4
					WHERE CONTRACT.contract_id = @contract
					INSERT INTO TRIG_LOG VALUES (@contract, -1, 4, GETDATE()) 
				END
				SET @j = @j + 1
				END
			END
	SET @i = @i + 1
	END
END
GO