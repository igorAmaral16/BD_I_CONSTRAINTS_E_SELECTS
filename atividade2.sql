create database projeto
go
use projeto
go
create table users(
id int identity(1,1) not null,
name varchar(45) not null,
username varchar(45) not null,
password varchar(45) default('123mudar') not null,
email varchar(45) not null
primary key (id)
)
go
create table projects(
id int identity (10001,1) not null,
name varchar(45) not null,
description varchar(45) not null,
data date not null
primary key(id)
)
go
create table users_has_projects(
users_id int not null,
projects_id int not null,
primary key (users_id, projects_id),
foreign key (users_id) references users(id),
foreign key (projects_id) references projects(id)
)
go
alter table projects add check (data > '01/09/2014')
go
alter table users alter column username varchar(10) not null
go
alter table users add constraint ak_username unique(username)
go
alter table users alter column password varchar(8) not null
go
dbcc checkident('users', reseed, 1)
go
insert into users (name, username, email) values
('Maria','Rh_Maria', 'maria@empresa.com'),
('Paulo', 'Ti_paulo', 'paulo@empresa.com'),
('Ana', 'Rh_Ana', 'ana@empresa.com'),
('Clara', 'Ti_clara', 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', 'aparecido@empresa.com')
go
update users set password = '123@456' where id = 2
go
update users set password = '55@!cido' where id = 5
go
alter table projects alter column description varchar(45) null
go
insert into projects (name, description, data) values
('Re-folha', 'Refatora��o das Folhas', '05/09/2014'),
('Manuten��o PC�s', 'Manuten��o PC�s', '06/09/2014'),
('Auditoria', NULL, '07/09/2014')
go
insert into users_has_projects values
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)
go
update projects set data = '12/09/2014' where name like 'manuten��o'
go
update users set username = 'Rh_cido' where name = 'aparecido'
go
update users set password = '888@*' where username = 'Rh_maria' and password = '123mudar'
go
delete users_has_projects where users_id = 2
go
select * from users_has_projects

----------------------------------------ATIVIDADE 2----------------------------

SELECT id, name, email, username, 
	CASE WHEN password = '123mudar' THEN
		password
	ELSE
		'********'
	END AS password
FROM users

SELECT name, data from projects
SELECT name, description, DATEADD(DAY, 15, data) AS data_final 
FROM projects WHERE id IN (
	SELECT projects_id FROM users_has_projects WHERE users_id IN(
		SELECT id FROM users WHERE email = 'aparecido@empresa.com'
	)
)

SELECT name, email FROM users WHERE id IN (
	SELECT users_id FROM users_has_projects WHERE projects_id IN(
		SELECT id FROM projects WHERE name = 'Auditoria'
	)
)

SELECT name, description, 
	CONVERT(CHAR(10), data, 103) AS data_inicial, 
	CONVERT(CHAR(10), '2014-09-16', 103) AS data_final,
	DATEDIFF(DAY, data, '2014-09-16') * 79.85 AS custo_total
	FROM projects WHERE name LIKE '%manuten��o%'


SELECT DISTINCT us.id, 
       us.name, 
	   us.email,
       prj.id, 
	   prj.name AS project_name, 
	   prj.description, 
	   prj.data
FROM users us, users_has_projects uhp, projects prj
WHERE us.id = uhp.users_id
      AND prj.name LIKE 'Re-folha%'

SELECT DISTINCT prj.name
FROM projects prj LEFT OUTER JOIN users_has_projects uhp
ON prj.id = uhp.projects_id
WHERE  uhp.users_id IS NULL

SELECT us.name
FROM users us LEFT OUTER JOIN users_has_projects uhp
ON us.id = uhp.users_id
WHERE uhp.projects_id IS NULL