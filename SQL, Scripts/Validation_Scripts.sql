/*
1) How many accidents occurred in NYC, Austin and Chicago?
*/

-- Dimension Model Data Count

SELECT COUNT(*), l.City FROM fact_accidents a
LEFT JOIN dim_location l ON a.[Location] = l.SK_Dim_Location
GROUP BY l.city

--Pre Staging Data Count

SELECT COUNT(*) FROM pre_stg_austin
SELECT COUNT(*) FROM pre_stg_chicago
SELECT COUNT(*) FROM pre_stg_nyc


/*
2) Which areas in the 3 cities had the greatest number of accidents
*/

SELECT TOP(3) loc.Street_Address, COUNT(*) as Number_of_Accidents 
FROM fact_accidents AS acc
JOIN dim_location AS loc ON acc.[Location] = loc.SK_Dim_Location
WHERE loc.City like 'NYC' and loc.Street_Address not like 'NOT MENTIONED'
GROUP BY loc.Street_Address
ORDER BY COUNT(*) DESC

SELECT TOP(3) loc.Street_Address, COUNT(*) as Number_of_Accidents 
FROM fact_accidents AS acc
JOIN dim_location AS loc ON acc.[Location] = loc.SK_Dim_Location
WHERE loc.City like 'Chicago'
GROUP BY loc.Street_Address
ORDER BY COUNT(*) DESC

SELECT TOP(3) loc.Street_Address, COUNT(*) as Number_of_Accidents 
FROM fact_accidents AS acc
JOIN dim_location AS loc ON acc.[Location] = loc.SK_Dim_Location
WHERE loc.City like 'Austin'
GROUP BY loc.Street_Address
ORDER BY COUNT(*) DESC


/*
3) How many accidents resulted in just injuries?
*/

--Overall

WITH Overall AS(
SELECT 
    SUM(CASE WHEN Flag_Just_Injuries = 1 THEN 1 ELSE 0 END) AS Not_Present,
    SUM(CASE WHEN Flag_Just_Injuries = 2 THEN 1 ELSE 0 END) AS Present,
    SUM(CASE WHEN Flag_Just_Injuries = 3 THEN 1 ELSE 0 END) AS Not_Mentioned
FROM fact_accidents
)
Select Not_Present , Present, Not_Mentioned,
Not_Present + Present + Not_Mentioned AS Total_Accidents FROM Overall;

--City

WITH Citywise AS(
SELECT 
	loc.City AS City,
    SUM(CASE WHEN acc.Flag_Just_Injuries = 1 THEN 1 ELSE 0 END) AS Not_Present,
    SUM(CASE WHEN acc.Flag_Just_Injuries = 2 THEN 1 ELSE 0 END) AS Present,
    SUM(CASE WHEN acc.Flag_Just_Injuries = 3 THEN 1 ELSE 0 END) AS Not_Mentioned
FROM fact_accidents acc
JOIN dim_location loc ON acc.[Location] =  loc.SK_Dim_Location
GROUP BY loc.City
)
Select City, Not_Present , Present, Not_Mentioned,
Not_Present + Present + Not_Mentioned AS Total_Accidents FROM Citywise;


/*
4) How often are pedestrians involved in accidents
*/

WITH Overall AS(
SELECT 
    SUM(CASE WHEN Pedestrian_Flag = 1 THEN 1 ELSE 0 END) AS Not_Present,
    SUM(CASE WHEN Pedestrian_Flag = 2 THEN 1 ELSE 0 END) AS Present,
    SUM(CASE WHEN Pedestrian_Flag = 3 THEN 1 ELSE 0 END) AS Not_Mentioned
FROM fact_accidents
)
Select Not_Present , Present, Not_Mentioned,
Not_Present + Present + Not_Mentioned AS Total_Accidents FROM Overall;

--City

WITH Citywise AS(
SELECT 
	loc.City AS City,
    SUM(CASE WHEN acc.Pedestrian_Flag = 1 THEN 1 ELSE 0 END) AS Not_Present,
    SUM(CASE WHEN acc.Pedestrian_Flag = 2 THEN 1 ELSE 0 END) AS Present,
    SUM(CASE WHEN acc.Pedestrian_Flag = 3 THEN 1 ELSE 0 END) AS Not_Mentioned
FROM fact_accidents acc
JOIN dim_location loc ON acc.[Location] =  loc.SK_Dim_Location
GROUP BY loc.City
)
Select City, Not_Present , Present, Not_Mentioned,
Not_Present + Present + Not_Mentioned AS Total_Accidents FROM Citywise;

