-- =========================================================
-- OLA Ride-Sharing Data Analysis
-- Author: Anshika
-- Tools: MySQL + Power BI
-- =========================================================

CREATE DATABASE IF NOT EXISTS OLAproject;
USE OLAproject;


CREATE OR REPLACE VIEW successful_booking AS
SELECT * FROM bookings
WHERE Booking_Status = 'Success';


CREATE OR REPLACE VIEW ride_dis_avg AS
SELECT Vehicle_Type, AVG(Ride_Distance) AS avg_distance
FROM bookings
GROUP BY Vehicle_Type;


CREATE OR REPLACE VIEW canceled_by_customer AS
SELECT COUNT(*) AS total_canceled_by_customer
FROM bookings
WHERE Booking_Status = 'Canceled by Customer';

CREATE OR REPLACE VIEW canceled_by_driver AS
SELECT COUNT(*) AS total_canceled_by_driver
FROM bookings
WHERE Booking_Status = 'Canceled by Driver';


SELECT
    MAX(Driver_Ratings) AS max_rating,
    MIN(Driver_Ratings) AS min_rating
FROM bookings
WHERE Vehicle_Type = 'Prime Sedan';


CREATE OR REPLACE VIEW revenue_by_vehicle AS
SELECT
    Vehicle_Type,
    SUM(Booking_Value) AS total_revenue,
    AVG(Booking_Value) AS avg_booking_value,
    COUNT(*) AS total_rides
FROM bookings
WHERE Booking_Status = 'Success'
GROUP BY Vehicle_Type;



CREATE OR REPLACE VIEW customer_cancel_reasons AS
SELECT Canceled_Rides_by_Customer, COUNT(*) AS total_count
FROM bookings
WHERE Booking_Status = 'Canceled by Customer'
GROUP BY Canceled_Rides_by_Customer;

CREATE OR REPLACE VIEW driver_cancel_reasons AS
SELECT Canceled_Rides_by_Driver, COUNT(*) AS total_count
FROM bookings
WHERE Booking_Status = 'Canceled by Driver'
GROUP BY Canceled_Rides_by_Driver;



CREATE OR REPLACE VIEW top_5_busy_routes AS
SELECT
    Pickup_Location,
    Drop_Location,
    COUNT(*) AS total_bookings,
    SUM(Booking_Value) AS route_revenue
FROM bookings
GROUP BY Pickup_Location, Drop_Location
ORDER BY total_bookings DESC
LIMIT 5;



CREATE OR REPLACE VIEW avg_turnaround_time AS
SELECT
    Vehicle_Type,
    AVG(V_TAT) AS avg_driver_arrival_time,
    AVG(C_TAT) AS avg_customer_pickup_time
FROM bookings
WHERE Booking_Status = 'Success'
GROUP BY Vehicle_Type;



CREATE OR REPLACE VIEW cancellation_revenue_impact AS
SELECT
    Booking_Status,
    COUNT(*) AS ride_count,
    ROUND(COUNT(*) * (SELECT AVG(Booking_Value) FROM bookings WHERE Booking_Status = 'Success'), 2) AS estimated_revenue_lost
FROM bookings
WHERE Booking_Status IN ('Canceled by Customer', 'Canceled by Driver')
GROUP BY Booking_Status;



CREATE OR REPLACE VIEW cancellation_by_hour AS
SELECT
    HOUR(Time) AS hour_of_day,
    COUNT(*) AS total_cancellations
FROM bookings
WHERE Booking_Status IN ('Canceled by Customer', 'Canceled by Driver')
GROUP BY HOUR(Time)
ORDER BY total_cancellations DESC;



CREATE OR REPLACE VIEW rating_vs_cancellation AS
SELECT
    CASE
        WHEN Customer_Rating >= 4.5 THEN 'High (4.5+)'
        WHEN Customer_Rating >= 3.5 THEN 'Medium (3.5-4.5)'
        ELSE 'Low (<3.5)'
    END AS rating_band,
    COUNT(*) AS total_rides,
    SUM(CASE WHEN Booking_Status = 'Canceled by Driver' THEN 1 ELSE 0 END) AS driver_cancels
FROM bookings
WHERE Customer_Rating IS NOT NULL
GROUP BY rating_band;



CREATE OR REPLACE VIEW payment_method_analysis AS
SELECT
    Payment_Method,
    COUNT(*) AS total_rides,
    AVG(Booking_Value) AS avg_value,
    AVG(Ride_Distance) AS avg_distance
FROM bookings
WHERE Booking_Status = 'Success' AND Payment_Method IS NOT NULL
GROUP BY Payment_Method;



CREATE OR REPLACE VIEW customer_ride_frequency AS
SELECT
    Customer_ID,
    COUNT(*) AS total_rides,
    SUM(Booking_Value) AS total_spend
FROM bookings
WHERE Booking_Status = 'Success'
GROUP BY Customer_ID
HAVING COUNT(*) > 1
ORDER BY total_rides DESC;
