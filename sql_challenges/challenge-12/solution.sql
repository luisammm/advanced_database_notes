sql
-- ============================================================
-- EXERCISE 1: TEAM VELOCITY
-- ============================================================

-- KPI CONTRACT
-- Business Question:
-- Which team completes work faster?
--
-- Definition:
-- Velocity = completed tasks per team member.
--
-- Unit:
-- Tasks completed per person.
--
-- Edge Cases:
-- Teams with no completed tasks.
-- Teams with different team sizes.
--
-- Limitation:
-- Does not account for task complexity.

WITH team_stats AS (
    SELECT
        t.name AS team_name,
        COUNT(DISTINCT u.id) AS team_members,
        COUNT(
            CASE
                WHEN ts.status = 'completed' THEN 1
            END
        ) AS completed_tasks
    FROM teams t
    LEFT JOIN users u
        ON u.team_id = t.id
    LEFT JOIN tasks ts
        ON ts.assigned_to = u.id
    GROUP BY t.id, t.name
)
SELECT
    team_name,
    completed_tasks,
    team_members,
    ROUND(
        completed_tasks /
        NULLIF(team_members,0),
        2
    ) AS velocity,
    CASE
        WHEN ROUND(completed_tasks / NULLIF(team_members,0),2)
             < AVG(
                 ROUND(completed_tasks / NULLIF(team_members,0),2)
               ) OVER ()
        THEN 'Below Average'
        ELSE 'Above Average'
    END AS velocity_flag
FROM team_stats;


-- ============================================================
-- EXERCISE 2: ON-TIME DELIVERY RATE
-- ============================================================

-- KPI CONTRACT
-- On-time means completed on or before the due date.
--
-- Unit:
-- Percentage
--
-- Excludes:
-- Tasks without due dates.

SELECT
    priority,

    COUNT(*) AS completed_tasks,

    ROUND(
        100 *
        SUM(
            CASE
                WHEN completed_at <= due_date + 1
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS on_time_rate,

    ROUND(
        AVG(
            CASE
                WHEN completed_at > due_date
                THEN (completed_at - due_date) * 24
            END
        ),
        2
    ) AS avg_late_hours

FROM tasks
WHERE status = 'completed'
  AND due_date IS NOT NULL
GROUP BY priority
ORDER BY priority;


-- ============================================================
-- EXERCISE 3: IMPROVED TASKS PER TEAM
-- ============================================================

SELECT
    t.name AS team_name,

    COUNT(ts.id) AS total_tasks,

    COUNT(
        CASE
            WHEN ts.status IN
                ('open','in_progress','blocked')
            THEN 1
        END
    ) AS active_tasks,

    ROUND(
        100 *
        COUNT(
            CASE
                WHEN ts.status = 'completed'
                THEN 1
            END
        )
        /
        NULLIF(
            COUNT(
                CASE
                    WHEN ts.status <> 'cancelled'
                    THEN 1
                END
            ),
            0
        ),
        2
    ) AS completion_rate,

    CASE
        WHEN COUNT(
                CASE
                    WHEN ts.status IN
                    ('open','in_progress','blocked')
                    THEN 1
                END
             ) > 10
            THEN 'Overloaded'

        WHEN COUNT(
                CASE
                    WHEN ts.status IN
                    ('open','in_progress','blocked')
                    THEN 1
                END
             ) BETWEEN 5 AND 10
            THEN 'Healthy'

        ELSE 'Underutilized'
    END AS health_score

FROM teams t
LEFT JOIN users u
    ON u.team_id = t.id
LEFT JOIN tasks ts
    ON ts.assigned_to = u.id
GROUP BY t.id,t.name
ORDER BY active_tasks DESC;


-- ============================================================
-- EXERCISE 4: RESOLUTION TIME BY PRIORITY
-- ============================================================

SELECT
    priority,

    COUNT(*) AS completed_tasks,

    ROUND(
        AVG(
            (completed_at - created_at) * 24
        ),
        2
    ) AS avg_hours,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY
            (completed_at - created_at) * 24
        ),
        2
    ) AS median_hours,

    ROUND(
        MIN(
            (completed_at - created_at) * 24
        ),
        2
    ) AS fastest_hours,

    ROUND(
        MAX(
            (completed_at - created_at) * 24
        ),
        2
    ) AS slowest_hours,

    CASE
        WHEN priority = 'critical'
             AND AVG((completed_at-created_at)*24) <= 24
        THEN 'Target Met'

        WHEN priority = 'high'
             AND AVG((completed_at-created_at)*24) <= 72
        THEN 'Target Met'

        WHEN priority = 'medium'
             AND AVG((completed_at-created_at)*24) <= 168
        THEN 'Target Met'

        WHEN priority = 'low'
             AND AVG((completed_at-created_at)*24) <= 336
        THEN 'Target Met'

        ELSE 'Target Missed'
    END AS sla_result

