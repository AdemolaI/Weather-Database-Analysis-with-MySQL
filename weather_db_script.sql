-- ===================================================================
-- QUERY WEATHER DATABASE: CAT_LOCATIONS, METOFFICE_DAILYWEATHERDATA
-- PART 1
-- ===================================================================
-- Task 1. Fill records in table cat_locations where the country is null with the value "UK"
-- view country null values
SELECT *
FROM cat_locations 
WHERE Country IS NULL LIMIT 5;

-- replace null values 
UPDATE cat_locations SET Country = 'UK' WHERE Country IS NULL;

-- confirm updated country values
SELECT *
FROM cat_locations 
WHERE Country IS NULL LIMIT 5;

-- ===========================================================
-- Task 2. Delete the rows from tempw where rainfall is null
	-- check rainfall null values
SELECT *
FROM tempw 
WHERE rainfall IS NULL LIMIT 5;

	-- delete the rows with rainfall null values
DELETE FROM tempw WHERE rainfall IS NULL;

	-- confirm deleted rows
SELECT *
FROM tempw 
WHERE rainfall IS NULL LIMIT 5;
-- ==============================================================
-- Task 3. Delete the timestamp column from the table tempw schema
ALTER TABLE tempw DROP timestamp;

-- ==============================================================
-- SESSION 2
-- ==============================================================
-- Sample Task: select all fields from cat_locations where region is not "se" and other by location.
SELECT *
FROM cat_locations
WHERE Region <> 'se'
ORDER BY Location LIMIT 5;

-- Sample Task: Obtain the min, max and average latitude by region
SELECT Region, MIN(Latitude), MAX(Latitude), AVG(Latitude)
FROM cat_locations
GROUP BY Region LIMIT 5;
-- =====================================================
/*
TASKS
1. How many records are there in the table cat_locations with region description equal to Northern Ireland?
2. Which region has the highest elevation in the cat_locations table and what is this elevation?
3. What were the mean visibility, temperature, windspeed, and humidity on January 4th?
4. What is the average temperature per pressuretendency type?
5. How many records are there in the table metoffice_dailyweatherdata where winddirection is null? Why?
6. What is the average humidity in table metoffice_dailyweatherdata where temperature is between 5 and 10 degrees?
7. How many records are there in the table cat_locations where both postcode and country are NULL?
*/
-- view table
SELECT *
FROM cat_locations LIMIT 5;

-- view table
SELECT *
FROM metoffice_dailyweatherdata LIMIT 5;
-- ===========================================================
-- Task 1. How many records are there in the table cat_locations with region description equal to Northern Ireland?
SELECT region_description, COUNT(*) AS num_records
FROM cat_locations
WHERE region_description = 'Northern Ireland'
GROUP BY region_description;

-- ===========================================================
-- Task 2. Which region has the highest elevation in the cat_locations table and what is this elevation?
SELECT Region, Elevation
FROM cat_locations
ORDER BY Elevation DESC LIMIT 1;

-- ===========================================================
-- Task 3. What were the mean visibility, temperature, windspeed, and humidity on January 4th?
SELECT obs_date, AVG(visibility) as mean_visibility, AVG(temperature) as avg_temperature,
	AVG(windspeed) as avg_windspeed, AVG(humidity) as avg_humidity
FROM metoffice_dailyweatherdata
WHERE obs_date = '2020-01-04'
GROUP BY obs_date;

-- ===========================================================
-- Task 4. What is the average temperature per pressuretendency type?
SELECT pressuretendency, AVG(temperature) as avg_tempertaure
FROM metoffice_dailyweatherdata
GROUP BY pressuretendency;

-- ===========================================================
-- Task 5. How many records are there in the table metoffice_dailyweatherdata where winddirection is null? Why?
SELECT COUNT(*) as num_null
FROM metoffice_dailyweatherdata
WHERE winddirection IS NULL;
-- 0 records 

SELECT COUNT(*) as num_null
FROM metoffice_dailyweatherdata
WHERE winddirection = 'NULL';
-- 9857 records because the null value is recorded as a string.

-- ===========================================================
-- Task 6. What is the average humidity in table metoffice_dailyweatherdata where temperature is between 5 and 10 degrees?
SELECT AVG(humidity) as avg_humidity
FROM metoffice_dailyweatherdata
WHERE temperature BETWEEN '5' AND '10';

-- preview table
SELECT *
FROM metoffice_dailyweatherdata LIMIT 5;

