TH CarAvgPositions AS (
    SELECT 
        c.name,
        c.class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS races_count
    FROM 
        Cars c
    JOIN 
        Results r ON c.name = r.car
    GROUP BY 
        c.name, c.class
),
MinAvgByClass AS (
    SELECT 
        class,
        MIN(avg_position) AS min_avg_position
    FROM 
        CarAvgPositions
    GROUP BY 
        class
)
SELECT 
    cap.name,
    cap.class,
    cap.avg_position,
    cap.races_count
FROM 
    CarAvgPositions cap
JOIN 
    MinAvgByClass mabc ON cap.class = mabc.class AND cap.avg_position = mabc.min_avg_position
ORDER BY 
    cap.avg_position;