FROM tasks
WHERE status='completed'
GROUP BY priority;


-- ============================================================
-- EXERCISE 5: OVERDUE REPORT
-- ============================================================

SELECT
    ts.title,
    u.full_name,
    tm.name AS team_name,
    ts.priority,
    ts.due_date,

    TRUNC(SYSDATE) - ts.due_date
        AS days_overdue,

    CASE
        WHEN ts.priority='critical'
             AND TRUNC(SYSDATE)-ts.due_date > 0
        THEN 'CRITICAL'

        WHEN ts.priority='high'
             AND TRUNC(SYSDATE)-ts.due_date > 2
        THEN 'HIGH'

        WHEN ts.priority='medium'
             AND TRUNC(SYSDATE)-ts.due_date > 5
        THEN 'MEDIUM'

        ELSE 'LOW'
    END AS severity

FROM tasks ts
JOIN users u
    ON u.id = ts.assigned_to
JOIN teams tm
    ON tm.id = u.team_id

WHERE ts.status NOT IN
      ('completed','cancelled')
  AND ts.due_date < TRUNC(SYSDATE)

ORDER BY
    severity,
    days_overdue DESC;


-- ============================================================
-- EXERCISE 6: PRODUCTIVITY SCORE
-- ============================================================

-- Problem:
-- Counting assigned tasks does not measure productivity.
-- A better metric is completed work weighted by priority.

SELECT
    u.full_name,

    SUM(
        CASE ts.priority
            WHEN 'critical' THEN 4
            WHEN 'high' THEN 3
            WHEN 'medium' THEN 2
            ELSE 1
        END
    ) AS weighted_completion_score

FROM users u
JOIN tasks ts
    ON ts.assigned_to = u.id

WHERE ts.status = 'completed'

GROUP BY u.full_name
ORDER BY weighted_completion_score DESC;


-- ============================================================
-- EXERCISE 7: TEAM EFFICIENCY
-- ============================================================

-- Average task ID has no business meaning.

SELECT
    t.name,

    ROUND(
        100 *
        COUNT(
            CASE
                WHEN ts.status='completed'
                THEN 1
            END
        )
        /
        NULLIF(COUNT(ts.id),0),
        2
    ) AS efficiency_percent

FROM teams t
LEFT JOIN users u
    ON u.team_id = t.id
LEFT JOIN tasks ts
    ON ts.assigned_to = u.id

GROUP BY t.id,t.name
ORDER BY efficiency_percent DESC;


-- ============================================================
-- EXERCISE 8: URGENCY INDEX
-- ============================================================

-- Priority is text and cannot be multiplied.
-- We need numeric priority weights.

SELECT
    title,
    priority,
    due_date,

    (
        CASE priority
            WHEN 'critical' THEN 40
            WHEN 'high' THEN 30
            WHEN 'medium' THEN 20
            ELSE 10
        END
    )
    +
    (
        TRUNC(SYSDATE) - due_date
    ) AS urgency_score

FROM tasks

WHERE status NOT IN
    ('completed','cancelled')

ORDER BY urgency_score DESC;

