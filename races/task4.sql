WITH ClassAverages AS (
    SELECT 
        c.class,
        AVG(r.position) AS class_avg_position,
        COUNT(DISTINCT c.name) AS cars_in_class
    FROM 
        Cars c
    JOIN 
        Results r ON c.name = r.car
    GROUP BY 
        c.class
    HAVING 
        COUNT(DISTINCT c.name) >= 2
),
CarPerformance AS (
    SELECT 
        c.name AS car_name,
        c.class,
        cl.country,
        AVG(r.position) AS car_avg_position,
        COUNT(r.race) AS races_count
    FROM 
        Cars c
    JOIN 
        Results r ON c.name = r.car
    JOIN 
        Classes cl ON c.class = cl.class
    GROUP BY 
        c.name, c.class, cl.country
)
SELECT 
    cp.car_name,
    cp.class,
    cp.car_avg_position,
    cp.races_count,
    cp.country
FROM 
    CarPerformance cp
JOIN 
    ClassAverages ca ON cp.class = ca.class
WHERE 
    cp.car_avg_position < ca.class_avg_position
ORDER BY 
    cp.class ASC,
    cp.car_avg_position ASC;
