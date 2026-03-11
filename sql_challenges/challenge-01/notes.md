# Challenge – Multi-table queries with JOINs

## Goal
The goal of this exercise was to practice combining data from two tables using JOIN.

## Reasoning

1. To get the domestic and international sales for each movie, I joined the `movies` table with the `boxoffice` table using the movie id.

2. To find the movies that performed better internationally, I compared the `international_sales` and `domestic_sales` values and filtered the results where international sales were higher.

3. To list movies by rating, I joined the two tables again and sorted the results by the `rating` column in descending order.

## What I learned
This exercise helped me understand how JOIN works to combine information from multiple tables and how to use conditions and sorting with joined data.

# Challenge – Buildings and Employees tables

## Goal
The goal of this exercise was to practice working with multiple tables and using JOIN to combine information.

## Reasoning

1. To find buildings that have employees, I selected the building column from the employees table and used DISTINCT to avoid duplicates.

2. To list all buildings and their capacity, I simply selected the columns from the buildings table.

3. To show all buildings and the roles of employees working there, I joined the buildings table with the employees table using a LEFT JOIN so that buildings without employees would still appear.

## What I learned
This exercise helped me understand how to use DISTINCT and how LEFT JOIN works when combining tables, especially when we want to include rows that might not have matching values.