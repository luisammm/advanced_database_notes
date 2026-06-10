# Notes

## Exercise 1

I practiced creating a manual transaction and confirmed that changes are only permanently stored after executing COMMIT.

## Exercise 2

This exercise showed how ROLLBACK can be used to cancel operations before they become permanent. It is useful when a transaction produces unexpected results.

## Exercise 3

I learned how SAVEPOINT creates a checkpoint inside a transaction, allowing me to undo only specific changes without losing all previous work.

## Exercise 4

I practiced building a stored procedure with validation and exception handling. This demonstrated how business logic can be centralized inside the database.

## Exercise 5

I understood that only operations required to maintain database consistency should be included inside a transaction. External actions such as notifications can be executed separately.
