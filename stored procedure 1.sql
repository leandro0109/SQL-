create procedure produtosClienteAno
	@ano int,
	@cliente char(5) 
as
begin
	select sum(od.Quantity)
	from [Order Details] as od
	join Orders as o
	on od.OrderID = o.OrderID
	where YEAR(o.OrderDate) = @ano and o.CustomerID = @cliente;
end

exec produtosClienteAno @ano = 1997, @cliente = 'alfki' 