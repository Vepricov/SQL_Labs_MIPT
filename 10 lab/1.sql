USE laba_10
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO

--Без индекса
SELECT customerid, contactname, phone
FROM Customers
WHERE (City = 'Munchen')
	AND (CustomerID BETWEEN 'A' AND 'Q')

--С индексом
CREATE NONCLUSTERED INDEX Customer_nonclustered ON Customers(city, CustomerID)
INCLUDE(phone, contactname)
GO

SELECT customerid, contactname, phone
FROM Customers
WHERE (City = 'Munchen')
	AND (CustomerID BETWEEN 'A' AND 'Q')
GO

DROP INDEX Customer_nonclustered ON Customers
GO
 
--Без индекса:   Время ЦП = 78 мс, затраченное время = 220 мс, число логических чтений = 30307.
--С индексом:    Время ЦП = 31 мс, затраченное время = 151 мс, число логических чтений = 121.

