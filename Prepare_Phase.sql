/* This creates your master table for the entire year of 2025 */
SELECT * INTO all_trips_2025
FROM (
    SELECT * FROM Jan_2025
    UNION ALL
    SELECT * FROM Feb_2025
    UNION ALL
    SELECT * FROM Mar_2025
    UNION ALL
    SELECT * FROM Apr_2025
    UNION ALL
    SELECT * FROM May_2025
    UNION ALL
    SELECT * FROM June_2025
    UNION ALL
    SELECT * FROM Jul_2025
    UNION ALL
    SELECT * FROM Aug_2025
    UNION ALL
    SELECT * FROM Sep_2025
    UNION ALL
    SELECT * FROM Oct_2025
    UNION ALL
    SELECT * FROM Nov_2025
    UNION ALL
    SELECT * FROM Dec_2025
) AS yearly_data;

-- Check Total Row Count--
SELECT COUNT(*) FROM all_trips_2025;
--Show top 100 rows--
SELECT TOP 100 * FROM all_trips_2025;

--Checking for any duplicate ride_id--
SELECT ride_id, COUNT(*)
FROM all_trips_2025
GROUP BY ride_id
HAVING COUNT(*) > 1;

--to lock ride_id as primary key--
ALTER TABLE all_trips_2025
ALTER COLUMN ride_id NVARCHAR(50) NOT NULL; -- Primary keys cannot be empty (NULL)

ALTER TABLE all_trips_2025
ADD PRIMARY KEY (ride_id);
