-- creación de base de datos

CREATE DATABASE old_business;

-- selección de la base con la cual trabajaré

USE old_business;

-- creación de tablas

CREATE TABLE business (
	name VARCHAR (100) primary key not null,
    year_founded INT not null,
    category_code VARCHAR (10) not null,
    country_code VARCHAR (10) not null
);

CREATE TABLE categories (
    category_code VARCHAR (10) primary key not null,
    category VARCHAR (100) not null
);

CREATE TABLE countries (
    country_code VARCHAR (10) primary key not null,
    country TEXT (100) not null,
    continent TEXT (100) not null
);

-- validación de la migración

SELECT *
FROM categories;

SELECT *
FROM countries;

SELECT *
FROM business;

SELECT COUNT(*)
FROM business;

-- Pregunta (1) Seleccionar la empresa más antigua y la más nueva existente en la tabla Business
-- Question (1) Select the oldest and newest founding years from the Business table

SELECT x.oldest_business, (select name from business where year_founded = x.oldest_business) as old_name,
       x.newest_business, (select name from business where year_founded = x.newest_business) as new_name
FROM (
    SELECT min(year_founded) AS oldest_business, max(year_founded) AS newest_business
    FROM business
) x;
-- Respuesta: La empresa más antigua es Kongo Gumi y se ha fundado en el año 578. Sin embargo, la empresa más nueva es Meridian Corporation, la cual se ha fundado en el año 1999. Es increíble que una empresa haya sobrevivido por más de un milenio.
-- Answer: The oldest business is Kongo Gumi and it was founded in 578. However, the newest business is Meridian Corporation and it was founded in 1999. That's pretty incredible that a business has survived for more than a millennium.

-- Pregunta (2) ¿Cuántas empresas han sido fundadas antes del 1000?
-- Question (2) How many businesses were founded before 1000?

SELECT COUNT(*)
FROM business
WHERE year_founded < 1000;

-- Respuesta: únicamente 6 empresas han sido fundadas antes del año 1000.
-- Answer: only 6 business were founded before 1000.

-- Pregunta (3) ¿Cuáles son las empresas que han sido fundadas antes del 1000?
-- Question (3) Which businesses were founded before 1000?

SELECT name, year_founded
FROM business
WHERE year_founded < 1000;

-- Respuesta: las 6 empresas fundadas antes del 1000 son: 'Kongo Gumi' (en 578), 'Monnaie de Paris' (en 864), 'Seans Bar' (en 900), 'St. Peter Stifts Kulinarium' (en 803), 'Staffelter Hof Winery' (en 862), 'The Royal Mint' (en 886).
-- Answer: the business founded before 1000 were: 'Kongo Gumi' (in 578), 'Monnaie de Paris' (in 864), 'Seans Bar' (in 900), 'St. Peter Stifts Kulinarium' (in 803), 'Staffelter Hof Winery' (in 862), 'The Royal Mint' (in 886).

-- Pregunta (4) Ahora sabemos que cuales son las empresas más antiguas del mundo, ¿Pero qué hacen esas empresas? Los códigos de categoría en la tabla de negocios no son muy útiles: las descripciones de las categorías se almacenan en 
-- la tabla de categorías. Este es un problema común: para el almacenamiento de datos, es mejor mantener diferentes tipos de datos en diferentes tablas, pero para el análisis es deseable que todos los datos se encuentren en un solo lugar. 
-- Para solucionar esto, uniré las dos tablas.
-- Question (4): Now we know the oldest business, But what have been doing these companies? The category codes in the businesses table aren't very helpful: the descriptions of the categories are stored in the categories table. 
-- This is a common problem: for data storage, it's better to keep different types of data in different tables, but for analysis, you want all the data in one place. To solve this, I'll have to join the two tables together.

SELECT b.name, b.year_founded, b.country_code, c.category
FROM business AS b
INNER JOIN categories AS c
ON b.category_code = c.category_code
WHERE b.year_founded < 1000
ORDER BY b.year_founded;

