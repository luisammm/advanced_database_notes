# Window Functions and Ranking in SQL

## Goal
The goal of this session was to learn how to use window functions in SQL to analyze data without grouping rows together like we do with GROUP BY.

## Topics covered

- Introduction to window functions
- Using OVER() with PARTITION BY
- Running calculations using ORDER BY inside window functions
- Understanding window frames like PRECEDING and FOLLOWING
- Using ranking functions like DENSE_RANK
- Combining window functions with common table expressions (CTEs)

## Reasoning

1. In the first exercise, window functions were used to calculate values across rows that share the same shape. This allowed counting how many bricks exist per shape and finding the median weight without collapsing the rows.

2. In the second exercise, a running average was calculated using AVG() with an ORDER BY clause inside the window function. This creates a cumulative calculation as the rows progress.

3. The third exercise focused on window frames, which allow referencing rows before or after the current row. This makes it possible to analyze nearby values instead of the whole dataset.

4. The fourth exercise combined window functions with a CTE. This allowed calculating totals and running values first, and then filtering the results based on those calculated columns.

5. The last query used DENSE_RANK to rank employees by salary within each department. This makes it possible to retrieve the top salaries per department without losing rows.

## What I understood

- Window functions allow performing calculations across related rows while still returning each individual row.
- PARTITION BY divides the data into groups where the window function will be applied.
- ORDER BY inside a window function determines the order of the calculation, which is important for running totals or averages.
- Ranking functions like DENSE_RANK help identify top values inside categories.

## What is still confusing

- Some window frame options like RANGE vs ROWS are still a bit confusing and I need more practice to fully understand when to use each one.
- Sometimes it is not obvious how the window frame affects the calculation depending on the ordering.

## Questions

- When working with large datasets, do window functions impact performance significantly?
- In what situations should we prefer window functions instead of GROUP BY queries?