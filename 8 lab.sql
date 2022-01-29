USE TV
GO
--выбрать имена всех таблиц, созданных назначенным пользователем базы данных
SELECT [name] AS 'Таблицы'
FROM sys.sysobjects
WHERE xtype = 'U' 
AND [uid] =
(
	SELECT sysusers.[uid]
	FROM sys.sysusers
	WHERE sysusers.[name] = user_name()
)
AND [name] <> 'sysdiagrams'

--Выбрать имя таблицы, имя столбца таблицы, признак того, допускает ли данный столбец null-значения, 
--название типа данных столбца таблицы, размер этого типа данных 
--для всех таблиц, созданных назначенным пользователем базы данных и всех их столбцов

SELECT tab.[name] AS 'Таблицы', col.[name] AS 'Столбцы', col.isnullable AS 'ISNULLABLE', [type].[name] AS 'Тип', col.[length] AS 'Размер'
FROM sys.sysobjects AS tab
JOIN sys.syscolumns AS col ON col.id = tab.id
JOIN sys.systypes AS [type] ON col.xtype = [type].xtype
WHERE tab.xtype = 'U' 
AND tab.[uid] =
(
	SELECT sysusers.[uid]
	FROM sys.sysusers
	WHERE sysusers.name = user_name()
)
AND tab.name <> 'sysdiagrams'
ORDER BY tab.[name], col.[name]

--Выбрать название ограничения целостности (первичные и внешние ключи), имя таблицы, в которой оно находится
--признак того, что это за ограничение ('PK' для первичного ключа и 'F' для внешнего)
--для всех ограничений целостности, созданных назначенным пользователем базы данных

SELECT keys.[name] AS 'Ограничение', tab.[name] AS 'Таблица', keys.xtype AS 'Признак'
FROM sys.sysobjects AS keys
JOIN sys.sysobjects AS tab ON keys.parent_obj = tab.id AND tab.xtype = 'U'
WHERE keys.xtype IN ('F', 'PK')
AND keys.[uid] = 
(
	SELECT [uid]
	FROM sys.sysusers
	WHERE name = user_name()
) 
AND tab.name <> 'sysdiagrams'

--Выбрать название внешнего ключа, имя таблицы, содержащей внешний ключ, имя таблицы, содержащей его родительский ключ
--для всех внешних ключей, созданных назначенным пользователем базы данных

SELECT obj.[name] AS 'Внешний ключ', fk_from.[name] AS 'Дочерняя таблица', fk_to.[name] AS 'Родительская таблица'
FROM sys.sysreferences AS keys
JOIN sys.sysobjects AS obj ON keys.constid = obj.id
JOIN sys.sysobjects AS fk_from ON keys.fkeyid = fk_from.id
JOIN sys.sysobjects AS fk_to ON keys.rkeyid = fk_to.id
WHERE obj.[uid] =
(
	SELECT [uid]
	FROM sys.sysusers
	WHERE name = user_name()
)

--Выбрать название представления, SQL-запрос, создающий это представление
--для всех представлений, созданных назначенным пользователем базы данных

SELECT [views].[name] AS 'Представление', comments.[text] AS 'Скрипт'
FROM sys.sysobjects AS [views]
JOIN sys.syscomments AS comments ON [views].id = comments.id
WHERE [views].xtype = 'V'
AND [views].[uid] =
(
	SELECT [uid]
	FROM sys.sysusers
	WHERE name = user_name()
)
ORDER BY [views].[name]

--Выбрать название триггера, имя таблицы, для которой определен триггер
--для всех триггеров, созданных назначенным пользователем базы данных

SELECT trig.[name] AS 'Триггер', tab.[name] AS 'Таблица'
FROM sys.sysobjects AS trig
JOIN sys.sysobjects AS tab ON trig.parent_obj = tab.id
WHERE trig.xtype = 'TR'
AND trig.[uid] =
(
	SELECT [uid]
	FROM sys.sysusers
	WHERE name = user_name()
)
