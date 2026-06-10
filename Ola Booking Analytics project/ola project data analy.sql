Create Database Ola;
Use ola;
-- 1. Retrieve all successful bookings:
create view successful_bookings as
select * from bookings where Booking_Status= 'Successful';

-- 1. Retrieve all successful bookings:
select * from successful_bookings; -- to temperorily store data as schema so not to write command above again--


-- 2. Find the average ride distance for each vehicle type: 
create view ride_distance_for_each_vehicle as
select Vehicle_Type, AVG(Ride_Distance) as avg_distance
from bookings
group by Vehicle_Type;

-- 2. Find the average ride distance for each vehicle type: 
select * from ride_distance_for_each_vehicle;


-- 3. Get the total number of cancelled rides by customers:
create view cancelled_rides_by_customers as
select count(*) from bookings where booking_status="Customer Cancelled";

-- 3. Get the total number of cancelled rides by customers:
select * from cancelled_rides_by_customers;


-- 4. List the top 5 customers who booked the highest number of rides:
create view top_5_customers as
select CUSTOMER_ID, COUNT(BOOKING_ID) as total_rides
from bookings group by customer_id
order by total_rides  desc limit 5;

-- 4. List the top 5 customers who booked the highest number of rides:
select * from top_5_customers;


-- 5. Get the number of rides cancelled by drivers due to personal and car-related issues:
create view rides_cancelled_by_drivers_P_C_Issues AS 
select count(*) from bookings where Driver_Cancellation_Reason= "Personal & Car related issues";

-- 5. Get the number of rides cancelled by drivers due to personal and car-related issues:
select * from rides_cancelled_by_drivers_P_C_Issues;


-- 6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
create view max_min_driver_rating as
select max(Driver_Ratings) as max_rating,
min(Driver_Ratings) as min_rating from bookings
where Vehicle_Type="Prime Sedan";
-- min is not showing because somewhere in the data is blank in rating --

-- 6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
select * from max_min_driver_rating;


-- 7. Retrieve all rides where payment was made using UPI:
create view UPI_payment as
select * from bookings where payment_method ="upi";

-- 7. Retrieve all rides where payment was made using UPI:
select * from UPI_payment;


-- 8. Find the average customer rating per vehicle type:
create view avg_cust_rating as
select vehicle_type, avg(Customer_ratings) as avg_customer_rating
from bookings group by vehicle_type;

-- 8. Find the average customer rating per vehicle type:
select * from avg_cust_rating;


-- 9. Calculate the total booking value of rides completed successfully:
create view total_successful_ride_value as
select sum(Booking_Value) as total_successful_ride_value from bookings 
where booking_status= "Successful";

-- 9. Calculate the total booking value of rides completed successfully:
select * from total_successful_ride_value;


-- 10. List all incomplete rides along with the reason:
create view incomplete_rides_reason as
select booking_id, incomplete_rides_reason from bookings where incomplete_rides="yes";

-- 10. List all incomplete rides along with the reason:
select * from incomplete_rides_reason;

-- 11. Find the revenue generated each day from successful rides.
-- Which days generated the highest revenue?
CREATE VIEW daily_revenue_trend AS
SELECT Date,
       SUM(Booking_Value) AS Revenue
FROM bookings
WHERE Booking_Status = 'Successful'
GROUP BY Date
ORDER BY Date;

-- 11. Find the revenue generated each day from successful rides.
SELECT * FROM daily_revenue_trend;


-- 12. Identifies peak demand hours for ride bookings.
-- At what time do customers book rides the most?
CREATE VIEW peak_booking_hours AS
SELECT HOUR(Time) AS Booking_Hour,
       COUNT(*) AS Total_Rides
FROM bookings
GROUP BY Booking_Hour
ORDER BY Total_Rides DESC;

-- 12. Identifies peak demand hours for ride bookings.
SELECT * FROM peak_booking_hours;

-- 13. What percentage of bookings are cancelled?
-- Measures overall cancellation percentage, an important operational KPI.
CREATE VIEW cancellation_rate AS
SELECT
ROUND(
(COUNT(
CASE
WHEN Booking_Status LIKE '%Cancelled%'
THEN 1
END
)*100.0)/COUNT(*),2
) AS Cancellation_Rate
FROM bookings;

-- 13. What percentage of bookings are cancelled?
SELECT * FROM cancellation_rate;


-- 14. Which vehicle category contributes the most revenue?
-- Shows revenue contribution by each vehicle category.
CREATE VIEW revenue_by_vehicle_type AS
SELECT Vehicle_Type,
       SUM(Booking_Value) AS Revenue
