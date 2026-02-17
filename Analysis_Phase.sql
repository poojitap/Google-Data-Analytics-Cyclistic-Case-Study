/* PHASE 3: ANALYZE - Descriptive Statistics
Goal: Compare the trip behavior of 'Members' vs 'Casual' riders.
- We use CAST(ride_length_s AS BIGINT) to handle the 5.5M+ rows without arithmetic overflow.
- We calculate average duration, trip boundaries (min/max), and total trip volume.
*/

SELECT 
    member_casual, 
    AVG(CAST(ride_length_s AS BIGINT)) / 60 AS avg_ride_minutes,
    MIN(ride_length_s) AS shortest_ride_s,
    MAX(ride_length_s) / 3600 AS longest_ride_hours,
    COUNT(*) AS total_trips
FROM all_trips_2025
GROUP BY member_casual;

--sanity check for 24hr rides--
SELECT 
    member_casual, 
    COUNT(*) AS count_of_24hr_rides
FROM all_trips_2025
WHERE ride_length_s >= 86400 -- 24 hours in seconds
GROUP BY member_casual;

/* ANALYSIS: Behavioral Differences by Day of Week
Purpose: Determine if user behavior changes based on the day of the week.
- Helps identify "Commuter" patterns (high weekday volume) vs "Leisure" patterns (high weekend volume).
- Calculates total trips and average duration (minutes) for each day to pinpoint marketing opportunities.
*/
SELECT 
    member_casual, 
    day_of_week, 
    AVG(CAST(ride_length_s AS BIGINT)) / 60 AS avg_ride_minutes, 
    COUNT(*) AS total_trips
FROM all_trips_2025
GROUP BY member_casual, day_of_week
ORDER BY member_casual, total_trips DESC;

--see trends of month--
SELECT 
    member_casual, 
    month_name, 
    COUNT(*) AS total_trips,
    AVG(CAST(ride_length_s AS BIGINT)) / 60 AS avg_ride_minutes
FROM all_trips_2025
GROUP BY member_casual, month_name
ORDER BY member_casual, total_trips DESC;

/* ANALYSIS: Top 10 Stations for Casual Riders
Purpose: Identify physical locations for marketing posters/pop-ups.
- Filters for 'casual' riders only.
- Excludes 'On-Street' or NULL stations to ensure we only see physical docks.
*/

SELECT TOP 10 
    start_station_name, 
    COUNT(*) AS total_trips
FROM all_trips_2025
WHERE member_casual = 'casual' 
  AND start_station_name IS NOT NULL 
  AND start_station_name NOT LIKE '%On-Street%'
  AND start_station_name NOT LIKE '%no station%'
GROUP BY start_station_name
ORDER BY total_trips DESC;