-- ===========================================================
-- Task 7. How many records are there in the table cat_locations where both postcode and country are NULL?
SELECT COUNT(*) as num_null
FROM cat_locations
WHERE postcode IS NULL AND country IS NULL;

-- preview table
SELECT *
FROM cat_locations LIMIT 5;

-- ====================================================
-- SESSION 3
-- ====================================================
-- SAMPLE TASKS
-- EXTRACT DATA FROM MULTIPLE SOURCES -------
SELECT t1.RegionCode, t1.Region,
	t2.country_code, t2.country_name
FROM cat_regions t1, country t2 LIMIT 5;
-- -------------------------------------------
-- LEFT JOIN ---------------
SELECT daily.LocationID, loc.Location,
	loc.region_description, daily.temperature, daily.Windspeed
FROM metoffice_dailyweatherdata AS daily
LEFT JOIN cat_locations AS loc 
ON daily.LocationId = loc.LocationID LIMIT 5;
-- ----------------------------------------------
SELECT daily.LocationID, loc.Location, 
	loc.region_description, daily.temperature, daily.Windspeed
FROM metoffice_dailyweatherdata daily
LEFT JOIN cat_locations loc
ON  daily.LocationId = loc.LocationID
WHERE loc.Location IS NULL LIMIT 5;
-- -----------------------------------------------
-- INNER JOIN ------------------
-- extract records that match both tables
SELECT * 
FROM metoffice_dailyweatherdata AS daily 
WHERE locationID = 3680 LIMIT 5;

SELECT * 
FROM cat_locations 
WHERE LocationID = 3680;
-- So cat_locations does not have a record for the LocationID 3680.

-- Returning a table with the common LocationIDs
SELECT daily.LocationID, loc.Location,
	loc.region_description, daily.temperature, daily.Windspeed
FROM metoffice_dailyweatherdata AS daily
INNER JOIN cat_locations AS loc 
ON daily.LocationId = loc.LocationID LIMIT 5;

-- ========================================================
/*
Task 1
Create a new column in the table cat_locations with the name "NewDayIce". For each location, the column NewDayIce should take the value 1 if the temperature was below zero when the new year changed (2020-01-01 00:00:00), 0 otherwise. Some Hints:

▪ Start with a SELECT statement returning the negative temperatures per location (at the appropriate time).
▪ create the new column,
▪ the SELECT statement with IF to populate the new column.
*/
-- view negative temperature by location at the given time
SELECT C.LocationID, c.location, m.obs_dateTime, m.temperature
FROM cat_locations AS c
JOIN metoffice_dailyweatherdata as m
ON c.LocationID = m.LocationId
WHERE obs_dateTime = '2020-01-01 00:00:00' AND temperature < 0;

-- create the new column "NewDayIce"
ALTER TABLE cat_locations ADD NewDayIce INT;

-- insert values into the "NewDayIce" column
UPDATE cat_locations as c
SET NewDayIce = (SELECT IF(m.temperature < 0, 1, 0)
				 FROM metoffice_dailyweatherdata AS m
				 WHERE (c.LocationID = m.LocationId) 
					AND (m.obs_dateTime = '2020-01-01 00:00:00'));

-- ALTERNATIVE METHOD JOINS AND CTE
-- create a common table expression (CTE)
with tempTab AS (
SELECT c.LocationID, IF(m.temperature < 0, 1, 0) AS NewDayICE
FROM metoffice_dailyweatherdata AS m
INNER JOIN cat_locations AS c 
ON c.LocationID = m.LocationId
WHERE (m.obs_dateTime = "2020-01-01 00:00:00"))

UPDATE cat_locations AS c SET c.NewDayICE = (
	SELECT t.NewDayICE 
    FROM tempTab AS t 
    WHERE c.LocationID = t.LocationID);

-- confirm NewDayIce values on cat_locations table
SELECT LocationID, Location, NewDayIce
FROM cat_locations 
WHERE NewDayIce BETWEEN '0' AND '1' LIMIT 10;

-- ============================================================
/*
Task 2
Return a ranked list with all location names 
and the average visibility (use the appropriate JOINT).
*/
SELECT c.Location, AVG(m.visibility) AS avg_visibility
FROM cat_locations AS c
INNER JOIN metoffice_dailyweatherdata AS m
ON c.LocationID = m.LocationId
GROUP BY c.Location 
ORDER BY avg_visibility DESC LIMIT 10;