FROM bookings
WHERE Booking_Status='Successful'
GROUP BY Vehicle_Type
ORDER BY Revenue DESC;

-- 14. Which vehicle category contributes the most revenue?
SELECT * FROM revenue_by_vehicle_type;

-- 15. Which vehicle category receives the highest driver ratings?
-- Driver Ratings by Vehicle Type
CREATE VIEW vehicle_driver_rating AS
SELECT Vehicle_Type,
       ROUND(AVG(Driver_Ratings),2) AS Avg_Driver_Rating
FROM bookings
GROUP BY Vehicle_Type;


SELECT * FROM vehicle_driver_rating;

-- 16. Customer Ratings by Vehicle Type
-- Compare customer satisfaction across vehicle categories.
CREATE VIEW vehicle_customer_rating AS
SELECT Vehicle_Type,
       ROUND(AVG(Customer_Ratings),2) AS Avg_Customer_Rating
FROM bookings
GROUP BY Vehicle_Type;

SELECT * FROM vehicle_customer_rating;


-- 17. Revenue per Kilometer
-- Which vehicle type generates the most revenue relative to distance traveled? 
CREATE VIEW revenue_per_km AS
SELECT Vehicle_Type,
       ROUND(SUM(Booking_Value)/SUM(Ride_Distance),2) AS Revenue_Per_KM
FROM bookings
WHERE Booking_Status='Successful'
GROUP BY Vehicle_Type;

SELECT * FROM revenue_per_km;


-- 18. Highest Revenue Customers
-- Identify your most valuable customers.
CREATE VIEW highest_revenue_customers AS
SELECT Customer_ID,
       SUM(Booking_Value) AS Total_Spent
FROM bookings
GROUP BY Customer_ID
ORDER BY Total_Spent DESC
LIMIT 10;

SELECT * FROM highest_revenue_customers;


-- 19. Most Popular Vehicle Type
-- Understand customer vehicle preferences.
CREATE VIEW most_popular_vehicle AS
SELECT Vehicle_Type,
       COUNT(*) AS Total_Rides
FROM bookings
GROUP BY Vehicle_Type
ORDER BY Total_Rides DESC;

SELECT * FROM most_popular_vehicle;


-- 20.Customer Lifetime Value (CLV)
-- Which customers spend the most on rides?
-- Measures total customer contribution to revenue.
CREATE VIEW customer_lifetime_value AS
SELECT Customer_ID,
       COUNT(*) AS Total_Rides,
       SUM(Booking_Value) AS Total_Spent
FROM bookings
GROUP BY Customer_ID
ORDER BY Total_Spent DESC;

SELECT * FROM customer_lifetime_value;


-- 21. Repeat Customers- Identifies loyal and repeat customers.
-- Which customers frequently use the platform?
CREATE VIEW repeat_customers_1 AS
SELECT Customer_ID,
       COUNT(*) AS Ride_Count
FROM bookings
GROUP BY Customer_ID
HAVING Ride_Count > 5;

SELECT * FROM repeat_customers_1;


-- 22. Payment Method Analysis
-- Which payment methods are most preferred?
-- Analyzes payment preferences and average fare by payment type.
CREATE VIEW payment_method_analysis_1 AS
SELECT Payment_Method,
       COUNT(*) AS Total_Rides,
       ROUND(AVG(Booking_Value),2) AS Avg_Fare
FROM bookings
GROUP BY Payment_Method;

SELECT * FROM payment_method_analysis_1;


-- 23. Customer Ranking Using Window Function
-- Who are the highest-spending customers?
-- Ranks customers according to total spending.
CREATE VIEW customer_ranking AS
SELECT Customer_ID,
       SUM(Booking_Value) AS Total_Spent,
       RANK() OVER(
           ORDER BY SUM(Booking_Value) DESC
       ) AS Customer_Rank
FROM bookings
GROUP BY Customer_ID;

SELECT * FROM customer_ranking;


-- 24. Dense Ranking Customers
-- Assigns ranks without gaps when ties occur.
CREATE VIEW customer_dense_rank AS
SELECT
    CUSTOMER_ID,
    Total_Spent,
    ROW_NUMBER() OVER (ORDER BY Total_Spent DESC) AS Row_Num
FROM
(
    SELECT
        CUSTOMER_ID,
        SUM(`Booking_Value`) AS Total_Spent
    FROM bookings
    GROUP BY CUSTOMER_ID
) t;

SELECT * FROM customer_dense_rank;


