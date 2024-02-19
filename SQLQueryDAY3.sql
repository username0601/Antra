-- 1.      List all cities that have both Employees and Customers.
SELECT DISTINCT e.City
FROM dbo.Employees e
INNER JOIN dbo.Customers c 
ON c.City = e.City

-- 2.      List all cities that have Customers but no Employee.
-- a.      Use sub-query
SELECT DISTINCT c.City
FROM dbo.Customers c 
WHERE c.City NOT IN (
    SELECT e.City
    FROM dbo.Employees e
)

-- b.      Do not use sub-query
SELECT DISTINCT c.City
FROM dbo.Customers c
LEFT JOIN dbo.Employees e 
ON c.City = e.City
WHERE e.City IS NULL

-- 3.      List all products and their total order quantities throughout all orders.
SELECT p.ProductName, COUNT(od.OrderID) AS [Order quantities]
FROM dbo.Products p
INNER JOIN dbo.[Order Details] od 
ON p.ProductID = od.ProductID
GROUP BY p.ProductName

-- 4.      List all Customer Cities and total products ordered by that city.
SELECT c.City, SUM(od.Quantity) AS [Total products]
FROM dbo.Customers c
INNER JOIN dbo.Orders o 
ON c.CustomerID = o.CustomerID 
INNER JOIN dbo.[Order Details] od 
ON od.OrderID = o.OrderID
GROUP BY c.City

-- 5.      List all Customer Cities that have at least two customers.
-- a.      Use union
SELECT c.City
FROM dbo.Customers c
GROUP BY c.City
HAVING COUNT(c.City) > 1
UNION 
SELECT c.City
FROM dbo.Customers c
GROUP BY c.City
HAVING COUNT(c.City) > 1

-- b.      Use sub-query and no union
SELECT DISTINCT c.City
FROM dbo.Customers c
WHERE c.City IN (
    SELECT c.City
    FROM dbo.Customers c
    GROUP BY c.City
    HAVING COUNT(c.City) > 1
)

-- 6.      List all Customer Cities that have ordered at least two different kinds of products.
SELECT DISTINCT c.City
FROM dbo.Customers c
INNER JOIN dbo.Orders o 
ON c.CustomerID = o.CustomerID
INNER JOIN dbo.[Order Details] od 
ON od.OrderID = o.OrderID
GROUP BY c.City, o.OrderID
HAVING COUNT(DISTINCT od.ProductID) > 1

-- 7.      List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT c.ContactName
FROM dbo.Customers c
INNER JOIN dbo.Orders o 
ON c.CustomerID = o.CustomerID
WHERE o.ShipCity != c.City

-- 8.      List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

-- 9.      List all cities that have never ordered something but we have employees there.
-- a.      Use sub-query
SELECT DISTINCT e.City
FROM dbo.Employees e
WHERE e.City NOT IN (
    SELECT c.City
    FROM dbo.Customers c
    INNER JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
)

-- b.      Do not use sub-query
SELECT DISTINCT e.City
FROM dbo.Employees e 
LEFT JOIN dbo.Customers c ON e.City = c.city 
LEFT JOIN dbo.Orders o ON c.CustomerID = o.CustomerID 
WHERE c.CustomerID IS NULL

-- 10.  List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
-- and also the city of most total quantity of products ordered from. (tip: join  sub-query)
WITH odeCTE AS(
    SELECT e.City AS odC, COUNT(o.OrderID) ct0, RANK() OVER(ORDER BY COUNT(o.OrderID) DESC) rk0
    FROM dbo.Orders o 
    INNER JOIN dbo.Employees e  
    ON o.EmployeeID = e.EmployeeID
    GROUP BY e.City
),
odeCTE1 AS(
    SELECT c.City AS odC1, SUM(od.Quantity) ct1, RANK() OVER(ORDER BY SUM(od.Quantity) DESC) rk1
    FROM dbo.Orders o 
    INNER JOIN dbo.Customers c
    ON o.CustomerID = c.CustomerID
    INNER JOIN dbo.[Order Details] od  
    ON od.OrderID = o.OrderID
    GROUP BY c.City
)
SELECT odeCTE.odC
FROM odeCTE
WHERE odeCTE.rk0 = 1
UNION 
SELECT odeCTE1.odC1
FROM odeCTE1
WHERE odeCTE1.rk1 = 1

-- 11. How do you remove the duplicates record of a table?
-- use group by to separte rows from difference column value, then use COUNT() to count the row number, 
-- at last use WHERE row number greated than 2
