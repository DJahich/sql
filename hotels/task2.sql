TH CustomerStats AS (
    SELECT 
        c.ID_customer,
        c.name,
        COUNT(DISTINCT b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS distinct_hotels,
        SUM(r.price * DATEDIFF(b.check_out_date, b.check_in_date)) AS total_spent
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    JOIN 
        Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY 
        c.ID_customer, c.name
),
MultiHotelClients AS (
    SELECT 
        ID_customer,
        name,
        total_bookings,
        distinct_hotels,
        total_spent
    FROM 
        CustomerStats
    WHERE 
        total_bookings > 2 
        AND distinct_hotels > 1
),
HighSpendingClients AS (
    SELECT 
        ID_customer,
        name,
        total_bookings,
        total_spent
    FROM 
        CustomerStats
    WHERE 
        total_spent > 500
)
SELECT 
    m.ID_customer,
    m.name,
    m.total_bookings,
    m.total_spent,
    m.distinct_hotels
FROM 
    MultiHotelClients m
JOIN 
    HighSpendingClients h ON m.ID_customer = h.ID_customer
ORDER BY 
    m.total_spent ASC;
