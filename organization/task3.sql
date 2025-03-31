TH RECURSIVE ManagerHierarchy AS (
    -- Базовый случай: все менеджеры
    SELECT 
        e.EmployeeID,
        e.Name AS EmployeeName,
        e.ManagerID,
        d.DepartmentName,
        r.RoleName,
        0 AS level
    FROM 
        Employees e
    JOIN 
        Departments d ON e.DepartmentID = d.DepartmentID
    JOIN 
        Roles r ON e.RoleID = r.RoleID
    WHERE 
        r.RoleName = 'Менеджер'
),

SubordinateCount AS (
    -- Подсчет непосредственных подчиненных
    SELECT 
        e.ManagerID,
        COUNT(*) AS direct_subordinates
    FROM 
        Employees e
    GROUP BY 
        e.ManagerID
    HAVING 
        COUNT(*) > 0
),

ManagerWithSubordinates AS (
    -- Менеджеры с подчиненными
    SELECT 
        m.*
    FROM 
        ManagerHierarchy m
    JOIN 
        SubordinateCount sc ON m.EmployeeID = sc.ManagerID
),

AllSubordinates AS (
    -- Рекурсивный поиск всех подчиненных (включая подчиненных подчиненных)
    SELECT 
        m.EmployeeID AS manager_id,
        e.EmployeeID AS subordinate_id
    FROM 
        ManagerWithSubordinates m
    JOIN 
        Employees e ON e.ManagerID = m.EmployeeID
    
    UNION ALL
    
    SELECT 
        a.manager_id,
        e.EmployeeID AS subordinate_id
    FROM 
        AllSubordinates a
    JOIN 
        Employees e ON e.ManagerID = a.subordinate_id
),

TotalSubordinates AS (
    -- Подсчет всех подчиненных для каждого менеджера
    SELECT 
        manager_id,
        COUNT(DISTINCT subordinate_id) AS total_subordinates
    FROM 
        AllSubordinates
    GROUP BY 
        manager_id
),

EmployeeProjects AS (
    -- Проекты сотрудников
    SELECT 
        e.EmployeeID,
        GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') AS ProjectNames
    FROM 
        Employees e
    LEFT JOIN 
        Projects p ON e.DepartmentID = p.DepartmentID
    GROUP BY 
        e.EmployeeID
),

EmployeeTasks AS (
    -- Задачи сотрудников
    SELECT 
        t.AssignedTo AS EmployeeID,
        GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ') AS TaskNames
    FROM 
        Tasks t
    GROUP BY 
        t.AssignedTo
)

-- Финальный результат
SELECT 
    m.EmployeeID,
    m.EmployeeName,
    m.ManagerID,
    m.DepartmentName,
    m.RoleName,
    ep.ProjectNames,
    et.TaskNames,
    ts.total_subordinates AS TotalSubordinates
FROM 
    ManagerWithSubordinates m
JOIN 
    TotalSubordinates ts ON m.EmployeeID = ts.manager_id
LEFT JOIN 
    EmployeeProjects ep ON m.EmployeeID = ep.EmployeeID
LEFT JOIN 
    EmployeeTasks et ON m.EmployeeID = et.EmployeeID
ORDER BY 
    m.EmployeeName;
