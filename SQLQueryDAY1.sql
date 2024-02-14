SELECT p.ProductID, p.Name, p.Color, p.ListPrice
FROM Production.Product p

SELECT p.ProductID, p.Name, p.Color, p.ListPrice
FROM Production.Product p
WHERE ListPrice != 0

SELECT p.ProductID, p.Name, p.Color, p.ListPrice
FROM Production.Product p
WHERE Color IS NULL

SELECT p.ProductID, p.Name, p.Color, p.ListPrice
FROM Production.Product p
WHERE Color IS NOT NULL

SELECT p.Name + ' ' + p.Color AS [Name color]
FROM Production.Product p
WHERE Color IS NOT NULL

SELECT TOP 6 p.Name, p.Color
FROM Production.Product p
WHERE Color IS NOT NULL

SELECT p.ProductID, p.Name
FROM Production.Product p
WHERE p.ProductID BETWEEN 400 AND 500;

SELECT p.ProductID, p.Name, p.Color
FROM Production.Product p
WHERE p.Color IN ('black', 'blue')

SELECT p.ProductID, p.Name
FROM Production.Product p
WHERE p.Name LIKE 'S%'

SELECT p.Name, p.ListPrice
FROM Production.Product p
WHERE p.Name LIKE 'S%'
ORDER BY p.Name ASC

SELECT p.Name, p.ListPrice
FROM Production.Product p
WHERE p.Name LIKE 'S%' OR p.Name LIKE 'A%'
ORDER BY p.Name ASC

SELECT p.Name, p.ListPrice
FROM Production.Product p
WHERE p.Name Like 'SPO[^K]%'
ORDER BY p.Name ASC

SELECT DISTINCT p.Color
FROM Production.Product p
ORDER BY p.Color DESC

SELECT DISTINCT p.ProductSubcategoryID, p.Color
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NOT NULL AND p.Color IS NOT NULL