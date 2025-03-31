TH RECURSIVE EmployeeHierarchy AS (
    -- Базовый случай: начинаем с Ивана Иванова (EmployeeID = 1)
    SELECT 
        e.EmployeeID,
        e.Name AS EmployeeName,
        e.ManagerID,
        d.DepartmentName,
        r.RoleName
    FROM 
        Employees e
    JOIN 
        Departments d ON e.DepartmentID = d.DepartmentID
    JOIN 
        Roles r ON e.RoleID = r.RoleID
    WHERE 
        e.EmployeeID = 1
    
    UNION ALL
    
    -- Рекурсивный случай: находим всех подчиненных
    SELECT 
        e.EmployeeID,
        e.Name AS EmployeeName,
        e.ManagerID,
        d.DepartmentName,
        r.RoleName
    FROM 
        Employees e
    JOIN 
        EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
    JOIN 
        Departments d ON e.DepartmentID = d.DepartmentID
    JOIN 
        Roles r ON e.RoleID = r.RoleID
),

EmployeeProjects AS (
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
    SELECT 
        t.AssignedTo AS EmployeeID,
        GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ') AS TaskNames,
        COUNT(t.TaskID) AS TotalTasks
    FROM 
        Tasks t
    GROUP BY 
        t.AssignedTo
),

DirectSubordinates AS (
    SELECT 
        e.ManagerID,
        COUNT(*) AS TotalSubordinates
    FROM 
        Employees e
    GROUP BY 
        e.ManagerID
)

SELECT 
    eh.EmployeeID,
    eh.EmployeeName,
    eh.ManagerID,
    eh.DepartmentName,
    eh.RoleName,
    ep.ProjectNames,
    et.TaskNames,
    IFNULL(et.TotalTasks, 0) AS TotalTasks,
    IFNULL(ds.TotalSubordinates, 0) AS TotalSubordinates
FROM 
    EmployeeHierarchy eh
LEFT JOIN 
    EmployeeProjects ep ON eh.EmployeeID = ep.EmployeeID
LEFT JOIN 
    EmployeeTasks et ON eh.EmployeeID = et.EmployeeID
LEFT JOIN 
    DirectSubordinates ds ON eh.EmployeeID = ds.ManagerID
ORDER BY 
    eh.EmployeeName;
