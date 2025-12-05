select o.OrderID as NúmeroOrdem, c.CustomerID as CódigoCliente, c.ContactName as NomeCliente, o.OrderDate as Data
from Orders as o
join Customers as c
on o.CustomerID = c.CustomerID
where o.OrderDate = (select max(OrderDate) from Orders)

select distinct ProductName, ProductID
from Products
where ProductID not in
(select distinct od.ProductID
  from [Order Details] as od
  join Orders as o
    on od.OrderID = o.OrderID
  where YEAR(o.OrderDate) = 1998)
order by ProductName 

select distinct c.CustomerID, c.ContactName as Nome, c.CompanyName, c.Country
from Customers as c
join Orders as o
on c.CustomerID = o.CustomerID
where c.CustomerID not in 
(select distinct c.CustomerID
from Customers as c
join Orders as o
on c.CustomerID = o.CustomerID
where YEAR(o.OrderDate) = 1997)
order by c.ContactName

select c.ContactName
from Customers as c
where c.CustomerID not in
(select c.CustomerID
from Customers as c
join Orders as o
on c.CustomerID = o.CustomerID
where o.OrderDate > '01-01-1995')
order by c.ContactName

select e.EmployeeID ,concat(e.FirstName,' ', e.LastName) as funcionario, count(o.OrderID) as pedidos
from Employees as e
join Orders as o
on e.EmployeeID = o.EmployeeID
group by e.EmployeeID ,e.FirstName, e.LastName
order by e.FirstName, count(o.OrderID)

select p.ProductName, p.UnitPrice
from Products as p
where p.UnitPrice >
(select distinct avg(UnitPrice)
from Products)
order by p.ProductName, p.UnitPrice

select e.EmployeeID, concat(e.FirstName, ' ', e.LastName) as Nome, o.OrderDate
from Employees as e
join Orders as o
on e.EmployeeID = o.EmployeeID
where o.OrderDate = 
(select max(OrderDate)
from Orders)

select concat(e.FirstName, ' ', e.LastName) as Nome,  count(o.OrderID) as pedidos
from Orders as o
join Employees as e
on o.EmployeeID = e.EmployeeID
group by e.FirstName, e.LastName
order by e.FirstName, e.LastName, count(o.OrderID)

select p.ProductID, p.ProductName, p.UnitPrice
from Products as p 
where p.UnitPrice >
(select avg(subq.UnitPrice)
from
(select distinct od.ProductID, p.UnitPrice 
from Products as p
join [Order Details] as od
on p.ProductID = od.ProductID
where od.ProductID is not null) as subq)
order by p.ProductName


select e.EmployeeID, count(o.OrderID) as orders
from Orders as o
join Employees as e
on o.EmployeeID = e.EmployeeID
group by e.EmployeeID
having count(o.OrderID) > 100







