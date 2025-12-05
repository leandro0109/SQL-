use EFA57_Northwind

--1.	Criar um trigger para excluir os registos correspondentes da tabela order_details 
--quando um pedido é excluído da tabela orders.

create trigger apagarRegistros
on orders 
after delete
as
begin
	delete 
	from [Order Details]
	where OrderID in (select OrderID from deleted)
end;

--2.	Criar um trigger para impedir a atualização da coluna UnitPrice da tabela de produtos 
--se o novo preço for menor que o preço original.

create trigger impedirAtualizacao
on products
instead of
update
as
begin
	if EXISTS(
	select 1 from inserted as i
	join deleted as d
	on i.ProductID = d.ProductID
	where i.UnitPrice < d.UnitPrice
	)
	begin
		RAISERROR('O preço novo não pode ser inferior ao preço original.', 16, 1);
		return;
	end

	update p
	set unitprice = i.unitprice
	from Products p
	join inserted as i
	on p.ProductID = i.ProductID
end;

--3.	Criar um trigger que impeça que as 'UnitsInStock' de um produto sejam atualizadas para um valor negativo.

create trigger assegurarStock
on products 
instead of update
as
begin

	if EXISTS(select 1 from inserted where UnitsInStock < 0)
	begin
		RAISERROR('As unidades em stock não podem ser negativas!', 16, 1);
		RETURN;
	end

	update p
	set p.UnitsInStock = i.UnitsInStock
	from Products as p
	join inserted as i
	on p.ProductID = i.ProductID
end

CREATE TRIGGER assegurarStockv2
ON Products 
AFTER UPDATE
AS
BEGIN
    IF EXISTS(SELECT 1 FROM inserted WHERE UnitsInStock < 0)
    BEGIN
        RAISERROR('As unidades em stock não podem ser negativas!', 16, 1);
        ROLLBACK TRANSACTION; 
        RETURN;
    END;
END;


--4.	Crie uma trigger que envie uma mensagem ao utilizador 
--quando ele tentar inserir um valor negativo na quantidade (quantity) da tabela order_details.

create trigger mensagemUtilizador
on [order details]
after update
as
begin
	if(select 1 from inserted where Quantity < 0)
	begin
		RAISERROR('A quantidade não pode ser negativa!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
	end
end

CREATE TRIGGER assegurarStockv2
ON Products 
INSTEAD OF UPDATE
AS
BEGIN
    
    -- Atualiza APENAS linhas VÁLIDAS (UnitsInStock >= 0)
    UPDATE p
    SET p.UnitsInStock = i.UnitsInStock
    FROM Products p
    JOIN inserted i ON p.ProductID = i.ProductID
    WHERE i.UnitsInStock >= 0;
    
    -- Avisa sobre linhas rejeitadas
    IF EXISTS(SELECT 1 FROM inserted WHERE UnitsInStock < 0)
    BEGIN
        DECLARE @InvalidCount INT = (SELECT COUNT(*) FROM inserted WHERE UnitsInStock < 0);
        RAISERROR('Rejeitadas %d linhas com stock negativo.', 10, 1, @InvalidCount);
    END;
END;

--5.	Criar um trigger que registe numa tabela de logs as informações relacionadas 
--com a alteração de dados na tabela de produtos. A nova tabela deverá guardar
--a seguinte informação: idProduto, Operação (Insert, Update, Delete), Nome Antigo, Nome Novo,
--Preço Antigo, Preço Novo, Data Alteração, Nome do utilizador que alterou.

CREATE TABLE ProductLogs (
    	LogID INT IDENTITY(1,1) PRIMARY KEY,
    	ProductID INT,
    	Operation VARCHAR(50),
   		OldProductName VARCHAR(50),
    	NewProductName VARCHAR(50),
    	OldUnitPrice DECIMAL(18, 2),
    	NewUnitPrice DECIMAL(18, 2),
    	ChangeDate DATETIME DEFAULT GETDATE(),
		UserName VARCHAR(50));

create trigger logs
on Products
after insert, update, delete
as
begin
	IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted) 
    begin
		insert into ProductLogs(ProductID, Operation, OldProductName, NewProductName,
		OldUnitPrice, NewUnitPrice, ChangeDate,UserName)
		select
			ProductID,
			'INSERT',
			NULL,
			ProductName,
			NULL,
			UnitPrice,
			CURRENT_TIMESTAMP,
			SUSER_SNAME()
		from inserted
	end
	ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
	begin
		insert into ProductLogs(ProductID, Operation, OldProductName, NewProductName,
		OldUnitPrice, NewUnitPrice, ChangeDate,UserName) 
		select 
			productid,
			'DELETE',
			ProductName,
			NULL,
			UnitPrice,
			NULL,
			CURRENT_TIMESTAMP,
			SUSER_SNAME()
		from deleted
	end
	ELSE 
	begin
    INSERT INTO ProductLogs (ProductID, Operation, OldProductName, NewProductName, OldUnitPrice, NewUnitPrice, ChangeDate, UserName)
        SELECT 
            i.ProductID,
            'UPDATE',
            d.ProductName,
            i.ProductName,
            d.UnitPrice,
            i.UnitPrice,
            CURRENT_TIMESTAMP,
            SUSER_SNAME()
        FROM inserted i, deleted d
	end
end
