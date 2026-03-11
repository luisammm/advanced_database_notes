-- SQL Lesson 6: Multi-table queries with JOINs

-- 1. Find the domestic and international sales for each movie
SELECT movies.title, boxoffice.domestic_sales, boxoffice.international_sales
FROM movies
JOIN boxoffice
ON movies.id = boxoffice.movie_id;

-- 2. Show the sales numbers for each movie that did better internationally rather than domestically
SELECT movies.title, boxoffice.domestic_sales, boxoffice.international_sales
FROM movies
JOIN boxoffice
ON movies.id = boxoffice.movie_id
WHERE boxoffice.international_sales > boxoffice.domestic_sales;

-- 3. List all the movies by their ratings in descending order
SELECT movies.title, boxoffice.rating
FROM movies
JOIN boxoffice
ON movies.id = boxoffice.movie_id
ORDER BY boxoffice.rating DESC;

-- SQL Lesson: Working with multiple tables

-- 1. Find the list of all buildings that have employees
SELECT DISTINCT building
FROM employees;

-- 2. Find the list of all buildings and their capacity
SELECT building_name, capacity
FROM buildings;

-- 3. List all buildings and the distinct employee roles in each building (including empty buildings)
SELECT buildings.building_name, employees.role
FROM buildings
LEFT JOIN employees
ON buildings.building_name = employees.building;