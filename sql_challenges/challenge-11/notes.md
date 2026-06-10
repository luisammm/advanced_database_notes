# Notes

## What I learned

This challenge helped me understand how ORM models represent database tables and how relationships are defined between entities.

I learned how Alembic migrations provide version control for database schemas and allow changes to be applied incrementally.

The exercise also demonstrated how upgrade and downgrade operations make schema changes reversible.

## Alternative approaches

* Manual SQL migration scripts.
* Database-specific migration tools.
* Hybrid approaches combining ORM models and raw SQL.

## Performance considerations

ORMs improve developer productivity but may generate less efficient queries than handcrafted SQL in some scenarios.

Migration planning becomes increasingly important as the number of tables and dependencies grows.
