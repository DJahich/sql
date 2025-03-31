TH HotelCategories AS (
    SELECT 
        h.ID_hotel,
        h.name AS hotel_name,
        h.location,
        CASE 
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_category
    FROM 
        Hotel h
    JOIN 
        Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY 
        h.ID_hotel, h.name, h.location
),

ClientHotelVisits AS (
    SELECT 
        c.ID_customer,
        c.name AS customer_name,
        hc.hotel_category,
        hc.hotel_name
    FROM 
        Customer c
    JOIN 
        Booking b ON c.ID_customer = b.ID_customer
    JOIN 
        Room r ON b.ID_room = r.ID_room
    JOIN 
        HotelCategories hc ON r.ID_hotel = hc.ID_hotel
),

ClientPreferences AS (
    SELECT 
        ID_customer,
        customer_name,
        CASE 
            WHEN MAX(CASE WHEN hotel_category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 'Дорогой'
            WHEN MAX(CASE WHEN hotel_category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 'Средний'
            ELSE 'Дешевый'
        END AS preferred_hotel_type
    FROM 
        ClientHotelVisits
    GROUP BY 
        ID_customer, customer_name
),

ClientHotelList AS (
    SELECT 
        ID_customer,
        STRING_AGG(DISTINCT hotel_name, ', ' ORDER BY hotel_name) AS visited_hotels
    FROM 
        ClientHotelVisits
    GROUP BY 
        ID_customer
)

SELECT 
    cp.ID_customer,
    cp.customer_name AS name,
    cp.preferred_hotel_type,
    chl.visited_hotels
FROM 
    ClientPreferences cp
JOIN 
    ClientHotelList chl ON cp.ID_customer = chl.ID_customer
ORDER BY 
    CASE cp.preferred_hotel_type
        WHEN 'Дешевый' THEN 1
        WHEN 'Средний' THEN 2
        WHEN 'Дорогой' THEN 3
    END,
    cp.customer_name;