-- 25. Row Number Ranking
-- Assigns a unique sequential number to each customer.
CREATE VIEW customer_row_number AS
SELECT
    Customer_ID,
    SUM(Booking_Value) AS Total_Spent,
    ROW_NUMBER() OVER (
        ORDER BY SUM(Booking_Value) DESC
    ) AS Row_Num
FROM bookings
GROUP BY Customer_ID;

SELECT * FROM customer_row_number;


-- 26. Revenue Analysis Using CTE
-- Which vehicle types generate maximum revenue?
-- Uses a Common Table Expression (CTE) to improve readability and modularity of complex queries.
WITH Revenue AS
(
    SELECT Vehicle_Type,
           SUM(Booking_Value) AS Total_Revenue
    FROM bookings
    GROUP BY Vehicle_Type
)
SELECT *
FROM Revenue
ORDER BY Total_Revenue DESC;

-- 27. Revenue by Day of Week
-- Identify which day of the week generates the highest revenue from successful rides.
-- Helps identify the most profitable days. Useful for planning driver availability and promotional campaigns.
CREATE VIEW revenue_by_weekday AS
SELECT
    DAYNAME(Date) AS Day_Name,
    SUM(Booking_Value) AS Revenue
FROM bookings
WHERE Booking_Status = 'Successful'
GROUP BY DAYNAME(Date);

SELECT * FROM revenue_by_weekday;


-- 28. Average Fare by Vehicle Type
-- Calculate the average booking value (fare) for each vehicle category.
-- Identifies premium and budget vehicle categories. Helps optimize pricing strategies.
CREATE VIEW avg_fare_vehicle_type AS
SELECT
    Vehicle_Type,
    ROUND(AVG(Booking_Value), 2) AS Avg_Fare
FROM bookings
GROUP BY Vehicle_Type;

SELECT * FROM avg_fare_vehicle_type;


-- 29. Revenue Contribution by Vehicle Type (%)
-- Determine how much revenue each vehicle category contributes to total successful ride revenue.
-- Shows which vehicle types drive business revenue. Useful for fleet expansion and investment decisions.
CREATE VIEW revenue_contribution AS
SELECT
    Vehicle_Type,
    SUM(Booking_Value) AS Revenue,
    ROUND(
        SUM(Booking_Value) * 100 /
        (
            SELECT SUM(Booking_Value)
            FROM bookings
            WHERE Booking_Status = 'Successful'
        ),
        2
    ) AS Revenue_Percentage
FROM bookings
WHERE Booking_Status = 'Successful'
GROUP BY Vehicle_Type;

SELECT * FROM revenue_contribution;


-- 30. Customer Segmentation
-- Categorize customers based on their total spending.
-- Identifies high-value customers. Enables targeted marketing and loyalty programs.
CREATE VIEW customer_segments AS
SELECT
    CUSTOMER_ID,
    SUM(`Booking_Value`) AS Total_Spent,
    CASE
        WHEN SUM(`Booking_Value`) >= 5000 THEN 'Premium'
        WHEN SUM(`Booking_Value`) >= 2000 THEN 'Regular'
        ELSE 'Occasional'
    END AS Customer_Type
FROM bookings
GROUP BY CUSTOMER_ID;

SELECT * FROM customer_segments;