/*
5) When do most accidents happen (Seasonality Analysis)
*/

SELECT dt.Season, COUNT(*) AS Accident_Cnt
FROM fact_accidents as acc
JOIN dim_date AS dt ON acc.Crash_Date = dt.SK_Dim_Date
GROUP BY  dt.Season
ORDER BY 2 DESC

/*
6) How many motorists are injured or killed in accidents
*/

--Overall

SELECT
	SUM(Motorist_Injuries) AS Total_Motorist_Injuries,
	SUM(Motorist_Deaths) AS Total_Motorist_Deaths
FROM fact_accidents;

--Citywise

SELECT
	loc.City,
	SUM(Motorist_Injuries) AS Total_Motorist_Injuries,
	SUM(Motorist_Deaths) AS Total_Motorist_Deaths
FROM fact_accidents acc
JOIN dim_location loc ON acc.[Location] =  loc.SK_Dim_Location
GROUP BY loc.City;


/*
7) Which top 5 areas in 3 cities have the most fatal number of accidents
*/

WITH Citywise AS(
SELECT 
	loc.City as City,
	loc.Street_Address AS Area,
    SUM(CASE WHEN acc.Flag_Just_Deaths = 1 THEN 1 ELSE 0 END) AS Non_Fatal,
    SUM(CASE WHEN acc.Flag_Just_Deaths = 2 THEN 1 ELSE 0 END) AS Fatal
FROM fact_accidents acc
JOIN dim_location loc ON acc.[Location] =  loc.SK_Dim_Location
GROUP BY loc.Street_Address, loc.City
)
SELECT TOP(5) City, Area, Fatal , Non_Fatal
FROM Citywise
WHERE Area not like 'NOT MENTIONED'
ORDER BY 3 DESC;

/*
8) Time based analysis of accidents
*/

--Time of Day
SELECT
    dt.TimeOfDay as Time_Of_Day,
    COUNT(*) AS Accident_Count
FROM fact_accidents fa
JOIN dim_time dt ON fa.Crash_Time = dtime.SK_Time
GROUP BY dt.TimeOfDay;

--Day of Week
SELECT
    dt.Day_Str,
    COUNT(*) AS Accident_Count
FROM fact_accidents fa
JOIN dim_date dt ON fa.Crash_Date = dt.SK_Dim_Date
GROUP BY dt.Day_Str;

--Is Weekend
SELECT
    CASE WHEN dt.is_weekend = 'Y' THEN 'Weekend' ELSE 'Weekday' END AS Day_Type,
    COUNT(*) AS Accident_Count
FROM fact_accidents fa
JOIN dim_date dt ON fa.Crash_Date = dt.SK_Dim_Date
GROUP BY dt.is_weekend;


/*
9) Fatality analysis
*/

SELECT
    'Pedestrians' AS Victim_Type,
    SUM(Pedestrian_Deaths) AS Deaths
FROM fact_accidents
UNION ALL
SELECT
    'Road_Users' AS Victim_Type,
    SUM(Motorist_Deaths) + SUM(Micromobility_Deaths) AS Deaths
FROM fact_accidents;


/*
Number of incidents that involved more than 2 vehicles
*/
SELECT
    dloc.City,
    COUNT(fa.SK_Fact_Accidents) AS More_Than_2_Vehicles
FROM fact_accidents fa
JOIN dim_location dloc ON fa.Location = dloc.SK_Dim_Location
JOIN fact_vehicle fv ON fa.SK_Fact_Accidents = fv.SK_Fact_Accidents
JOIN dim_vehicle_type dvt ON fv.SK_Vehicle_Type = dvt.SK_Dim_Vehicle_Type
WHERE dloc.City IN ('NYC', 'Austin')
GROUP BY dloc.City
HAVING COUNT(DISTINCT dvt.Vehicle_Type) > 2;

/*
11) What are the most common factors involved in accidents
*/

SELECT TOP(10)
    dcf.[description],
    COUNT(fcf.SK_Fact_Contributing_Factor) AS FactorCount
FROM 
    fact_contributing_factor fcf
JOIN 
    dim_contributing_factor dcf
    ON fcf.SK_Contributing_Factor = dcf.SK_Contributing_Factor
	WHERE dcf.[description] NOT IN ('other', 'UNABLE TO DETERMINE')
GROUP BY 
    dcf.[description]
ORDER BY 
    FactorCount DESC;
