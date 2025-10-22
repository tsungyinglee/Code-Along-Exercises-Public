-- Funnel example: the percent of logins that are successful over time

-- Start events
WITH login_start_events AS (
    SELECT 
        id as event_id,
        session_id,
        event_time
    FROM sqlps.events
    WHERE event_name = 'login_start'
),

-- Outcome events
login_success_events AS (
    SELECT 
        id as event_id,
        session_id,
        event_time
    FROM sqlps.events
    WHERE event_name = 'login_success'
),

loging_sessino_time AS (
    SELECT 
        lse.session_id,
        MIN(lse.event_time) AS first_login_attempt_time,
        MIN(lse2.event_time) AS first_login_success_time
    FROM login_start_events lse
    LEFT JOIN login_success_events lse2
        ON lse.session_id = lse2.session_id
        AND lse2.event_time <= lse.event_time + INTERVAL '1 hour' -- consider success within 1 hour of start
    GROUP BY lse.session_id
)

SELECT
    date(first_login_attempt_time) AS login_date,
    COUNT(DISTINCT session_id) AS total_login_attempts,
    COUNT(DISTINCT CASE WHEN first_login_success_time IS NOT NULL THEN session_id END) AS successful_logins,
    ROUND(
        COUNT(DISTINCT CASE WHEN first_login_success_time IS NOT NULL THEN session_id END)::DECIMAL 
        / NULLIF(COUNT(DISTINCT session_id), 0) * 100, 2
    ) AS success_rate_percentage
FROM loging_sessino_time
GROUP BY login_date
ORDER BY login_date;