-- ===========================================================
/*
Task 3
Return all weather data for the cases when it was foggy. 
Hint check the table metoffice_dailyweatherdata and weatherType.
*/
-- check weatherType 'fog' values on table weathertype
SELECT *
FROM weathertype 
WHERE weatherType = 'fog' LIMIT 5;

-- extract all weather data for cases when it was foggy
SELECT *
FROM metoffice_dailyweatherdata AS m
LEFT JOIN weathertype AS w
ON m.weatherType = w.weatherTypeID 
WHERE w.weatherType = 'Fog' LIMIT 10;

-- ===========================================================
/*
Task 4
Find the average humidity for locations 'Baltasound', 'Lerwick (S. Screen)', 'Fair Isle'
*/
SELECT c.location, AVG(m.humidity) AS avg_humidity
FROM cat_locations AS c, metoffice_dailyweatherdata AS m
WHERE (c.LocationID = m.LocationId) AND 
	  (c.location IN('Baltasound', 'Lerwick (S. Screen)', 'Fair Isle'))
GROUP BY c.location;

-- ALTERNATIVE METHOD with JOINS
SELECT c.location, AVG(m.humidity) AS avg_humidity
FROM cat_locations AS c
INNER JOIN metoffice_dailyweatherdata AS m
ON c.LocationID = m.LocationId
WHERE (c.location IN('Baltasound', 'Lerwick (S. Screen)', 'Fair Isle'))
GROUP BY c.location;

-- ===========================================================
/*
Task 5
For the above locations in Question 4, return all different weather types
*/
-- create a CTE with the specified locations combined with the weatherType from table met...
with loc_weatherTypes AS (
SELECT c.location, m.weatherType
FROM cat_locations as c
INNER JOIN metoffice_dailyweatherdata as m
ON c.LocationID = m.LocationId
WHERE c.Location IN('Baltasound', 'Lerwick (S. Screen)', 'Fair Isle'))

-- extract weatherType from table weathertype to the CTE
SELECT DISTINCT w.weatherType
FROM loc_weatherTypes AS l
LEFT JOIN weathertype AS w
ON l.weathertype = w.weatherTypeID;

-- ALTERNATIVE METHOD
SELECT DISTINCT wt.weatherType
FROM metoffice_dailyweatherdata daily
INNER JOIN cat_locations loc ON daily.LocationId = loc.LocationID
LEFT JOIN weatherType wt ON daily.weatherType = wt.weatherTypeID
WHERE loc.Location IN ('Baltasound', 'Lerwick (S. Screen)', 'Fair Isle');

-- ===========================================================
/*
Task 6
For each weather type, return the number of 
distinct locations, that this weather type occurred.
*/
SELECT w.weatherType, COUNT(DISTINCT c.location) AS num_distinct_locations
FROM metoffice_dailyweatherdata m
INNER JOIN cat_locations c ON m.LocationId = c.LocationID
LEFT JOIN weatherType w ON m.weatherType = w.weatherTypeID
GROUP BY w.weatherType;

-- ==========================================================
-- SESSION 4
-- ==========================================================

-- SAMPLE TASKS:
/*
1. Find the average humidity and maximum visibility in Baltasound and Fair Isle 
per day using information from metoffice_dailyweatherdata and cat_location.
*/
SELECT c.location, m.obs_date, AVG(m.humidity) AS avg_humidity, MAX(m.visibility) AS max_visibility
FROM cat_locations AS c
LEFT JOIN metoffice_dailyweatherdata AS m
ON c.LocationID = m.LocationId
WHERE c.Location IN('Baltasound', 'Fair Isle')
GROUP BY c.Location, m.obs_date;
-- ------------------------------------
/*
2. Label the temperature in table metoffice_dailyweatherdata to be 
"very cold" (temperature<=0), "cold" (temperature<=10) or "normal" (temperature>10).
*/

SELECT m.temperature,
	CASE
		WHEN m.temperature <= 0 THEN 'very cold'
		WHEN m.temperature <= 10 THEN 'cold'
		ELSE 'normal'
	END
    AS temperature_categorical
FROM metoffice_dailyweatherdata AS m LIMIT 10;

-- ALTERNATIVE SOLUTION USING NESTED IIF
SELECT temperature,
  IF(temperature <= 0, 'Very cold',
        IF (temperature <= 10, 'Cold', 'Normal')
      )
  AS temperature_categorical
