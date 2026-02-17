--Check for nulls--
SELECT COUNT(*) AS null_stations FROM all_trips_2025 WHERE start_station_name IS NULL;

-- Check for "broken" rides (end time before start time)
SELECT COUNT(*) AS negative_rides FROM all_trips_2025 WHERE ended_at < started_at;

-- Check for "instant" rides (0 seconds)
SELECT COUNT(*) AS zero_sec_rides FROM all_trips_2025 WHERE started_at = ended_at;

--Check for nulls in endlat and endlng--
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN end_lat IS NULL OR end_lng IS NULL THEN 1 ELSE 0 END) AS null_gps_rows,
    (SUM(CASE WHEN end_lat IS NULL OR end_lng IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percent_loss
FROM all_trips_2025;

--Check for nulls in startlat and startlng--
SELECT 
    SUM(CASE WHEN start_lat IS NULL OR start_lng IS NULL THEN 1 ELSE 0 END) AS null_start_gps,
    SUM(CASE WHEN end_lat IS NULL OR end_lng IS NULL THEN 1 ELSE 0 END) AS null_end_gps
FROM all_trips_2025;

--Removing the negative, zero rides and the null end GPS rows--
DELETE FROM all_trips_2025 
WHERE ended_at <= started_at 
   OR end_lat IS NULL 
   OR end_lng IS NULL;

--Manipulation and addition of some columns--
ALTER TABLE all_trips_2025 
ADD ride_length_s INT,
    day_of_week NVARCHAR(15),
    month_name NVARCHAR(15);
--Calculate the values--
UPDATE all_trips_2025
SET ride_length_s = DATEDIFF(SECOND, started_at, ended_at),
    day_of_week = DATENAME(WEEKDAY, started_at),
    month_name = DATENAME(MONTH, started_at);

-- Fill missing start station names
UPDATE all_trips_2025
SET start_station_name = 'On-Street / No Station'
WHERE start_station_name IS NULL;

-- Fill missing end station names
UPDATE all_trips_2025
SET end_station_name = 'On-Street / No Station'
WHERE end_station_name IS NULL;

--Show Number of rows were updated with the 'On-Street' label--
SELECT 
    COUNT(CASE WHEN start_station_name = 'On-Street / No Station' THEN 1 END) AS start_on_street_count,
    COUNT(CASE WHEN end_station_name = 'On-Street / No Station' THEN 1 END) AS end_on_street_count
FROM all_trips_2025;