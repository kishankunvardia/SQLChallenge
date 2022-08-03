-- Sakila Challenge SQL
-- 1. List all actors
SELECT * FROM actor;

-- 2. Find the surname of the actor with the forename 'John'.
SELECT last_name FROM actor
WHERE first_name = "John";

-- 3. Find all actors with surname 'Neeson'.
SELECT * FROM actor
WHERE last_name = "Neeson";

-- 4. Find all actors with ID numbers divisible by 10.
SELECT * FROM actor
WHERE mod(actor_id, 10) = 0;

-- 5. What is the description of the movie with an ID of 100?
SELECT description FROM film
WHERE film_id = 100;

-- 6. Find every R-rated movie.
SELECT * FROM film
WHERE rating = "R";

-- 7. Find every non-R-rated movie.
SELECT * FROM film
WHERE rating != "R";

-- 8. Find the ten shortest movies.
SELECT * FROM film
ORDER BY length asc
LIMIT 10;

-- 9. Find the movies with the longest runtime, without using LIMIT .
SELECT * FROM film
WHERE length=(
	SELECT max(length) FROM film
    );

-- 10. Find all movies that have deleted scenes.
SELECT * FROM film
WHERE special_features LIKE '%Deleted Scenes%';

-- 11. Using HAVING , reverse-alphabetically list the last names that are not repeated.
SELECT last_name, count(last_name) FROM actor
GROUP BY last_name
HAVING count(last_name) = 1
ORDER BY last_name desc;

-- 12. Using HAVING , list the last names that appear more than once, from highest to lowest frequency
SELECT last_name, count(last_name) FROM actor
GROUP BY last_name
HAVING count(last_name) > 1
ORDER BY count(last_name) desc;

-- 13. Which actor has appeared in the most films?
SELECT * FROM actor
WHERE actor_id = (
SELECT actor_id
FROM film_actor
GROUP by actor_id
ORDER by count(actor_id) desc
LIMIT 1
);

-- 14. 'Academy Dinosaur' has been rented out, when is it due to be returned?
SELECT r.return_date
FROM rental r
JOIN inventory i ON i.inventory_id=r.inventory_id
JOIN film f ON f.film_id=i.film_id
WHERE title = "Academy Dinosaur"
ORDER by return_date DESC
LIMIT 1;

-- 15. What is the average runtime of all films?
SELECT AVG(length) FROM film;

-- 16. List the average runtime for every film category.
SELECT c.name, avg(length)
FROM category c
JOIN film_category fc ON fc.category_id=c.category_id
JOIN film f ON f.film_id=fc.film_id
GROUP by c.category_id;

-- 17. List all movies featuring a robot.
SELECT * FROM film
WHERE description LIKE '%robot%';

-- 18. How many movies were released in 2010?
SELECT count(film_id) FROM film
WHERE release_year = 2010;

-- 19. Find the titles of all the horror movies.
SELECT f.title
FROM category c
JOIN film_category fc ON fc.category_id=c.category_id
JOIN film f ON f.film_id=fc.film_id
WHERE c.name = "Horror";

-- 20. List the full name of the staff member with the ID of 2.
SELECT concat(first_name, " " ,last_name) as "Full Name" FROM staff
WHERE staff_id=2;

-- 21. List all the movies that Fred Costner has appeared in.
SELECT f.title
FROM film f
JOIN film_actor fa ON fa.film_id=f.film_id
JOIN actor a ON a.actor_id=fa.actor_id
WHERE first_name = "Fred" AND last_name="Costner";

-- 22. How many distinct countries are there?
SELECT count(country) FROM Country;

-- 23. List the name of every language in reverse-alphabetical order.
SELECT name FROM language
ORDER BY name DESC;

-- 24. List the full names of every actor whose surname ends with '-son' in alphabetical order by their forename.
SELECT first_name, last_name FROM actor
WHERE last_name LIKE "%son"
ORDER BY first_name asc;

-- 25. Which category contains the most films?
SELECT name FROM category
WHERE category_id = (
SELECT category_id
FROM film_category
GROUP by category_id
ORDER by count(category_id) desc
LIMIT 1
);

-- World Challenge SQL 
-- 1. Using COUNT , get the number of cities in the USA.
SELECT count(id) FROM city
WHERE CountryCode = (
SELECT Code from country
WHERE name = "United States"
);

-- 2. Find out the population and life expectancy for people in Argentina.
SELECT Population, LifeExpectancy FROM country
WHERE name = "Argentina";

-- 3. Using IS NOT NULL , ORDER BY , and LIMIT , which country has the highest life expectancy?
SELECT Name FROM country
WHERE LifeExpectancy IS NOT NULL
ORDER BY LifeExpectancy DESC
LIMIT 1;

-- 4. Using JOIN ... ON , find the capital city of Spain.
SELECT ci.Name
FROM city ci
JOIN country co ON ci.ID=co.Capital
WHERE co.Name = "Spain";