FROM metoffice_dailyweatherdata LIMIT 10;
-- ------------------------------------------------
/*
3. Get the number of daily windy records from table 
metoffice_dailyweatherdata with windspeed larger than 50.
*/
-- without the use of WHERE
SELECT m.obs_date, SUM(IF(m.windspeed > 50, 1,0)) AS num_windy_records 
FROM metoffice_dailyweatherdata AS m
GROUP BY m.obs_date;

-- ALTERNATIVE METHOD - with the use of WHERE
SELECT m.obs_date, COUNT(m.windy) AS num_windy_records 
FROM metoffice_dailyweatherdata AS m
WHERE m.windspeed > 50 
GROUP BY m.obs_date;

-- ---------------------------------------
/*
4. Generate daily weather descriptions based on table “weatherType” for each location ID 
in table “metoffice_dailyweatherdata”. The descriptions should be generated as:

When the weather type is exactly 'Clear night’, 'Sunny day’ or contains '%partly cloudy%’, 
the weather should be described as OK Weather;

When the weather type contains 'heavy’ or 'snow’, 
the weather should be described as Bad weather;

When the weather type contains ‘light’ or ‘Drizzle’, 
the weather should be described as Not that great weather;

All the other weathers should be described as No description
For each location, there should be how many hours last under each description.
*/
SELECT DISTINCT m.locationId,
	CASE 
		WHEN w.weatherType IN ('Clear night', 'Sunny day') 
			OR w.weatherType LIKE '%partly Cloudy%' THEN 'Ok weather'
        WHEN w.weatherType LIKE '%Heavy%' 
			OR w.weatherType LIKE '%Snow%' THEN 'Bad weather'
        WHEN w.weatherType LIKE '%light%' 
			OR w.weatherType LIKE '%Drizzle%' THEN 'Not that great weather'
		ELSE 'No description'
	END AS weather_description, COUNT(DISTINCT m.obs_time) AS number_of_hours
FROM metoffice_dailyweatherdata AS m
LEFT JOIN weathertype AS w
ON m.weatherType = w.weatherTypeID
GROUP BY m.locationId, weather_description LIMIT 10;
-- -----------------------------------------------------

/*
5. Create windy_records view that shows the number of windy records (windspeed >= 50) 
per day ordered by the number of windy records. Display and then drop the view.
*/
CREATE VIEW windy_records AS
SELECT m.obs_date, SUM(IF(m.windspeed >= 50, 1, 0)) AS num_windy_records
FROM metoffice_dailyweatherdata AS m
GROUP BY m.obs_date
ORDER BY num_windy_records DESC;
-- display view
SELECT *
FROM windy_records LIMIT 10;

-- drop view
DROP VIEW windy_records;

-- ========================================================
/*
TASK 1
Using tables metoffice_dailyweatherdata and cat_locations 
create a view called carlisle_max_temperature that 
contains the max temperature for Carlisle per time of day (morning (time <12), 
afternoon (time>=12 and time <18), evening (time >=18)). 
The resulting view should contain two columns: time_of_day (morning, afternoon, evening), 
and max_tempreture.
*/ 

CREATE VIEW carlisle_max_temperature AS
SELECT 
	CASE 
        WHEN HOUR((obs_time)) < 12 THEN 'Morning'
        WHEN HOUR((obs_time)) >= 18 THEN 'Evening'
        ELSE 'Afternoon'
	END AS time_of_day, MAX(m.temperature) AS max_temperature 
FROM cat_locations AS c
LEFT JOIN metoffice_dailyweatherdata AS m
ON c.LocationID = m.LocationId
WHERE c.Location = 'Carlisle'
GROUP BY time_of_day;

-- display view
SELECT * 
FROM carlisle_max_temperature;

-- drop view
-- DROP VIEW carlisle_max_temperature

-- ===========================================================
/*
TASK 2
Based on table metoffice_dailyweatherdata, create a view called high_pressure_percentages 
that returns how many cases on average we observed pressure above 1020 per day, 
i.e. a percentage of cases that are classified as above 1020.

Your resulting view should contain obs_date (observation date), and avg_high_pressure. 
Note that you should work on those pressures which are not null.
*/
CREATE VIEW high_pressure_percentages AS
SELECT obs_date, AVG(IF(pressure > 1020, 1, 0)) AS avg_pressure
FROM metoffice_dailyweatherdata
WHERE pressure IS NOT NULL
GROUP BY obs_date;

