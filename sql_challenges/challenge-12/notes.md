# Notes

## What I learned

This challenge demonstrated that dashboard development starts with defining the business question before writing SQL.

I learned how KPI definitions directly affect the interpretation of results and how different filters can significantly change a metric.

The exercise also reinforced the importance of aggregation functions and grouping techniques when creating reports.

## Alternative approaches

* Materialized views for frequently used KPIs.
* Reporting tables updated periodically.
* BI tools connected directly to the database.

## Performance considerations

Complex dashboard queries can become expensive as data volume grows.

Indexes, aggregation strategies, and precomputed metrics may be necessary for larger systems.

Dashboard queries should prioritize both accuracy and execution speed.
