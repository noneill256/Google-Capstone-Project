-- Deleted multiple unnecessary columns in Excel
-- and also deleted the restaurants that had permanently closed.

-- Deleted restaurants with missing country values in Excel.

-- Load in data to SQL
CREATE TABLE public.veggie_data
(
    name varchar(255),
	id varchar(255),
    address varchar(255),
    categories varchar(300),
    primaryCategories varchar(255),
    city varchar(100),
    country varchar(5),
    cuisine varchar(200),
    isClosed boolean,
    latitude double precision,
    longitude double precision,
    menus_category varchar(255)
);

foodStudy=# \copy veggie_data FROM 'C:\users\noah\coding\food_study\data\Vegetarian_and_Vegan_Restaurants.csv' DE
LIMITER ',' CSV HEADER;


-- The original data set has one row for every menu item; thus, restaurants are repeated.
-- Thus, we just want to filter it down to one restaurant for every row.
CREATE TABLE veggie_restaurants AS (
	SELECT name,
	id,
	address,
	categories,
	primarycategories,
	city,
	country,
	cuisine,
	isclosed,
	latitude,
	longitude
FROM veggie_data
GROUP BY name, id, address, categories, 
    primarycategories, city, country, cuisine, isclosed, latitude, longitude)

-- Many of the rows in this set are actually health food stores instead of restaurants;
-- those will be deleted.
DELETE FROM veggie_restaurants
WHERE primarycategories != 'Accommodation & Food Services'

-- Check for illogical geographical data; output none
SELECT * FROM veggie_restaurants
WHERE (-90 > latitude) OR (latitude > 90)

SELECT * FROM veggie_restaurants
WHERE (-180 > longitude) OR (longitude > 180)

-- Adding the full state name to join with the population data in later analysis
CREATE TABLE veggie_restaurants_full AS (
	SELECT v.*, cs.state_full FROM veggie_restaurants AS v
	JOIN cities_states AS cs
		ON v.state = cs.state_short
	)