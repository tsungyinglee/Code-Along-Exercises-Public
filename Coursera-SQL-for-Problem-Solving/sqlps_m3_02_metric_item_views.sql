-- Metric: How many users viewed an item?

WITH cte_logged_in_view_events AS (
    SELECT
        id as event_id,
        cast(event_time as date) as event_date,
        user_id
    FROM sqlps.events
    WHERE event_name = 'view_item'
),

cte_real_user AS (
    SELECT id as user_id
    FROM sqlps.users 
    WHERE email_address  NOT LIKE '%@hypotheticalwidgetshop.com%'
),

item_viewing_metric AS (
    SELECT
        le.event_date,
        COUNT(DISTINCT le.user_id) AS unique_user_views
    FROM cte_logged_in_view_events le
    JOIN cte_real_user ru ON le.user_id = ru.user_id
    GROUP BY le.event_date
)

SELECT *
FROM item_viewing_metric
ORDER BY event_date DESC;