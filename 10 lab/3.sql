USE laba_10
SET STATISTICS IO ON
SET STATISTICS TIME ON

--Без индекса

SELECT Customers.CustomerID, EmployeeID, City, Products.ProductID, Products.UnitsInStock, OrderDetails.Discount
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE EmployeeID = 1 AND
	  City = 'London' AND
	  OrderDetails.Discount = 0 AND
	  Products.UnitsInStock < 20
--С индексом

CREATE CLUSTERED INDEX Clast_Customers ON Customers(CustomerID)
CREATE CLUSTERED INDEX Clast_Orders ON Orders(CustomerID, OrderID)
CREATE CLUSTERED INDEX Clast_Products ON Products (ProductID)
CREATE CLUSTERED INDEX Clast_OrderDetails ON OrderDetails (OrderID, ProductID)

CREATE NONCLUSTERED INDEX Non_Customers ON Customers(City)
CREATE NONCLUSTERED INDEX Non_Orders ON Orders(EmployeeID)
CREATE NONCLUSTERED INDEX Non_Products ON Products (UnitsInStock)
CREATE NONCLUSTERED INDEX Non_OrderDetails ON OrderDetails (Discount)


SELECT Customers.CustomerID, EmployeeID, City, Products.ProductID, Products.UnitsInStock, OrderDetails.Discount
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE EmployeeID = 1 AND
	  City = 'London' AND
	  OrderDetails.Discount = 0 AND
	  Products.UnitsInStock < 20

DROP INDEX Clast_Customers ON Customers
DROP INDEX Clast_Orders ON Orders
DROP INDEX Clast_Products ON Products
DROP INDEX Clast_OrderDetails ON OrderDetails

DROP INDEX Non_Customers ON Customers
DROP INDEX Non_Orders ON Orders
DROP INDEX Non_Products ON Products
DROP INDEX Non_OrderDetails ON OrderDetails

--Без индекса:    Время ЦП = 156 мс, затраченное время = 789 мс, число логических чтений = 40606.
--С индексом:     Время ЦП = 31 мс, затраченное время = 516 мс, число логических чтений = 1490.