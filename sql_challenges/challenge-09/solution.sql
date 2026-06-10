-- ============================================================
-- EXERCISE 1: Manual Transaction
-- ============================================================

-- Check initial balances
SELECT *
FROM accounts
ORDER BY account_id;

-- Move $50 from Charlie to Alice
UPDATE accounts
SET balance = balance - 50
WHERE account_id = 3;

UPDATE accounts
SET balance = balance + 50
WHERE account_id = 1;

COMMIT;

-- Verify final balances
SELECT *
FROM accounts
ORDER BY account_id;


-- ============================================================
-- EXERCISE 2: ROLLBACK Example
-- ============================================================

-- Review balances before starting
SELECT *
FROM accounts
ORDER BY account_id;

-- Attempt a transfer larger than Bob's balance
UPDATE accounts
SET balance = balance - 10000
WHERE account_id = 2;

UPDATE accounts
SET balance = balance + 10000
WHERE account_id = 3;

-- Inspect temporary state
SELECT *
FROM accounts
ORDER BY account_id;

-- Bob would end up with an invalid balance.
-- Since the transaction should not be completed,
-- all pending changes are cancelled.

ROLLBACK;

-- Confirm original values were restored
SELECT *
FROM accounts
ORDER BY account_id;


-- ============================================================
-- EXERCISE 3: SAVEPOINT
-- ============================================================

SELECT *
FROM accounts
ORDER BY account_id;

-- Deposit to Alice
UPDATE accounts
SET balance = balance + 25
WHERE account_id = 1;

SAVEPOINT alice_updated;

-- Wrong deduction
UPDATE accounts
SET balance = balance - 25
WHERE account_id = 3;

-- Undo only the incorrect step
ROLLBACK TO alice_updated;

-- Correct deduction
UPDATE accounts
SET balance = balance - 25
WHERE account_id = 2;

COMMIT;

SELECT *
FROM accounts
ORDER BY account_id;


-- ============================================================
-- EXERCISE 4: Stored Procedure
-- ============================================================

CREATE OR REPLACE PROCEDURE deposit_funds(
    p_account_id NUMBER,
    p_amount NUMBER
)
AS
BEGIN

    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Deposit amount must be positive'
        );
    END IF;

    UPDATE accounts
       SET balance = balance + p_amount
     WHERE account_id = p_account_id;

    IF SQL%ROWCOUNT <> 1 THEN
        RAISE_APPLICATION_ERROR(
            -20004,
            'Invalid account identifier'
        );
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

EXEC deposit_funds(3,75);

SELECT *
FROM accounts
ORDER BY account_id;


-- ============================================================
-- EXERCISE 5: Discussion Questions
-- ============================================================

-- Q1
-- Reserving the appointment slot and creating the appointment
-- record should be part of the same transaction because both
-- operations are required for the booking to be valid.
--
-- Sending a notification can happen afterward. A notification
-- failure does not make the appointment invalid, and the system
-- can resend it later if necessary.


-- Q2
-- If a procedure performs a COMMIT internally, the caller loses
-- control over transaction management.
--
-- When that procedure is executed inside a larger workflow,
-- subsequent failures cannot undo the changes that were already
-- committed by the procedure. This may leave the database in a
-- partially completed state.


-- Q3
-- Yes, calculate_copay() can be used inside a SELECT statement
-- because functions return values that can participate in query
-- expressions.
--
-- post_payment() cannot be used the same way because procedures
-- are designed to execute actions rather than return a value that
-- SQL can consume directly.