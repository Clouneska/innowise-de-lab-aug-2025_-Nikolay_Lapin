-- Удаление таблиц
DROP TABLE IF EXISTS EmployeeProjects;
DROP TABLE IF EXISTS Projects;
DROP VIEW IF EXISTS IT_Department_View;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departmens;
DROP ROLE IF EXISTS hr_user;

CREATE TABLE Employees (
EmployeeID SERIAL PRIMARY KEY, -- SERIAL for auto-incrementing integer IDs in PostgreSQL
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Department VARCHAR(50),
Salary DECIMAL(10, 2)
);
CREATE TABLE Projects (
ProjectID SERIAL PRIMARY KEY, -- SERIAL for auto-incrementing integer IDs
ProjectName VARCHAR(100) NOT NULL,
Budget DECIMAL(12, 2),
StartDate DATE,
EndDate DATE
);
CREATE TABLE EmployeeProjects (
EmployeeID INT,
ProjectID INT,
HoursWorked INT,
PRIMARY KEY (EmployeeID, ProjectID),
FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);
INSERT INTO Employees (FirstName, LastName, Department, Salary) VALUES
('Alice', 'Smith', 'HR', 60000.00),
('Bob', 'Johnson', 'IT', 75000.00),
('Charlie', 'Brown', 'Finance', 62000.00),
('Diana', 'Prince', 'IT', 80000.00),
('Eve', 'Davis', 'HR', 58000.00);
INSERT INTO Projects (ProjectName, Budget, StartDate, EndDate) VALUES
('Website Redesign', 150000.00, '2023-01-15', '2023-06-30'),
('Mobile App Development', 200000.00, '2023-03-01', '2023-10-31'),
('Internal Tools Upgrade', 80000.00, '2023-05-10', '2023-09-15');
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked) VALUES
(2, 1, 160), -- Bob Johnson (ID 2) on Website Redesign (ID 1)
(4, 1, 120), -- Diana Prince (ID 4) on Website Redesign (ID 1)
(2, 2, 200), -- Bob Johnson (ID 2) on Mobile App Development (ID 2)
(1, 3, 80), -- Alice Smith (ID 1) on Internal Tools Upgrade (ID 3)
(3, 3, 100); -- Charlie Brown (ID 3) on Internal Tools Upgrade (ID 3)

--1 Задание
delete from EmployeeProjects
where EmployeeID = 4;

delete from Employees
where EmployeeID = 4;

-- Вставка новых сотрудников
insert into Employees (FirstName, LastName, Department, Salary) values
('Nikita', 'Millerk', 'Finance', 67000.00),
('Nikola', 'Lemp', 'IT', 72000.00);

-- Выборка всех сотрудников
select * from Employees;

-- Выборка сотрудников из отдела IT
select FirstName, LastName from Employees
where Department = 'IT';

-- Обновление зарплаты Alice Smith
update Employees
set Salary = 65000.00
where FirstName = 'Alice' and LastName = 'Smith';

-- Удаление сотрудника с фамилией Prince
delete from Employees
where LastName = 'Prince';

-- Финальная проверка
select * from Employees;


--2 Задание
-- Создание таблицы Departmens
create table Departmens(
	DepartmensID serial	primary key,
	DepartmensName VARCHAR(50) unique not null, 
	location VARCHAR(50)
);

--Добавление email для каждого сотрудника
 alter table employees 
 add column Email VARCHAR(80);
 
	update Employees set Email = 'alice.smith@example.com' where FirstName = 'Alice' and LastName = 'Smith';
	update Employees set Email = 'bob.johnson@example.com' where FirstName = 'Bob' and LastName = 'Johnson';
	update Employees set Email = 'charlie.brown@example.com' where FirstName = 'Charlie' and LastName = 'Brown';
	update Employees set Email = 'eve.davis@example.com' where FirstName = 'Eve' and LastName = 'Davis';
	update Employees set Email = 'nikita.millerk@example.com' where firstname  = 'Nikita' and lastname  = 'Millerk';
	update Employees set Email = 'nikola.lemp@example.com' where FirstName = 'Nikola' and lastname  = 'Lemp';

alter table Employees
add constraint unique_email unique (Email);

alter table Departmens
rename column location to OfficeLocation;

--Проверка таблицы DEpartmens(пусто,т.к не заполнял ее)
select *from Departmens;

--3 Задание
-- создание роли hr_user и добавление пароля
create role hr_user with LOGIN password '1234';
--просмотр данных таблиц для hr_user
grant select on table Employees to hr_user;

