WITH CarStats AS (
    SELECT 
        c.name,
        c.class,
        cl.country,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS races_count
    FROM 
        Cars c
    JOIN 
        Results r ON c.name = r.car
    JOIN 
        Classes cl ON c.class = cl.class
    GROUP BY 
        c.name, c.class, cl.country
),
MinAvgCar AS (
    SELECT 
        name,
        class,
        country,
        avg_position,
        races_count
    FROM 
        CarStats
    ORDER BY 
        avg_position ASC,
        name ASC
    LIMIT 1
)
SELECT 
    name AS car_name,
    class,
    country,
    avg_position,
    races_count
FROM 
    MinAvgCar;
