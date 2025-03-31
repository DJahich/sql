TH CustomerBookings AS (
    SELECT 
        c.ID_customer,
        c.name,
        c.email,
        c.phone,
        COUNT(DISTINCT b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS distinct_hotels,
        AVG(DATEDIFF(b.check_out_date, b.check_in_date)) AS avg_stay_duration
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    JOIN 
        Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY 
        c.ID_customer, c.name, c.email, c.phone
    HAVING 
        COUNT(DISTINCT h.ID_hotel) > 2
),
HotelList AS (
    SELECT 
        c.ID_customer,
        GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ') AS hotels_list
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    JOIN 
        Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY 
        c.ID_customer
)
SELECT 
    cb.name,
    cb.email,
    cb.phone,
    cb.total_bookings,
    hl.hotels_list,
    ROUND(cb.avg_stay_duration, 1) AS avg_stay_duration_days
FROM 
    CustomerBookings cb
JOIN 
    HotelList hl ON cb.ID_customer = hl.ID_customer
ORDER BY 
    cb.total_bookings DESC;WITH CustomerBookings AS (
    SELECT 
        c.ID_customer,
        c.name,
        c.email,
        c.phone,
        COUNT(DISTINCT b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS distinct_hotels,
        AVG(DATEDIFF(b.check_out_date, b.check_in_date)) AS avg_stay_duration
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    JOIN 
        Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY 
        c.ID_customer, c.name, c.email, c.phone
    HAVING 
        COUNT(DISTINCT h.ID_hotel) > 2
),
HotelList AS (
    SELECT 
        c.ID_customer,
        GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ') AS hotels_list
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    JOIN 
        Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY 
        c.ID_customer
)
SELECT 
    cb.name,
    cb.email,
    cb.phone,
    cb.total_bookings,
    hl.hotels_list,
    ROUND(cb.avg_stay_duration, 1) AS avg_stay_duration_days
FROM 
    CustomerBookings cb
JOIN 
    HotelList hl ON cb.ID_customer = hl.ID_customer
ORDER BY 
    cb.total_bookings DESC;
