-- 1.      How many products can you find in the Production.Product table?
SELECT COUNT(p.ProductID)
FROM Production.Product p

-- 2.      Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(p.ProductID)
FROM Production.Product p
WHERE ProductSubcategoryID IS NOT NULL

-- 3.      How many Products reside in each SubCategory? Write a query to display the results with the following titles.
-- ProductSubcategoryID CountedProducts
SELECT p.ProductSubcategoryID, COUNT(p.ProductID) AS CountedProducts
FROM Production.Product p
GROUP BY p.ProductSubcategoryID

-- 4.      How many products that do not have a product subcategory.
SELECT COUNT(p.ProductID)
FROM Production.Product p
WHERE ProductSubcategoryID IS NULL

-- 5.      Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(p.Quantity) AS TheSum
FROM Production.ProductInventory p

-- 6.    Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
--               ProductID    TheSum
SELECT p.ProductID, SUM(p.Quantity) AS TheSum
FROM Production.ProductInventory p
WHERE p.LocationID = 40
GROUP BY p.ProductID
HAVING SUM(p.Quantity) < 100

-- 7.    Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
--     Shelf      ProductID    TheSum
SELECT p.Shelf, p.ProductID, SUM(p.Quantity) AS TheSum
FROM Production.ProductInventory p
WHERE p.LocationID = 40
GROUP BY p.Shelf, p.ProductID
HAVING SUM(p.Quantity) < 100

-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
WHERE p.LocationID = 10

-- 9.    Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
--     ProductID   Shelf      TheAvg
SELECT p.ProductID, p.Shelf, AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
GROUP BY p.ProductID, p.Shelf

-- 10.  Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
--     ProductID   Shelf      TheAvg
SELECT p.ProductID, p.Shelf, AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
WHERE p.Shelf != 'N/A'
GROUP BY p.ProductID, p.Shelf

-- 11.  List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
--     Color                        Class              TheCount          AvgPrice
SELECT p.Color, p.Class, COUNT(p.ProductID) AS TheCount, AVG(p.ListPrice) AS AvgPrice
FROM Production.Product p
WHERE p.Color IS NOT NULL AND p.Class IS NOT NULL
GROUP BY p.Color, p.Class

-- Joins:

-- 12.   Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
--     Country                        Province
SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c 
INNER JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode

-- 13.  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
 
--     Country                        Province
SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c 
INNER JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany', 'Canada')

--  Using Northwnd Database: (Use aliases for all the Joins)

-- 14.  List all Products that has been sold at least once in last 26 years.
SELECT DISTINCT p.ProductName, p.ProductID
FROM dbo.Products p
INNER JOIN dbo.[Order Details] od ON od.ProductID = p.ProductID
INNER JOIN dbo.Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDate >= DATEADD(year, -26, GETDATE());

-- 15.  List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) AS TotalProductsSold
FROM dbo.Orders o
INNER JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.ShipPostalCode
ORDER BY COUNT(*) DESC

-- 16.  List top 5 locations (Zip Code) where the products sold most in last 26 years.
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) AS TotalProductsSold
FROM dbo.Orders o
INNER JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= DATEADD(year, -26, GETDATE())
GROUP BY o.ShipPostalCode
ORDER BY COUNT(*) DESC

-- 17.   List all city names and number of customers in that city.     
SELECT o.ShipCity, COUNT(c.CustomerID) AS CustomerNum
FROM dbo.Orders o
INNER JOIN dbo.Customers c 
ON o.ShipCity = c.City
GROUP BY o.ShipCity

-- 18.  List city names which have more than 2 customers, and number of customers in that city
SELECT o.ShipCity, COUNT(c.CustomerID) AS CustomerNum
FROM dbo.Orders o
INNER JOIN dbo.Customers c 
ON o.ShipCity = c.City
GROUP BY o.ShipCity
HAVING COUNT(c.CustomerID) > 2

-- 19.  List the names of customers who placed orders after 1/1/98 with order date.
SELECT DISTINCT c.ContactName
FROM dbo.Customers c
INNER JOIN dbo.Orders o ON o.CustomerID = c.CustomerID 
WHERE o.OrderDate > '1998-01-01';

