--1.	Crie um novo utilizador chamado "sales_user" 
--com a senha "sales123" 
--e atribua permissão SELECT em todas as tabelas.

create login sales_user with password = 'sales123'

create user sales_user for login sales_user

grant control on database::Banco to sales_user

revoke control on database::Banco to sales_user

grant control server to sales_user

revoke control server to sales_user

SELECT session_id, login_name, host_name, status
FROM sys.dm_exec_sessions
WHERE login_name = 'sales_user'

drop user sales_user

grant control on database::efa57_northwind to sales_user

revoke control on database::efa57_northwind to sales_user

grant select on database::efa57_northwind to sales_user

--2.	Crie um novo utilizador chamado "manager_user" com a senha "manager123" e
--atribua permissões SELECT, INSERT, UPDATE e DELETE na tabela "Products".

create login manager_user with password = 'manager123'

create user manager_user for login manager_user

grant select, insert, update, delete on object::efa57_northwind.dbo.Products to manager_user

--3.	Crie um novo utilizador chamado "employee_user" com a senha " employee123 " 
--e atribua permissões de SELECT na tabela "Customers", mas restrinja de visualizar a coluna 

create login employee_user with password = 'employee123'

create user employee_user for login employee_user

grant select on object::efa57_northwind.dbo.Customers to employee_user

deny create view on database::efa57_northwind to employee_user

deny select on object::efa57_northwind.dbo.Customers (customerid) to employee_user

--4.	Crie um novo utilizador chamado "admin_user" com a senha "admin123" 
--e atribua todos os privilégios em todas as tabelas do base de dados Northwind.

create login admin_user with password = 'admin123'

create user admin_user for login admin_user

grant control on database::efa57_northwind to admin_user

--5.	Revogue a permissão DELETE do "sales_user" na tabela "Orders".

revoke delete on object::efa57_northwind.dbo.orders to sales_user

--6.	Atribua a permissão INSERT ao utilizador "sales_user" na tabela "Orders".

grant insert on object::efa57_northwind.dbo.orders to sales_user

--7.	Negue a permissão ao utilizador "sales_user" para atualizar a coluna "UnitPrice" na tabela "Products".

deny update (unitprice) on object::efa57_northwind.dbo.products to sales_user

--8.	Crie um novo utilizador chamado "report_user" com a senha "report123" e 
--atribua a permissão SELECT em todas as tabelas, exceto na tabela "Employees".

create login report_user with password = 'report123'

create user report_user for login report_user

grant select on database::Efa57_northwind to report_user 

deny select on object::efa57_northwind.dbo.Employees to report_user

--9.	Crie uma regra chamada "shipping_user" e atribua permissão SELECT nas tabelas "Orders" e "Shippers".
--Atribua esta função a um novo utilizador chamado "shipping_user".

create login shipping_user with password = 'shipping123'

create user shipping_user for login shipping_user

create role shipping_user

drop role shipping_user

create role shipping_role

grant select on object::efa57_northwind.dbo.orders to shipping_role

grant select on object::efa57_northwind.dbo.shippers to shipping_role

alter role shipping_role add member shipping_user

--10.	Crie uma regra chamada "manager" e atribua permissão SELECT, INSERT, UPDATE nas tabelas "Employees" 
--e "Orders" aos utilizadores Manager1, Manager2, Manager3.

create login manager_user1 with password = 'manager123'

create user manager1 for login manager_user1

create login manager_user2 with password = 'manager123'

create user manager2 for login manager_user2

create login manager_user3 with password = 'manager123'

create user manager3 for login manager_user3

create role manager_role

grant select, insert, update on object::efa57_northwind.dbo.Employees to manager_role  

grant select, insert, update on object::efa57_northwind.dbo.Orders to manager_role  

alter role manager_role add member manager1
alter role manager_role add member manager2
alter role manager_role add member manager3

--11.	Crie uma regra chamada "sales_rep" e atribua permissões de SELECT, INSERT, UPDATE, DELETE nas tabelas "Customers" e 
--"orders" aos utilizadores SalesRep1, SalesRep2, SalesRep3.

create login SalesRep1 with password = 'salesrep123'

create user SalesRep1 for login SalesRep1

create login SalesRep2 with password = 'salesrep123'

create user SalesRep2 for login SalesRep2

create login SalesRep3 with password = 'salesrep123'

create user SalesRep3 for login SalesRep3

create role sales_rep

drop role sales_rep

create role sales_rep_role

grant select, insert, update, delete on object::efa57_northwind.dbo.Customers to sales_rep_role

grant select, insert, update, delete on object::efa57_northwind.dbo.Orders to sales_rep_role

alter role sales_rep_role add member SalesRep1
alter role sales_rep_role add member SalesRep2
alter role sales_rep_role add member SalesRep3

--12.	Crie uma regra chamada " customer_support " e
--atribua permissões de SELECT na tabela "Customers" aos utilizadores SupportAgent1, SupportAgent2, SupportAgent3.

create role customer_support

grant select on object::efa57_northwind.dbo.Customers to customer_support

create login SupportAgent1 with password = 'support123'

create user SupportAgent1 for login SupportAgent1

create login SupportAgent2 with password = 'support123'

create user SupportAgent2 for login SupportAgent2

create login SupportAgent3 with password = 'support123'

create user SupportAgent3 for login SupportAgent3

alter role customer_support add member SupportAgent1
alter role customer_support add member SupportAgent2
alter role customer_support add member SupportAgent3

--13.	Crie uma regra chamada " inventory_manager " e atribua permissões de SELECT, INSERT, UPDATE, DELETE nas tabelas "Products"
--e "Categories" aos utilizadores InventoryMgr1, InventoryMgr2, InventoryMgr3.

create role inventory_manager_role

grant select, insert, update, delete on object::efa57_northwind.dbo.Products to inventory_manager_role

grant select, insert, update, delete on object::efa57_northwind.dbo.Categories to inventory_manager_role

create login InventoryMgr1 with password = 'inventory123'

create login InventoryMgr2 with password = 'inventory123'

create login InventoryMgr3 with password = 'inventory123'

create user InventoryMgr1 for login InventoryMgr1

create user InventoryMgr2 for login InventoryMgr2

create user InventoryMgr3 for login InventoryMgr3

alter role inventory_manager_role add member InventoryMgr1

alter role inventory_manager_role add member InventoryMgr2

alter role inventory_manager_role add member InventoryMgr3