-- display view
SELECT *
FROM high_pressure_percentages;

-- drop view
-- DROP VIEW high_pressure_percentages;

-- ===========================================================
/*
TASK 3
Create a view called rainy_snowy that for each station returns a 0/1 flag 
if there was at least one rainy hour returns 1 otherwise 0; and one similar 
0/1 flag if there was at least one snowy hour returns 1 otherwise 0.

You need to use table metoffice_dailyweatherdata and weatherType. 
The resulting view should contain three columns: locationID, 
at_least_one_rainy_hour, and at_least_one_snowy_hour.
*/
CREATE VIEW rainy_snowy AS
SELECT m.LocationId, 
	   MAX(CASE
		   WHEN w.weatherType LIKE '%rain%' THEN 1
           ELSE 0
	   END) AS at_least_one_rainy_hour,
       MAX(CASE
		   WHEN w.weatherType LIKE '%snow%' THEN 1
           ELSE 0
	   END) AS at_least_one_snowy_hour
FROM metoffice_dailyweatherdata AS m
INNER JOIN weathertype AS w
ON m.weatherType = w.weatherTypeID
GROUP BY m.LocationId;

-- ALTERNATIVE METHOD USING IF STATEMENT
CREATE VIEW rainy_snowy AS
  SELECT
    MAX( IIF(wt.weatherType LIKE '%rain%', 1, 0) ) AS at_least_one_rainy_hour,
    MAX( IIF(wt.weatherType LIKE '%snow%', 1, 0) ) AS at_least_one_snowy_hour,
    daily.LocationID
FROM
    metoffice_dailyweatherdata daily
INNER JOIN
    weatherType wt ON daily.weatherType = wt.weatherTypeID
GROUP BY daily.LocationID;
SELECT * from rainy_snowy limit 10;

-- display view
SELECT *
FROM rainy_snowy LIMIT 10;

-- drop view
DROP VIEW rainy_snowy;

-- ===========================================================
/*
TASK 4
Create a view called snow_weather_station_counts which counts the number of 
weather stations that had at least one snowy hour vs none. 
You need to work on the view created in exercise 3. 
The resulting view should contain two columns snow_counts and number_of_locations.
*/
CREATE VIEW snow_weather_station_counts AS
SELECT 
	  CASE
		  WHEN at_least_one_snowy_hour >= 1 THEN 'At least one snowy hour'
          ELSE 'No snowy hours'
          END AS snow_counts,
	  COUNT(DISTINCT LocationId) AS number_of_locations
FROM rainy_snowy
GROUP BY snow_counts;

-- display view
SELECT *
FROM snow_weather_station_counts LIMIT 10;

-- drop view
DROP VIEW snow_weather_station_counts;

-- ===========================================================
/*
TASK 5
Create a view known as rain_or_snow_weather_station that can:

Give the weather categories based on weather rainy or snowy.
If there is no snowy or rainy hours the weather category should be set as "No rain or snow".
Otherwise, the weather category should be set as "Either rain or snow".
For each weather category, count the number of weather stations. 
Please working on the view obtained from exercise 3. 
The resulting view should contain two columns: 
“weather_categorisation” and “number_of_stations”.
*/

CREATE VIEW rain_or_snow_weather_station AS
SELECT 
	   CASE
		   WHEN at_least_one_rainy_hour = 1 
			   OR at_least_one_snowy_hour = 1 THEN 'Either rain or snow'
           ELSE 'No rain or snow'
	   END AS weather_categorisation,
	   COUNT(DISTINCT LocationId) AS number_of_stations
FROM rainy_snowy
GROUP BY weather_categorisation;

-- display view
SELECT *
FROM rain_or_snow_weather_station LIMIT 10;

-- drop view
DROP VIEW rain_or_snow_weather_station;

-- ==================================================
-- SESSION 5
-- ==================================================
-- Sample Tasks:
/*
1. Working on the table “metoffice_dailyweatherdata”, converting the 
temperature from Celsius to Fahrenheit. 
The output should contain one column with name “Fahrenheit_temperature”.
*/
SELECT temperature * 1.8 + 32 AS Fahrenheit_temperature
FROM metoffice_dailyweatherdata LIMIT 15;

-- ------------------------------------
/*
2. Working on the table metoffice_dailyweatherdata, Picking out those records with 
either visibility smaller than 2000 or windspeed larger than 20.
*/
SELECT * 
FROM metoffice_dailyweatherdata
WHERE visibility < 2000 OR windspeed > 20 LIMIT 5;

