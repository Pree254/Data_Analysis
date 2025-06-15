SHOW DATABASES;
-- Create tables without foreign keys
CREATE DATABASE global_analysis;
USE global_analysis;

-- DROP DATABASE IF EXISTS global_analysis;

-- Create tables without foreign keys
CREATE TABLE IF NOT EXISTS gdp_2020 (
    Country VARCHAR(100) PRIMARY KEY,
    Nominal_gdp_per_capita DECIMAL(15,3) NOT NULL,
    PPP_gdp_per_capita DECIMAL(15,3) NOT NULL,
    GDP_growth_percentage DECIMAL(5,3),
    Rise_fall_GDP VARCHAR(100)
);
CREATE TABLE IF NOT EXISTS covid_19 (
    Country VARCHAR(100) PRIMARY KEY,
    Confirmed INT NOT NULL,
    Deaths INT NOT NULL,
    Recovered INT NOT NULL,
    Active INT NOT NULL,
    New_cases INT,
    New_deaths INT,
    New_recovered INT,
    WHO_Region VARCHAR(50)
);

-- Load GDP data
LOAD DATA INFILE '/var/lib/mysql-files/gdp_2020.csv'
INTO TABLE gdp_2020
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT *
FROM covid_19
LIMIT 5;

SELECT *
FROM gdp_2020
LIMIT 5;

-- Clean up non-matching countries from covid_19 table
-- This ensures only countries present in gdp_2020 remain in covid_19
SET SQL_SAFE_UPDATES = 0;
DELETE FROM covid_19 
WHERE Country NOT IN (SELECT Country FROM gdp_2020);

-- Add the foreign key constraint after data is loaded
ALTER TABLE covid_19
ADD CONSTRAINT fk_covid_country
FOREIGN KEY (Country) REFERENCES gdp_2020(Country)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Task 3
--
SELECT 
    Country,
    Confirmed,
    Deaths,
    ROUND((Deaths * 100.0 / Confirmed), 2) AS death_rate_percentage
FROM 
    covid_19
WHERE 
    WHO_Region = 'Europe'
    AND Confirmed > 10000
ORDER BY 
    death_rate_percentage DESC;
    
-- TASK 4
-- Country names,GDP growth percentage and Covid death counts for countries that experienced a GDP fall showing the worst affected first.
    SELECT
		g.Country,
        g.GDP_growth_percentage,
        c.Deaths
    FROM
        gdp_2020 g
	JOIN
        covid_19  c ON g.Country = c.Country
	WHERE
		g.GDP_growth_percentage <0
    ORDER BY 
        g.GDP_growth_percentage ASC;
        
        
        DESCRIBE gdp_2020;
        DESCRIBE covid_19;
        
        
    -- Task 5: Covid deaths Vs gdp per capita
-- First, get the top 10% of GDP per capita

WITH ranked_gdp AS (
    SELECT 
        Country, 
        PPP_gdp_per_capita,
        NTILE(10) OVER (ORDER BY PPP_gdp_per_capita DESC) AS gdp_percentile
    FROM gdp_2020
),
-- Next, we write a query to get the top 10% of covid deaths
ranked_deaths AS (
    SELECT 
        Country, 
        Deaths,
        NTILE(10) OVER (ORDER BY Deaths DESC) AS death_percentile
    FROM covid_19
),
-- Then we get countries in the top 10% of gdp per capita
top_gdp AS (
    SELECT Country 
    FROM ranked_gdp
    WHERE gdp_percentile = 1
),
-- We are getting contries in te top 10% on covid deaths
top_deaths AS (
    SELECT Country 
    FROM ranked_deaths
    WHERE death_percentile = 1
),
-- Countries that are in either of the two; but not in both.
either_but_not_both AS (
        SELECT Country FROM top_gdp
        WHERE Country NOT IN (SELECT country FROM top_deaths)
    UNION
        SELECT Country FROM top_deaths
        WHERE Country NOT IN (SELECT country FROM top_gdp)
)
SELECT * 
FROM either_but_not_both;

-- Task 6:  The AVE, MIN & MAX GDP growth %age from WHO regions with more than 5 countries. 

USE global_analysis;

 SELECT 
    c.WHO_Region,
    COUNT(*) AS country_count,
    AVG(g.GDP_growth_percentage) AS avg_growth,
    MIN(g.GDP_growth_percentage) AS min_growth,
    MAX(g.GDP_growth_percentage) AS max_growth
FROM 
    gdp_2020 g
JOIN 
    covid_19 c ON g.Country = c.Country
WHERE 
    g.GDP_growth_percentage IS NOT NULL
GROUP BY 
    c.WHO_Region
HAVING 
    COUNT(*) > 5;	
	
-- Task 7. Economic impact score for 10 most impacted    
SELECT 
    c.Country,
    c.Deaths,
    g.GDP_growth_percentage,
    ROUND((c.Deaths * ABS(g.GDP_growth_percentage)) / 1000, 2) AS economic_impact_score
FROM 
    covid_19 c
JOIN 
    gdp_2020 g ON c.Country = g.Country
WHERE 
    c.Deaths IS NOT NULL 
    AND g.GDP_growth_percentage IS NOT NULL
ORDER BY 
    economic_impact_score DESC
LIMIT 10; 


-- Task 8 ; Countries with GDP growth data but missing COVID data

USE global_analysis;
-- countries with GDP growth data but missing COVID data
SELECT g.Country
FROM gdp_2020 g
LEFT JOIN covid_19 c ON g.Country = c.Country
WHERE c.Country IS NULL;
-- insrting placeholder covid records 
INSERT INTO covid_19 (
    Country, 
    Deaths, 
    Confirmed, 
    Recovered,
    Active,
    New_Cases,
    New_Deaths,
    New_Recovered,
    WHO_Region
)
SELECT 
    g.Country,
    0 AS Deaths,
    0 AS Confirmed,
    0 AS Recovered,
    0 AS Active,
    0 AS New_Cases,
    0 AS New_Deaths,
    0 AS New_Recovered,
    
    'Unknown' AS WHO_Region
FROM gdp_2020 g
LEFT JOIN covid_19 c ON g.Country = c.Country
WHERE c.Country IS NULL;

SELECT g.Country AS GDP_Country
FROM gdp_2020 g
LEFT JOIN covid_19 c 
  ON TRIM(LOWER(g.Country)) = TRIM(LOWER(c.Country))
WHERE c.Country IS NULL;
		
        
        
INSERT INTO covid_19 (
    Country, 
    Deaths, 
	Confirmed, 
    Recovered, 
    WHO_Region
)
SELECT 
    g.Country,
    0 AS Deaths,
    0 AS Confirmed,
    0 AS Recovered,
    'Unknown' AS WHO_Region
FROM gdp_2020 g
WHERE NOT EXISTS (
    SELECT 1 
    FROM covid_19 c 
    WHERE TRIM(LOWER(c.Country)) = TRIM(LOWER(g.Country))
);

--  Rich countries were not shielded from death tolls or economic decline.

-- Health and economic crises go hand in hand because Poor COVID responses damaged economies further.

-- Data gaps matter: Missing data undermines fair international comparisons and responses.

-- Regional differences: WHO region analysis reveals that recovery paths must be tailored — there's no one-size-fits-all strategy