-- 20.  List the names of all customers with most recent order dates
SELECT c.ContactName, LatestOrder.Latest
FROM dbo.Customers c 
INNER JOIN (
    SELECT o.CustomerID, MAX(o.OrderDate) AS Latest
    FROM dbo.Orders o
    GROUP BY o.CustomerID
) LatestOrder
ON c.CustomerID = LatestOrder.CustomerID

-- 21.  Display the names of all customers  along with the count of products they bought
SELECT c.ContactName, AllOrders.SumP
FROM dbo.Customers c 
LEFT JOIN (
    SELECT o.CustomerID, COUNT(od.OrderID) AS SumP
    FROM dbo.Orders o
    INNER JOIN
    dbo.[Order Details] od 
    ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
) AllOrders
ON c.CustomerID = AllOrders.CustomerID

-- 22.  Display the customer ids who bought more than 100 Products with count of products.
SELECT c.ContactName, AllOrders.SumP
FROM dbo.Customers c 
LEFT JOIN (
    SELECT o.CustomerID, COUNT(od.OrderID) AS SumP
    FROM dbo.Orders o
    INNER JOIN
    dbo.[Order Details] od 
    ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
) AllOrders
ON c.CustomerID = AllOrders.CustomerID
WHERE AllOrders.SumP > 100

-- 23.  List all of the possible ways that suppliers can ship their products. Display the results as below
--     Supplier Company Name                Shipping Company Name
SELECT s.CompanyName AS [Supplier Company Name], sp.CompanyName AS [Shipping Company Name]
FROM dbo.Suppliers s
CROSS JOIN dbo.Shippers sp

-- 24.  Display the products order each day. Show Order date and Product Name.
SELECT p.ProductName, pID.OrderDate
FROM dbo.Products p
INNER JOIN (
    SELECT od.ProductID, o.OrderDate
    FROM dbo.Orders o 
    INNER JOIN 
    dbo.[Order Details] od 
    ON o.OrderID = od.OrderID
) pID 
ON p.ProductID = pID.ProductID

-- 25.  Displays pairs of employees who have the same job title.
SELECT e1.EmployeeID AS EmployeeID1, e1.Title AS JobTitle,
       e2.EmployeeID AS EmployeeID2, e2.Title AS JobTitle
FROM Employees e1
INNER JOIN Employees e2 ON e1.Title = e2.Title
WHERE e1.EmployeeID < e2.EmployeeID;

-- 26.  Display all the Managers who have more than 2 employees reporting to them.
WITH EmpHierarchyCTE
AS(
    SELECT EmployeeId, FirstName, ReportsTo, 1 lvl
    FROM Employees
    WHERE ReportsTo IS NULL
    UNION ALL
    SELECT e.EmployeeId, e.FirstName, e.ReportsTo, cte.lvl + 1
    FROM Employees e INNER JOIN EmpHierarchyCTE cte ON e.ReportsTo = cte.EmployeeId
)

SELECT EmpHierarchyCTE.EmployeeId, EmpHierarchyCTE.FirstName FROM EmpHierarchyCTE
INNER JOIN (
    SELECT EmpHierarchyCTE.ReportsTo, COUNT(EmpHierarchyCTE.EmployeeID) AS numE
    FROM EmpHierarchyCTE
    GROUP BY EmpHierarchyCTE.ReportsTo
) eCTE 
ON EmpHierarchyCTE.EmployeeID = eCTE.ReportsTo
WHERE eCTE.numE > 2

-- 27.  Display the customers and suppliers by city. The results should have the following columns
-- City -- Name -- Contact Name -- Type (Customer or Supplier)
SELECT DISTINCT c.City, c.CompanyName, c.ContactName, 'Customer' AS Type
FROM Customers c
UNION ALL
SELECT DISTINCT s.City, s.CompanyName, s.ContactName, 'Supplier' AS Type
FROM Suppliers s;
