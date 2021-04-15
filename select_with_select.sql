-- SELECT within SELECT
-- List each country name where the population is larger than that of 'Russia'. 
SELECT name FROM world WHERE population > (SELECT population FROM world WHERE name='Russia')

--Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name FROM world WHERE continent='Europe' AND gdp/population > 
(SELECT gdp/population FROM world WHERE name='United Kingdom')

--List the name and continent of countries in the continents containing either Argentina or Australia. 
--Order by name of the country.
SELECT name, continent FROM world WHERE continent IN
(SELECT continent FROM world WHERE name IN ('Argentina', 'Australia'))
ORDER BY name;

--Which country has a population that is more than Canada but less than Poland? Show the name and the population.
SELECT name, population FROM world
WHERE population > (SELECT population FROM world WHERE name='Canada') 
AND population < (SELECT population FROM world WHERE name='Poland');

--Show the name and the population of each country in Europe. 
--Show the population as a percentage of the population of Germany.
SELECT name, 
     CONCAT(ROUND(100*population/(SELECT population FROM world WHERE name='Germany')), '%') AS percentage
FROM world WHERE continent='Europe';

--Which countries have a GDP greater than every country in Europe? [Give the name only.] 
--(Some countries may have NULL gdp values)
SELECT name FROM world
WHERE gdp > ALL(SELECT gdp FROM world WHERE continent='Europe' AND gdp > 0);

--Find the largest country (by area) in each continent, show the continent, the name and the area: 
SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0);

--List each continent and the name of the country that comes first alphabetically.
SELECT continent, name FROM world x
WHERE name = (SELECT name from world y WHERE x.continent = y.continent ORDER BY name LIMIT 1);

--Find the continents where all countries have a population <= 25000000. 
--Then find the names of the countries associated with these continents. Show name, continent and population. 
SELECT name, continent, population
FROM world
WHERE continent IN
  (SELECT continent FROM world x
    WHERE
     (SELECT MAX(population) FROM world y
       WHERE
         x.continent = y.continent) <= 25000000);

--Some countries have populations more than three times that of any of their neighbours (in the same continent).
-- Give the countries and continents.
SELECT name, continent
FROM world x
WHERE population > ALL (
   SELECT MAX(population * 3) FROM world y 
   WHERE
   x.continent = y.continent
   AND x.name <> y.name;
)
--SUM and COUNT

-- Show the total population of the world. 
SELECT SUM(population) FROM world;

-- List all the continents - just once each. 
SELECT DISTINCT continent FROM world;

-- Give the total GDP of Africa 
SELECT SUM(gdp)
FROM world
WHERE continent = 'Africa';

--How many countries have an area of at least 1000000 
SELECT COUNT(name)
FROM world
WHERE area >= 1000000;

--What is the total population of ('Estonia', 'Latvia', 'Lithuania') 
SELECT SUM(population) 
FROM world 
WHERE name IN ('Estonia', 'Latvia', 'Lithuania');

--For each continent show the continent and number of countries. 
SELECT continent, COUNT(name)
FROM world
GROUP BY continent;

--For each continent show the continent and number of countries with populations of at least 10 million. 
SELECT continent, COUNT(name)
FROM world
WHERE population >= 10000000
GROUP by continent;

--List the continents that have a total population of at least 100 million. 
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000;