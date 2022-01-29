USE laba_10
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO

--Без индекса
SELECT companyname, shippeddate, freight
FROM Customers
JOIN Orders ON Orders.customerid = Customers.customerid
WHERE Customers.city = 'Munchen'
	AND Orders.shippeddate BETWEEN '19970101' AND '19971231'
	AND Orders.freight > 200


--С индексом
CREATE CLUSTERED INDEX Customer_clustered ON Customers (CustomerID)
CREATE CLUSTERED INDEX Orders_clustered ON Orders (CustomerID) 

CREATE NONCLUSTERED INDEX Orders_nonclustered ON Orders(shippeddate, freight)
CREATE NONCLUSTERED INDEX Customer_nonclustered ON Customers(city)
INCLUDE(companyname)

SELECT companyname, shippeddate, freight
FROM Customers
JOIN Orders ON Orders.customerid = Customers.customerid
WHERE Customers.city = 'Munchen'
	AND Orders.shippeddate BETWEEN '19970101' AND '19971231'
	AND Orders.freight > 200

DROP INDEX Customer_clustered ON Customers
DROP INDEX Orders_clustered ON Orders
DROP INDEX Orders_nonclustered ON Orders
DROP INDEX Customer_nonclustered ON Customers

--Без индекса:   Время ЦП = 79 мс, затраченное время = 215 мс, число логических чтений = 30328.
--С индексом:    Время ЦП = 31 мс, затраченное время = 148 мс, число логических чтений = 96.