-- 5. Using JOIN ... ON , list all the languages spoken in the Southeast Asia region.
SELECT DISTINCT Language 
FROM countrylanguage cl
JOIN country c ON c.Code= cl.CountryCode
WHERE c.Region = "Southeast Asia";

-- 6. Using a single query, list 25 cities around the world that start with the letter F.
SELECT * FROM city
WHERE Name LIKE "F%"
LIMIT 25;

-- 7. Using COUNT and JOIN ... ON , get the number of cities in China.
SELECT count(ci.ID)
FROM city ci
JOIN country co ON co.Code=ci.CountryCode
WHERE co.Name = "China";

-- 8. Using IS NOT NULL , ORDER BY , and LIMIT , which country has the lowest population? Discard non-zero populations.
SELECT Name, Population 
FROM country
WHERE Population IS NOT NULL 
AND Population != 0
ORDER BY Population
LIMIT 1;

-- 9. Using aggregate functions, return the number of countries the database contains.
SELECT COUNT(Name)
FROM country;

-- 10. What are the top ten largest countries by area?
SELECT * FROM country
ORDER BY SurfaceArea DESC
LIMIT 10;

-- 11. List the five largest cities by population in Japan.
SELECT *
FROM city ci
JOIN country co ON ci.CountryCode=co.Code
WHERE co.Name = "Japan"
ORDER BY ci.Population DESC
LIMIT 5;

 -- 12. List the names and country codes of every country with Elizabeth II as its Head of State. You will need to fix the mistake first!
UPDATE country
SET HeadOfState="Elizabeth II"
WHERE HeadOfState="Elisabeth II";

SELECT Name, Code FROM country
WHERE HeadOfState="Elizabeth II";

-- 13. List the top ten countries with the smallest population-to-area ratio. Discard any countries with a ratio of 0.
SELECT name, (Population / SurfaceArea) as ratio FROM country
WHERE Population > 0
ORDER by ratio
LIMIT 10;

-- 14. List every unique world language.
SELECT DISTINCT Language FROM countrylanguage;

-- 15. List the names and GNP of the world's top 10 richest countries.
SELECT Name, GNP FROM country
ORDER BY GNP DESC
LIMIT 10;

-- 16. List the names of, and number of languages spoken by, the top ten most multilingual countries.
SELECT c.name, count(cl.countrycode) as "Number of Language spoken"
FROM countrylanguage cl
JOIN country c ON c.Code=cl.CountryCode
GROUP BY cl.countrycode
ORDER BY count(cl.countrycode) DESC
LIMIT 10;

-- 17. List every country where over 50% of its population can speak German.
SELECT c.name, cl.percentage 
FROM country c
JOIN countrylanguage cl ON c.Code=cl.CountryCode
WHERE cl.Language = "German"
AND cl.Percentage > 50;

-- 18. Which country has the worst life expectancy? Discard zero or null values.
SELECT Name FROM country
WHERE LifeExpectancy IS NOT NULL
ORDER BY LifeExpectancy ASC
LIMIT 1;

-- 19. List the top three most common government forms.
SELECT GovernmentForm, count(GovernmentForm)
FROM country
GROUP BY GovernmentForm
ORDER BY count(GovernmentForm) DESC
LIMIT 3;

-- 20. How many countries have gained independence since records began?
SELECT count(IndepYear) FROM country
WHERE IndepYear IS NOT NULL;

-- Movielens Challenge SQL
-- 1. List the titles and release dates of movies released between 1983-1993 in reverse chronological order.
SELECT title, release_date
FROM movies
WHERE release_date BETWEEN "1983-01-01" AND "1993-12-31"
ORDER BY release_date DESC;

-- 2. Without using LIMIT , list the titles of the movies with the lowest average rating.
SELECT m.title, r.rating
FROM movies m
JOIN ratings r ON r.movie_id=m.id
WHERE r.rating =(
	SELECT min(rating) FROM ratings 
    );
    
-- 3. List the unique records for Sci-Fi movies where male 24-year-old students have given 5-star ratings.
SELECT DISTINCT m.title, r.rating, u.gender, g.name, u.age, o.name
FROM movies m
JOIN ratings r ON r.movie_id=m.id
JOIN users u ON u.id=r.user_id
JOIN genres_movies gm ON gm.movie_id=m.id
JOIN genres g ON g.id=gm.genre_id
JOIN occupations o ON o.id=u.occupation_id
WHERE g.name = "Sci-Fi"
AND u.gender = "m"
AND u.age = 24
AND o.name = "Student"
AND r.rating = 5;

-- 4. List the unique titles of each of the movies released on the most popular release day.
SELECT Title, release_date FROM movies
WHERE release_date =(
SELECT release_date FROM movies
GROUP BY release_date 
ORDER BY count(release_date) desc
LIMIT 1);

-- 5. Find the total number of movies in each genre; list the results in ascending numeric order.
SELECT g.name, count(genre_id)
FROM genres_movies gm
JOIN genres g ON g.id=gm.genre_id
GROUP BY genre_id
ORDER BY count(genre_id) ASC;

-- END
