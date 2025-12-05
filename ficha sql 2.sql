use EFA57_Northwind

select CompanyName,
(select avg(unitprice)
from Products as p
where p.SupplierID = s.SupplierID) as total
from Suppliers as s

select categoryname,
(select top 1 p.ProductName
from Products as p
join [Order Details] as od
on p.ProductID = od.ProductID
where p.CategoryID = c.CategoryID
group by p.ProductName
order by sum(od.Quantity) desc) as produto
from Categories as c

select od.UnitPrice, od.OrderID, od.ProductID, p.ProductName, o.ShipAddress
from [Order Details] as od
join Products as p
on od.ProductID = p.ProductID
join Orders as o
on o.OrderID = od.OrderID
where od.UnitPrice =
(select max(unitprice)
from [Order Details])

select o.OrderID, o.CustomerID, e.City, e.FirstName
from Orders as o
join Employees as e
on o.EmployeeID = e.EmployeeID
where e.EmployeeID in
(select EmployeeID
from Employees
where City in ('tacoma', 'seattle'))

select totalVendas.subq 
from
(select p.ProductID, p.ProductName, od.UnitPrice, od.Quantity, sum(od.Quantity*od.UnitPrice) as totalVendas
from Products as p
join [Order Details] as od
on p.ProductID = od.ProductID
group by p.ProductID, p.ProductName, od.UnitPrice, od.Quantity) as subq 
order by totalVendas desc

select totalVendas.ProductID, p.ProductName, totalVendas.total
from products as p
join
(select od.ProductID, sum(od.quantity*od.unitprice) as total
from [Order Details] as od
group by od.ProductID) as totalVendas
on p.ProductID=totalVendas.ProductID
order by totalVendas.total

