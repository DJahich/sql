WITH ClassStats AS (
    SELECT 
        c.class,
        cl.country,
        AVG(r.position) AS class_avg_position,
        COUNT(DISTINCT r.race) AS total_class_races
    FROM 
        Cars c
    JOIN 
        Results r ON c.name = r.car
    JOIN 
        Classes cl ON c.class = cl.class
    GROUP BY 
        c.class, cl.country
),
MinClassAvg AS (
    SELECT 
        MIN(class_avg_position) AS min_avg_position
    FROM 
        ClassStats
),
TopClasses AS (
    SELECT 
        cs.class,
        cs.country,
        cs.class_avg_position,
        cs.total_class_races
    FROM 
        ClassStats cs
    JOIN 
        MinClassAvg mca ON cs.class_avg_position = mca.min_avg_position
),
CarDetails AS (
    SELECT 
        c.name AS car_name,
        c.class,
        tc.country,
        AVG(r.position) AS car_avg_position,
        COUNT(r.race) AS car_races_count,
        tc.total_class_races
    FROM 
        Cars c
    JOIN 
        Results r ON c.name = r.car
    JOIN 
        TopClasses tc ON c.class = tc.class
    GROUP BY 
        c.name, c.class, tc.country, tc.total_class_races
)
SELECT 
    car_name,
    class,
    country,
    car_avg_position,
    car_races_count,
    total_class_races
FROM 
    CarDetails
ORDER BY 
    class, car_name;
