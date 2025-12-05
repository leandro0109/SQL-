select d.name, d.create_date, d.type
from sys.database_principals as d
where type = 's' and authentication_type = 1

create login leandro2 with password = '1234'

alter login leandro2 with password = '123456'

drop login leandro2

SELECT session_id, login_name, host_name, status
FROM sys.dm_exec_sessions
WHERE login_name = 'leandro2'

kill 73

drop login leandro2

grant privilegio on objeto to utilizador [with grant option]

grant control server to leandro2

revoke control server to leandro2

grant view any database to leandro2

revoke view any database to leandro2

grant control server to leandro2

revoke control server to leandro2

grant control on database::efa57_northwind to leandro2

grant create any database to leandro2

grant alter on database::efa57_northwind to leandro2

