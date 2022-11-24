-- CREATING AND LOADING IN THE RESTAURANT TABLE FOR CLEANING IN SQL

-- The 'websites' column in the original dataset was deleted in Excel, 
-- as it wouldn't be necessary for this study.
CREATE TABLE public.fastfood
(
    address varchar(255),
    city varchar(255),
    country varchar(5),
    keys varchar(255),
    latitude double precision,
    longitude double precision,
    name varchar(255),
    postalCode varchar(20),
    province varchar(15)
);

foodStudy=# \copy fastfood FROM 'C:\users\noah\coding\food_study\fastfoodrestaurants.csv' DELIMITER ',' CSV HEADER;


-- CLEANING

-- The use of upper- and lowercase letters in the restaurants' names are inconsistent 
-- and need to be fixed by making all the names uppercase.
UPDATE fastfood
SET name = UPPER(name);

-- The use of special characters like periods and commas are inconsistent and need to
-- be fixed by removing all such characters.
UPDATE fastfood
SET name =  replace(name, '''', '');

UPDATE fastfood
SET name =  replace(name, '.', '');

-- Miscellaneous cleaning with the same restaurants having different name values
UPDATE fastfood
SET name = 
	CASE
		WHEN name = 'MC DONALDS' THEN 'MCDONALDS'
        WHEN name LIKE 'MCDONALD%' THEN 'MCDONALDS'
		WHEN name = 'BACK YARD BURGERS' THEN 'BACKYARD BURGERS'
		WHEN name LIKE 'A&W%' THEN  'A&W ALL-AMERICAN FOOD'
        WHEN name = 'BURGER KING SALOUS' THEN 'BURGER KING'
        WHEN name LIKE 'PAPA JOHN%' THEN 'PAPA JOHNS PIZZA'
        WHEN name LIKE 'SUBWAY%' THEN 'SUBWAY'
        WHEN name LIKE 'BLIMPIE%' THEN 'BLIMPIE'
        WHEN name LIKE 'BRAUMS%' THEN 'BRAUMS ICE CREAM & DAIRY STORE'
        WHEN name LIKE 'CAPTAIN DS%' THEN 'CAPTAIN DS SEAFOOD'
        WHEN name LIKE 'CHECKERS%' THEN 'CHECKERS'
        WHEN name LIKE 'CHICK-FIL-A%' THEN 'CHICK-FIL-A'
        WHEN name LIKE 'COOK%' THEN 'COOK OUT'
        WHEN name LIKE 'COUSINS SUBS%' THEN 'COUSINS SUBS'
        WHEN name LIKE 'DAIRY QUEEN%' THEN 'DAIRY QUEEN'
        WHEN name LIKE 'GREAT STEAK%' THEN 'GREAT STEAK'
        WHEN name = 'HOME TOWN BUFFET' THEN 'HOMETOWN BUFFET'
        WHEN name LIKE 'JIMMY JOHNS%' THEN 'JIMMY JOHNS'
        WHEN name LIKE 'KFC -%' THEN 'KFC'
        WHEN name LIKE 'KUM%' THEN 'KUM & GO'
        WHEN name LIKE 'POPEYES%' THEN 'POPEYES CHICKEN'
        WHEN name LIKE 'QUIZNOS%' THEN 'QUIZNOS'
        WHEN name LIKE 'RALLYS%' THEN 'RALLYS'
        WHEN name = 'RUBIOS' THEN 'RUBIOS COASTAL GRILL'
        WHEN name = 'SONIC' OR name LIKE 'SONIC DRIVE%' THEN 'SONIC DRIVE-IN'
        ELSE name
	END;
	

-- Check for any incorrect country values; output none
SELECT country FROM fastfood
WHERE country != 'US';

-- Check for any values out of a logical range; output none
WHERE -90 > latitude OR latitude > 90;

SELECT * FROM fastfood
WHERE -180 > longitude OR longitude > 180;


-- Filter out large chains only (chains with more than 10 locations)
-- Create a table only consisting of the names of large chains
CREATE TABLE largechains AS (
	SELECT name, count(*)
	FROM fastfood
	GROUP BY name
	HAVING COUNT(*) > 10
	ORDER BY count(*) DESC
	);
-- Join with the main fast food table, dropping restaurants with not enough locations
CREATE TABLE filteredfastfood AS 
	(SELECT ff.* FROM fastfood AS ff
	JOIN largechains AS lc
	ON ff.name = lc.name);

-- add primary key
ALTER TABLE veggie_restaurants_full ADD COLUMN id SERIAL PRIMARY KEY;