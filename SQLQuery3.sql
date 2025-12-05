use EFA57_Northwind

--1.	Criar um trigger para evitar a exclusão de um registo de cliente da tabela de clientes 
--se houver pedidos associados.

create trigger verificarPedidosCliente
on Customers
instead of
delete
as
begin
	if EXISTS(
	select 1 from deleted as d
	join Orders as o
	on d.customerid = o.CustomerID)

	BEGIN
        RAISERROR('Não é permitido eliminar clientes com pedidos associados.', 16, 1);
        RETURN;
    END;

	delete c
	from Customers as c
	join deleted as d
	on c.CustomerID = d.CustomerID
end

--2.	Criar um trigger que insere automaticamente um novo registo na tabela orders 
--quando um novo cliente é adicionado à tabela customersas

create trigger ex2trigger
on customers 
after 
insert 
as
begin
	insert into Orders(CustomerID) 
	select CustomerID from inserted
end

EXEC sp_help 'Orders';

insert into Customers (CustomerID, CompanyName)
values
(9999, 'teste')

insert into Customers (CustomerID, CompanyName)
values
('teste', 'teste')

alter table orders
add UpdateDate datetime default null

--3.	Criar um trigger que atualize a coluna 'OrderDate' na tabela 'orders' quando
--um novo detalhe do pedido for adicionado.

create trigger ex3trigger
on orders
after update
as
begin
	update Orders
	set UpdateDate = CURRENT_TIMESTAMP
	from Orders as o
	join inserted as i
	on o.OrderID = i.OrderID
end

update Orders
set ShipCountry = 'teste'
from Orders
where OrderID = 10248

--4.	Crie uma trigger que preencha a coluna de descontos da tabela order details, 
--da seguinte maneira: se o unityprice*quantity for maior que 1000,
--coloque um desconto de 10%, se estiver entre 500 e 1000, coloque um desconto de 5%.

CREATE TRIGGER trg_UpdateDiscounts
ON [Order Details]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE od
    SET Discount = CASE 
                      WHEN i.UnitPrice * i.Quantity > 1000 THEN 0.10
                      WHEN i.UnitPrice * i.Quantity BETWEEN 500 AND 1000 THEN 0.05
                      ELSE 0
                   END
    FROM [Order Details] od
    JOIN inserted i ON od.orderid = i.orderid;
END;
GO
