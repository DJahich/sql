WITH CarStats AS (
    SELECT 
        c.name AS car_name,
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
LowPerformingCars AS (
    SELECT 
        class,
        COUNT(*) AS low_performing_count
    FROM 
        CarStats
    WHERE 
        avg_position > 3.0
    GROUP BY 
        class
),
MaxLowPerforming AS (
    SELECT 
        MAX(low_performing_count) AS max_low_count
    FROM 
        LowPerformingCars
),
TopClasses AS (
    SELECT 
        lpc.class,
        lpc.low_performing_count,
        COUNT(DISTINCT r.race) AS total_class_races
    FROM 
        LowPerformingCars lpc
    JOIN 
        MaxLowPerforming mlp ON lpc.low_performing_count = mlp.max_low_count
    JOIN 
        Cars c ON lpc.class = c.class
    JOIN 
        Results r ON c.name = r.car
    GROUP BY 
        lpc.class, lpc.low_performing_count
)
SELECT 
    cs.car_name,
    cs.class,
    cs.avg_position,
    cs.races_count,
    cs.country,
    tc.total_class_races,
    tc.low_performing_count
FROM 
    CarStats cs
JOIN 
    TopClasses tc ON cs.class = tc.class
WHERE 
    cs.avg_position > 3.0
ORDER BY 
    tc.low_performing_count DESC,
    cs.class,
    cs.avg_position DESC;
