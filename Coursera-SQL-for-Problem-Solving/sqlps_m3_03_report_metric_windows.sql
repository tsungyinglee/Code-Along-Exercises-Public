-- Report number of users who vieed an item using a rolling weekly windows

WITH cte_logged_in_view_events AS (
    SELECT
        id as event_id,
        cast(event_time as date) as event_date,
        user_id
    FROM sqlps.events
    WHERE event_name = 'view_item'
)

SELECT d.ds,
    count(distinct le.user_id) as weekly_active_viewers
FROM sqlps.dates d
JOIN cte_logged_in_view_events le
    ON d.ds >= le.event_date
    AND d.day_ago_7 < le.event_date
GROUP BY d.ds
ORDER BY d.ds desc;