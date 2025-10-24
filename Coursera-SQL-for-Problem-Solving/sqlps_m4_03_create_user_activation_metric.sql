-- This SQL script creates a user activation metric by identifying whether users added items to their cart or placed an order within 7 days of account creation.

-- CTE to get non-admin users excluding internal test accounts
WITH cte_users AS (
select 
    id as user_id,
    CAST(created_timestamp AS TIMESTAMP) as user_created_time,
    CAST(created_timestamp AS TIMESTAMP) + INTERVAL '7 days' as activation_window_7d
from sqlps.users
where COALESCE(is_admin, false) = false
  and email_address NOT LIKE '%@hypotheticalwidgetshop.com%'
),

-- CTE to get the first add_to_cart event time for each user
cte_first_add_to_cart AS (
select
    user_id,
    min(event_time) as first_add_to_cart_time
from sqlps.events
where user_id IS NOT NULL
    AND event_name = 'add_to_cart'
group by user_id
),

-- CTE to get the first order placed time for each user
cte_first_order AS (
select
    user_id,
    min(CAST(created_timestamp AS TIMESTAMP)) as first_order_placed_time
from sqlps.orders
group by user_id
)

-- Final selection to create user activation metrics
select
    u.user_id,
    u.user_created_time,
    u.activation_window_7d,
    fac.first_add_to_cart_time,
    fo.first_order_placed_time,
    CASE 
        WHEN fac.first_add_to_cart_time IS NOT NULL 
             AND fac.first_add_to_cart_time <= u.activation_window_7d 
        THEN 1 
        ELSE 0 
    END AS cart_activation_within_7d,
    CASE 
        WHEN fo.first_order_placed_time IS NOT NULL 
             AND fo.first_order_placed_time <= u.activation_window_7d 
        THEN 1 
        ELSE 0 
    END AS order_activation_within_7d
from cte_users u
left join cte_first_add_to_cart fac
    on u.user_id = fac.user_id
left join cte_first_order fo
    on u.user_id = fo.user_id;