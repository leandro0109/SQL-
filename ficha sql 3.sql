select total.CustomerID, c.CompanyName, total.media
from customers as c
left join
(select o.CustomerID, avg(od.quantity) as media
from Orders as o
join [Order Details] as od
on o.OrderID = od.OrderID
group by o.CustomerID) as total
on c.CustomerID = total.CustomerID

select distinct produtos.ContactName, produtos.ProductName, od.ProductID
from [Order Details] as od
join
(select s.ContactName, p.ProductName, p.ProductID
from Suppliers as s
join Products as p
on s.SupplierID = p.SupplierID
where s.SupplierID = 2) as produtos
on od.ProductID = produtos.ProductID
where od.Discount = 0

select c.CategoryName, avg(p.UnitPrice) as media
from Categories as c
join Products as p
on c.CategoryID = p.CategoryID
group by c.CategoryName
having avg(p.UnitPrice) >
(select avg(UnitPrice)
from Products) as mediaProdutos 