select *from Employees;
--создание test user для проверки 
insert into Employees (firstname,Lastname, Department, Salary)
values ('Test','User','HR', 60000.0);

grant insert , update on table  Employees to hr_user;

insert into Employees (FirstName, LastName, Department, Salary )
values ('Test', 'User', 'HR', 60000.00);

update Employees 
set Salary = 61500.00
where FirstName = 'Test' and LastName = 'User';

--4 Задание
delete from Employees
where FirstName = 'Test' and LastName = 'User';

update Employees 
set salary = salary * 1.10
where Department = 'HR';

update Employees
set department = 'Senior IT'
where Salary > 70000.00;

update Employees
set Department = 'Senior IT'
where FirstName = 'Nikola' and LastName = 'Lemp' and Salary > 70000.00;

delete from Employees 
where not exists(
	select 1
	from employeeProjects ep
	where ep.EmployeeID = Employees.EmployeeID
	)
and Department not in ('HR', 'Senior IT');


begin;
--CTE добавляется доп. проект JOB и выводим его
with new_proj AS(
	insert into Projects(ProjectName, Budget, StartDate, EndDate)
	values (' JOB', 120000.00, '2025-08-17', '2025-12-17')
	returning projectID
	)
--Вставляем связи сотрудников с новым проектом
	insert into EmployeeProjects(EmployeeID, ProjectID, HoursWorked)
--Назначаем сотрудников на новый проект с разным кол-вом часов
	select 2, ProjectID, 100 from new_proj
	union all 
	select 3, projectID, 120 from new_proj;
commit; -- фиксируем изменения

select employeeID, FirstName, LastName, Department, Salary
from employees
order by EmployeeID ASC;


-- Задание 5

-- Создание функции для расчёта годового бонуса (10% от зарплаты)
create or replace function CalculateAnnualBonus(emp_id INT, emp_salary DECIMAL)
returns DECIMAL as $$
BEGIN
    return emp_salary * 0.10;
END;
$$ language plpgsql;

-- Вывод потенциального бонуса для каждого сотрудника
select
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    CalculateAnnualBonus(EmployeeID, Salary) AS Bonus
from Employees;

-- Создание представления для сотрудников из отдела 'IT'
create or replace VIEW IT_Department_View as
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    Department
from Employees
where Department = 'IT';

-- Получение данных из представления IT_Department_View
select * from IT_Department_View;

--Задание 6
select Projects.ProjectName
from Projects 
join EmployeeProjects on projects.projectID = employeeprojects.projectID
join Employees on employeeprojects.EmployeeID = employees.EmployeeID
where employees.FirstName = 'Bob' and employees.LastName = 'Johnson'
and employeeprojects.HoursWorked > 150;

--Увеличиваем бюджет на 10%  
update Projects
set Budget = Budget * 1.10
where ProjectID in(
	select distinct employeeprojects.projectID
	from Employeeprojects
	join Employees on employeeprojects.employeeID = employees.employeeID
	where employees.department = 'IT'
);

update Projects
set EndDate = StartDate + interval '1 year'
where EndDate is null;

begin;

-- Вставка нового сотрудника с возвратом его ID
with new_employee as(
    insert into Employees (FirstName, LastName, Department, Salary)
    values ('Pavel', 'Golub', 'IT', 50000.00)
    returning EmployeeID
),
target_project as(
    select ProjectID from Projects where ProjectName = 'Website Redesign'
)
-- Назначение сотрудника на проект
insert into EmployeeProjects (EmployeeID, ProjectID, HoursWorked)
select ne.EmployeeID, tp.ProjectID, 80
from new_employee ne, target_project tp;

commit;

 --Проверка: проекты Bob Johnson с >150 часов
select * from Projects
where ProjectName in(
   select Projects.ProjectName
   from Projects 
   join EmployeeProjects  on Projects.ProjectID = Employeeprojects.ProjectID
   join Employees  on employeeprojects.EmployeeID = Employees.EmployeeID
   where Employees.FirstName = 'Bob' and Employees.LastName = 'Johnson'
    and Employeeprojects.HoursWorked > 150
);

 --Проверка: бюджеты проектов
select ProjectName, Budget from Projects;

-- Проверка: даты завершения проектов
select ProjectName, StartDate, EndDate from Projects;

-- Проверка нового сотрудника и его назначение
select Employees.EmployeeID, Employees.firstname e, Employees.LastName, Employeeprojects.ProjectID, Employeeprojects.HoursWorked
from Employees 
join EmployeeProjects  on Employees.EmployeeID = employeeprojects.EmployeeID
where Employees.FirstName = 'Pavel' and Employees.LastName = 'Golub';

