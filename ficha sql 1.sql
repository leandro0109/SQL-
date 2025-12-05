select c.ContactName as clientes, count(*) as pedidos
from Customers as c
join Orders as o 
on c.CustomerID = o.CustomerID
group by c.ContactName

select c.ContactName as nomes, avg(od.Quantity) as MediaProdutos
from Customers as c
join Orders as o
on c.CustomerID = o.CustomerID
join [Order Details] as od
on o.OrderID = od.OrderID
group by c.ContactName
order by c.ContactName asc

select e.LastName as apelido, sum(od.UnitPrice*od.Quantity - (od.UnitPrice*od.Discount)) as receitaTotal
from Employees as e
join Orders as o
on e.EmployeeID = o.EmployeeID
join [Order Details] as od
on o.OrderID = od.OrderID
group by e.LastName
order by e.LastName

select ShipCountry as pais, count(*) as pedidos
from Orders
group by ShipCountry
order by ShipCountry asc

select c.ContactName as clientes, avg(od.UnitPrice*od.Quantity) as mediaPedidos
from Customers as c
join Orders as o
on c.CustomerID = o.CustomerID
join [Order Details] as od
on o.OrderID = od.OrderID
where c.Country = 'Portugal'
group by c.ContactName
having avg(od.UnitPrice*od.Quantity) > 200
order by c.ContactName

select p.ProductName as produtos, p.UnitsInStock as emStock, count(*) as pedidos
from Products as p
join [Order Details] as od
on p.ProductID = od.ProductID
where p.UnitsInStock < 10 
group by p.ProductName, p.UnitsInStock
having count(*) >= 3
order by p.UnitsInStock

select e.FirstName as empregados, year(o.OrderDate) as ano, count(o.OrderID) as pedidos
from Employees as e
join Orders as o
on e.EmployeeID = o.EmployeeID
join [Order Details] as od
on o.OrderID = od.OrderID
where YEAR(o.OrderDate) = 1996
group by e.FirstName, year(o.OrderDate)
having count(o.OrderID) >= 5 and sum(od.Quantity*od.UnitPrice) > 20000
order by e.FirstName asc

select s.CompanyName as remetente, o.OrderID as orderid, o.OrderDate as orderdate
from Orders as o
join Shippers as s
on o.ShipVia = s.ShipperID
where o.OrderID < 10300
order by o.OrderID