-- 31. Booking Success Rate
-- Measure the percentage of bookings that were completed successfully.
-- Important operational KPI. Higher success rate indicates better service efficiency.
CREATE VIEW booking_success_rate AS
SELECT
    ROUND(
        COUNT(
            CASE
                WHEN Booking_Status = 'Successful'
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Success_Rate
FROM bookings;

SELECT * FROM booking_success_rate;


-- 32. Peak Demand Vehicle Type
-- Identify the most frequently booked vehicle category.
-- Reveals customer vehicle preferences. Helps allocate drivers and vehicles more effectively.
CREATE VIEW vehicle_demand AS
SELECT
    Vehicle_Type,
    COUNT(*) AS Total_Bookings
FROM bookings
GROUP BY Vehicle_Type
ORDER BY Total_Bookings DESC;

SELECT * FROM vehicle_demand;


-- 33. Revenue Growth Trend- Shows business growth over time.
-- Track whether revenue is increasing or decreasing over time.
CREATE VIEW revenue_growth_trend AS
SELECT
    Date,
    SUM(Booking_Value) AS Daily_Revenue
FROM bookings
WHERE Booking_Status='Successful'
GROUP BY Date
ORDER BY Date;

SELECT * FROM revenue_growth_trend;


-- 34. Cancellation Reason Analysis
-- Identify the biggest causes of ride cancellations.
CREATE VIEW cancellation_reason_analysis AS
SELECT
    Driver_Cancellation_Reason,
    COUNT(*) AS Total_Cancellations
FROM bookings
WHERE Booking_Status LIKE '%Cancelled%'
GROUP BY Driver_Cancellation_Reason
ORDER BY Total_Cancellations DESC;

SELECT * FROM cancellation_reason_analysis;


-- 35. Average Distance by Vehicle Type
-- Understand which vehicle categories are used for longer trips.
CREATE VIEW avg_distance_vehicle_type AS
SELECT
    Vehicle_Type,
    ROUND(AVG(Ride_Distance),2) AS Avg_Distance
FROM bookings
GROUP BY Vehicle_Type;

SELECT * FROM avg_distance_vehicle_type;


-- 36. Revenue vs Cancellation by Vehicle Type
-- Compare revenue generation and cancellation performance across vehicle categories.
CREATE VIEW vehicle_performance AS
SELECT
    Vehicle_Type,
    COUNT(*) AS Total_Bookings,
    SUM(CASE WHEN Booking_Status='Successful' THEN 1 ELSE 0 END) AS Successful_Rides,
    SUM(CASE WHEN Booking_Status LIKE '%Cancelled%' THEN 1 ELSE 0 END) AS Cancelled_Rides,
    SUM(CASE WHEN Booking_Status='Successful' THEN Booking_Value ELSE 0 END) AS Revenue
FROM bookings
GROUP BY Vehicle_Type;

SELECT * FROM vehicle_performance;


-- 37. Customer Rating 
-- Measure overall customer satisfaction.
CREATE VIEW customer_rating_distribution AS
SELECT
    Customer_Ratings,
    COUNT(*) AS Rating_Count
FROM bookings
GROUP BY Customer_Ratings
ORDER BY Customer_Ratings DESC;

SELECT * FROM customer_rating_distribution;


-- --------------------------------------------------------------------------------------- --
-- other commands --
-- DROP column IF EXISTS Payment_Method;
DROP VIEW IF EXISTS successful_bookings;
CREATE VIEW successful_bookings AS
SELECT *
FROM bookings
WHERE Booking_Status = 'Successful';
SELECT * FROM successful_bookings;

ALTER TABLE bookings
ADD COLUMN Payment_Method VARCHAR(20);
ALTER TABLE bookings
ADD COLUMN Payment_Method ENUM('UPI', 'Cash', 'Credit Card', 'NA');

SET SQL_SAFE_UPDATES = 0;

UPDATE bookings
SET Payment_Method =
CASE FLOOR(RAND() * 4)
    WHEN 0 THEN 'UPI'
    WHEN 1 THEN 'Cash'
    WHEN 2 THEN 'Credit Card'  
    ELSE 'NA'
END;
SET SQL_SAFE_UPDATES = 1;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';
SELECT VERSION();
DROP VIEW customer_row_number;
SHOW COLUMNS FROM bookings;
SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT `Booking Status` FROM `ola`.`bookings`;
ALTER TABLE bookings
RENAME COLUMN `Booking Status` TO `Booking_Status`;

SELECT `Vehicle Type` FROM `ola`.`bookings`;
ALTER TABLE bookings
RENAME COLUMN `Vehicle Type` TO `Vehicle_Type`;

SELECT * FROM OLA;
SELECT `Ride Distance` FROM `ola`.`bookings`;
ALTER TABLE bookings
RENAME COLUMN `Ride Distance` TO `Ride_Distance`;

SELECT `CUSTOMER ID` FROM `ola`.`bookings`;
ALTER TABLE bookings
RENAME COLUMN `CUSTOMER ID` TO `CUSTOMER_ID`;

ALTER TABLE bookings
RENAME COLUMN `Driver Cancellation Reason` TO `Driver_Cancellation_Reason`;

ALTER TABLE bookings
RENAME COLUMN `Driver Ratings` TO `Driver_Ratings`;

ALTER TABLE bookings
RENAME COLUMN `Customer Rating` TO `Customer_Ratings`;

ALTER TABLE bookings
RENAME COLUMN `Booking Value` TO `Booking_Value`;

ALTER TABLE bookings
RENAME COLUMN `incomplete rides` TO `incomplete_rides`;

ALTER TABLE bookings
RENAME COLUMN `incomplete rides reason` TO `incomplete_rides_reason`;

ALTER TABLE bookings
RENAME COLUMN `BOOKING ID` TO `BOOKING_ID`;
SHOW COLUMNS FROM bookings;

SELECT `Booking Value` FROM `ola`.`bookings`;
ALTER TABLE bookings
RENAME COLUMN `Booking Value` TO `Booking_Value`;
SHOW COLUMNS FROM bookings;