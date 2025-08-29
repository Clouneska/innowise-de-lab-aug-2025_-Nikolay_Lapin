DROP TABLE IF EXISTS fact_ProjectEmployees CASCADE;
DROP TABLE IF EXISTS dim_Task CASCADE;
DROP TABLE IF EXISTS dim_Client CASCADE;
DROP TABLE IF EXISTS dim_Employee CASCADE;
DROP TABLE IF EXISTS dim_Project CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
-- 
CREATE TABLE dim_Project (
    ProjectID INTEGER PRIMARY KEY,
    Name VARCHAR(255),
    Budget NUMERIC(12,2) CHECK (Budget >= 0),
    EndDate DATE
);

CREATE TABLE dim_Employee (
    EmployeeID SERIAL PRIMARY KEY,
    FullName VARCHAR(255),
    Position VARCHAR(100),
    Salary NUMERIC(10,2) CHECK (Salary >= 0)
);

CREATE TABLE dim_Client (
    ClientID SERIAL PRIMARY KEY,
    Name VARCHAR(255),
    ContactInfo VARCHAR(255)
);

CREATE TABLE dim_Task (
    TaskID SERIAL PRIMARY KEY,
    TaskName VARCHAR(255),
    DueDate DATE,
    EstimatedHours INTEGER CHECK (EstimatedHours >= 0)
);

--

CREATE TABLE fact_ProjectEmployees (
    FactID SERIAL PRIMARY KEY,
    ProjectID INTEGER REFERENCES dim_Project(ProjectID),
    EmployeeID INTEGER REFERENCES dim_Employee(EmployeeID),
    ClientID INTEGER REFERENCES dim_Client(ClientID),
    TaskID INTEGER REFERENCES dim_Task(TaskID),
    HoursWorked NUMERIC(6,2) CHECK (HoursWorked >= 0),
    TaskStatus VARCHAR(50),
    CompletionDate DATE
);

INSERT INTO dim_Employee (EmployeeID, FullName, Position, Salary) VALUES
(1, 'Иван Петров', 'Инженер', 75000),
(2, 'Мария Смирнова', 'Архитектор', 82000),
(3, 'Алексей Кузнецов', 'Прораб', 68000),
(4, 'Ольга Иванова', 'Сметчик', 70000),
(5, 'Дмитрий Соколов', 'Электрик', 60000),
(6, 'Наталья Орлова', 'Дизайнер', 72000);

INSERT INTO dim_Project (ProjectID, Name, Budget, EndDate) VALUES
(1, 'Жилой комплекс "Север"', 12000000, '2025-12-31'),
(2, 'Бизнес-центр "Орион"', 8500000, '2025-10-15'),
(3, 'Коттеджный посёлок "Лесной"', 5000000, '2025-08-30');

INSERT INTO dim_Task (TaskID, TaskName, DueDate, EstimatedHours) VALUES
(1, 'Разработка чертежей', '2025-07-15', 120),
(2, 'Монтаж электрики', '2025-08-01', 80),
(3, 'Отделочные работы', '2025-09-10', 150),
(4, 'Смета и расчёты', '2025-06-30', 60),
(5, 'Ландшафтный дизайн', '2025-08-20', 100),
(6, 'Установка окон', '2025-07-25', 90);

INSERT INTO dim_Client (ClientID, Name, ContactInfo) VALUES
(1, 'ООО "СтройИнвест"', 'invest@stroi.by'),
(2, 'ЗАО "ГрандПроект"', 'info@grand.by'),
(3, 'ИП Сидоров А.В.', 'sidav@private.by');

-- Проект 1 — "Жилой комплекс 'Север'" — клиент: ООО "СтройИнвест"
INSERT INTO fact_ProjectEmployees (ProjectID, EmployeeID, ClientID, TaskID, HoursWorked, TaskStatus, CompletionDate) VALUES
(1, 1, 1, 1, 110, 'Completed', '2025-07-14'),  -- Иван Петров — инженер, чертежи
(1, 2, 1, 1, 10, 'Completed', '2025-07-14'),  -- Мария Смирнова — архитектор, чертежи
(1, 6, 1, 3, 45, 'In Progress', NULL);        -- Наталья Орлова — дизайнер, отделка

-- Проект 2 — "Бизнес-центр 'Орион'" — клиент: ЗАО "ГрандПроект"
INSERT INTO fact_ProjectEmployees (ProjectID, EmployeeID, ClientID, TaskID, HoursWorked, TaskStatus, CompletionDate) VALUES
(2, 3, 2, 2, 70, 'Completed', '2025-07-30'),  -- Алексей Кузнецов — прораб, электрика
(2, 5, 2, 2, 10, 'Completed', '2025-07-30'),  -- Дмитрий Соколов — электрик
(2, 2, 2, 6, 85, 'Completed', '2025-07-24');  -- Мария Смирнова — архитектор, окна

-- Проект 3 — "Коттеджный посёлок 'Лесной'" — клиент: ИП Сидоров А.В.
INSERT INTO fact_ProjectEmployees (ProjectID, EmployeeID, ClientID, TaskID, HoursWorked, TaskStatus, CompletionDate) VALUES
(3, 4, 3, 4, 60, 'Completed', '2025-06-29'),  -- Ольга Иванова — сметчик, расчёты
(3, 6, 3, 5, 90, 'In Progress', NULL),        -- Наталья Орлова — дизайнер, ландшафт
(3, 1, 3, 5, 15, 'In Progress', NULL);        -- Иван Петров — инженер, помощь в ландшафте

--Сводка по каждому проекту
SELECT 
    p.Name AS Project,
    COUNT(DISTINCT f.TaskID) AS TaskCount,
    SUM(f.HoursWorked) AS TotalHours,
    COUNT(*) FILTER (WHERE f.TaskStatus = 'Completed') AS CompletedTasks,
    COUNT(*) FILTER (WHERE f.TaskStatus = 'In Progress') AS InProgressTasks
FROM fact_ProjectEmployees f
JOIN dim_Project p ON f.ProjectID = p.ProjectID
GROUP BY p.Name
ORDER BY p.Name;

--Кто над каким проектом работает и какие часы выделены
SELECT 
    p.Name AS Project,
    e.FullName AS Employee,
    t.TaskName,
    f.HoursWorked,
    f.TaskStatus
FROM fact_ProjectEmployees f
JOIN dim_Project p ON f.ProjectID = p.ProjectID
JOIN dim_Employee e ON f.EmployeeID = e.EmployeeID
JOIN dim_Task t ON f.TaskID = t.TaskID
ORDER BY p.Name, e.FullName;

--Проверка по завершению всех задач по проекту
SELECT 
    p.Name AS Project,
    CASE 
        WHEN COUNT(*) = COUNT(*) FILTER (WHERE f.TaskStatus = 'Completed') 
        THEN 'Все задачи завершены'
        ELSE 'Есть незавершённые задачи'
    END AS ProjectStatus
FROM fact_ProjectEmployees f
JOIN dim_Project p ON f.ProjectID = p.ProjectID
GROUP BY p.Name;