-- Respuesta: las categorías son 'Cafes, Restaurants & Bars', 'Distillers, Vintners, & Breweries', 'Manufacturing & Production','Cafes, Restaurants & Bars'.
-- Answer: the categories are 'Cafes, Restaurants & Bars', 'Distillers, Vintners, & Breweries', 'Manufacturing & Production','Cafes, Restaurants & Bars'.

-- Pregunta (5) ¿Qué industrias son las 10 más comunes?
-- Question (5) Which industries are the 10 most common?

SELECT cat.category, COUNT(bus.category_code) AS n
FROM business AS bus
INNER JOIN categories AS cat
ON bus.category_code = cat.category_code
GROUP BY cat.category
ORDER BY n DESC
LIMIT 10;

-- Respuesta: Las industrias más comunes son 'Banking & Finance' (37), 'Distillers, Vintners, & Breweries' (22), 'Aviation & Transport' (19), 'Postal Service' (16), 'Manufacturing & Production' (15), 'Media' (7),
-- 'Agriculture' (6), 'Cafés, Restaurants & Bars' (6), 'Food & Beverages' (6), 'Tourism & Hotels' (4).
-- Answer: the industries most common are 'Banking & Finance' (37), 'Distillers, Vintners, & Breweries' (22), 'Aviation & Transport' (19), 'Postal Service' (16), 'Manufacturing & Production' (15), 'Media' (7),
-- 'Agriculture' (6), 'Cafés, Restaurants & Bars' (6), 'Food & Beverages' (6), 'Tourism & Hotels' (4).

-- Pregunta (6) ¿Cual es la empresa más antigua de cada continente?
-- Question (6) How old the oldest business is on each continent?

SELECT MIN(b.year_founded) AS oldest, c.continent
FROM business AS b
INNER JOIN countries AS c
ON b.country_code = c.country_code
GROUP BY c.continent
ORDER BY oldest;

-- Respuesta: La empresa más antigua es del año 578 en Asia, 803 en Europe, 1534 en North America, 1565 en South America, 1772 en Africa, 1809 en Oceania.
-- Answer : The oldest company per continent is: to the year 578 in Asia, 803 in Europe, 1534 in North America, 1565 in South America, 1772 in Africa, 1809 in Oceania.

-- Pregunta (7) Unir todas las tablas para un mayor análisis.
-- Pregunta (7) Joining everything for further analysis.

SELECT b.name, b.year_founded, ca.category, co.country, co.continent
FROM business AS b
INNER JOIN categories AS ca
ON b.category_code = ca.category_code
INNER JOIN countries AS co
ON b.country_code = co.country_code; 

-- Pregunta (8) ¿Cuales son las 3 categorías más comunes para las empresas más antiguas por continente?
-- Question (8) Which are the 3 most common categories for the oldest businesses by continent?

SELECT co.continent, ca.category, COUNT(b.name) AS n
FROM business AS b
INNER JOIN categories AS ca
ON b.category_code = ca.category_code
INNER JOIN countries AS co
ON b.country_code = co.country_code
GROUP BY co.continent, ca.category
ORDER BY n DESC
LIMIT 3;

-- Respuesta: las categorías mas comunes son 'Africa, Banking & Finance' con 17 empresas en Africa, 'Distillers, Vintners, & Breweries' con 12 empresas en Europa, 'Africa, Aviation & Transport' con 10 empresas en Africa.
-- Answer: the most common category are 'Africa, Banking & Finance' with 17 business in Africa, 'Distillers, Vintners, & Breweries' with 12 business in Europa, 'Africa, Aviation & Transport' with 10 business in Africa.

-- Pregunta (9) Filtrar la cantidad anterior por continente y categoría
-- Question (9) Filtering counts by continent and category

SELECT co.continent, ca.category, COUNT(b.name) AS n
FROM business AS b
INNER JOIN categories AS ca
ON b.category_code = ca.category_code
INNER JOIN countries AS co
ON b.country_code = co.country_code
GROUP BY co.continent, ca.category
HAVING COUNT(b.name) > 5
ORDER BY n DESC;

-- Respuesta: Al ejecutar la query veremos la cantidad de empresas que poseen la misma categoría y continente.
-- Answer: When we run the query we will see the number of companies that have the same category and continent.

