OLASQL — OLA Ride Bookings Analysis (SQL + Power BI)

Hi, I'm Anshika 

This repository contains my end-to-end data analysis project on 20,000+ OLA ride booking records. 

Instead of just running basic SQL queries, I wanted to use SQL and Power BI to solve real business problems that ride-hailing companies deal with daily—like understanding why rides get canceled, figuring out which vehicles generate the most revenue, and tracking demand spikes across peak hours.



 What’s Inside?

This project breaks down operational ride data across four main areas:

1. Cancellation Trends: Analyzing why rides get canceled (customer vs. driver reasons) and finding the primary pain points.
2. Revenue Distribution: Looking at which vehicle types (Auto, Prime Sedan, Mini, Bike, etc.) make up the bulk of earnings.
3. Peak-Hour Patterns: Identifying time slots and days with highest booking density to understand demand curves.
4. Payment Preferences: Mapping out how customers prefer to pay (UPI, Cash, Credit/Debit Card).

---

 Tools Used

SQL (MySQL): Data cleaning, filtering, CTEs, aggregation, and analytical queries.
Power BI: Building an interactive dashboard with custom measures (DAX) and dynamic visuals.
Excel: Initial data check and inspection.



 Key Questions Explored

Here are a few of the core questions addressed using SQL scripts and Power BI visuals:

 What percentage of total booking attempts end up canceled, and who cancels them more often—drivers or riders?
 What is the total revenue and average trip distance per vehicle category?
 What are the top 5 hours of the day when ride demand peaks?
 What is the revenue share across UPI vs. Cash vs. Card payments?
 Who are the top high-value customers driving repeat business?


 SQL Query Examples

Here is a snippet of how I structured some of the analytical queries in the project:

 1. Revenue & Average Distance by Vehicle Type
```sql
SELECT 
    vehicle_type,
    SUM(booking_value) AS total_revenue,
    ROUND(AVG(ride_distance), 2) AS avg_distance_km
FROM bookings
WHERE booking_status = 'Success'
GROUP BY vehicle_type
ORDER BY total_revenue DESC;
