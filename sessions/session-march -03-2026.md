## Topics covered

- Using `ORDER BY` to organize query results
- Introduction to analytic (window) functions
- How `PARTITION BY` divides data into groups for calculations
- Understanding sliding windows and how they define a range of rows used in a calculation

## What I understood

- The `ORDER BY` clause is used to arrange the results of a query based on one or more columns.
- `PARTITION BY` is used inside analytic functions to separate data into groups, but it still keeps every row in the output.
- Analytic functions make it possible to perform calculations such as rankings, running totals, and averages while still displaying each row of the dataset.
- Sliding windows allow us to define a specific range of rows around the current row so we can calculate values like moving averages or cumulative results.

## What is still confusing

- I still find the window frame part of sliding windows a bit confusing, especially when defining the number of rows before or after the current row.
- It can also be tricky to fully understand how `ORDER BY` and `PARTITION BY` interact when they are used together in analytic functions.

## Questions

- What is a clear practical example that shows the difference between `GROUP BY` and `PARTITION BY` in a real dataset?