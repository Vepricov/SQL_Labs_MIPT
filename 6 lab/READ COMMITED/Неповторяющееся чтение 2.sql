﻿use TV
--Неповторяющееся чтение READ COMMITTED(2)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION
UPDATE [EVENT]
SET danger_id = 2
WHERE [EVENT].event_id = 4
COMMIT