-- -------------------------------------
/*
3. Working on the table metoffice_dailyweatherdata, 
picking out those records with the temperature beyond the range of [-1, 11].
*/
SELECT *
FROM metoffice_dailyweatherdata
WHERE temperature NOT BETWEEN -1 AND 11 LIMIT 5;

-- ------------------------------------
/*
4. Working on the table metoffice_forecast_text, return all the records with an added column
check_for_digits. The new column check_for_digits returns an 0, 1 
flag for whether the text in the “forecastText” contains one or more digits.
*/
SELECT *, forecastText REGEXP '[0-9]' AS check_for_digits
FROM metoffice_forecast_text LIMIT 5;

-- ----------------------------------------
/*
5. Working on the metoffice_dailyweatherdata. Return a resulting table with two columns: 
one column contains all the windspeed, another one known as 
max_wind contains the maximum windspeed computed from this table.
*/
SELECT windspeed, (SELECT MAX(windspeed) 
	   FROM metoffice_dailyweatherdata) AS max_wind
FROM metoffice_dailyweatherdata LIMIT 10;

-- ----------------------------------
/*
6. Working on the table metoffice_dailyweatherdata. For each locationID, 
compute the maximum temperature (max_temperature). Based on this result, 
filtering those locationIDs and maximum temperatures with max_temperature larger than 10.
*/
SELECT *
FROM (SELECT LocationId, MAX(temperature) AS max_temperature
	  FROM metoffice_dailyweatherdata
      GROUP BY LocationId) AS loc_max_temp
WHERE max_temperature > 10 LIMIT 10;

-- -----------------------------------------
/*
7. Working on tables zones and timezone. Picking out records from zones 
whose zone_id are within the range of unique zone_id numbers in table timezone.
*/
SELECT *
FROM zones
WHERE zone_id IN(SELECT DISTINCT zone_id
				 FROM timezone) LIMIT 10;

-- ===========================================================
/*
TASK 1
Working on the table “cat_locations”. Picking out all the records with 
“Latitude” smaller than those records with location to be “London”.
*/
SELECT *
FROM cat_locations
WHERE Latitude < (SELECT Latitude
				  FROM cat_locations
                  WHERE Location = 'London') LIMIT 10;

-- ===========================================================
/*
TASK 2
Working on the table metoffice_dailyweatherdata. 
Return a resulting table that contain 5 columns: 
LocationID, obs_datetime, temperature, windspeed, and windchill.

The first four columns can be taken from metoffice_dailyweatherdata directly. 
The windchill should computed following from the formula below:
Windchill  =  13.12+0.6215×Temperature−11.37×(WindSpeed)0.16+0.3965×Temperature×Windspeed0.16  
Note: The function for x raised to the power of y,  xy , is POW(x,y)
*/
SELECT LocationId, obs_datetime, temperature, windspeed,
	   (13.12 + 0.6215 * Temperature - 11.37 * POW(WindSpeed,0.16) 
       + 0.3965 * Temperature * POW(Windspeed,0.16)) AS windchill
FROM metoffice_dailyweatherdata LIMIT 10;

-- ===========================================================
/*
TASK 3
Working on the table "zones". Find out those zone names (zone_name) which contain 
more than two details (delimited by /). Examples records: America/Indiana/Marengo
*/
SELECT zone_name
FROM zones
WHERE zone_name REGEXP '[_a-zA-Z_]+/[_a-zA-Z_]+/';

-- ALTERNATIVE METHOD
SELECT zone_name
FROM (SELECT zone_name,
      zone_name REGEXP  '^[_a-zA-Z]+/[_a-zA-Z]+/'
        AS checkup
      FROM zones)
WHERE checkup = 1;

-- ===========================================================
/*
TASK 4
Working on the table “metoffice_dailyweatherdata”. 
Return one column which computes the difference between 
temperature and the average temperature. (temperature minus the average temperature)
*/
SELECT temperature - (SELECT AVG(temperature)
					  FROM metoffice_dailyweatherdata) AS temp_dev
FROM metoffice_dailyweatherdata LIMIT 10;

-- ============================================================

-- view table
SELECT * 
FROM weathertype LIMIT 5;

-- view table
SELECT *
FROM metoffice_dailyweatherdata LIMIT 5;

-- view table
SELECT * 
FROM cat_locations LIMIT 5;