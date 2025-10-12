-----------------------------------------------------
-- Check and improve data quality
-----------------------------------------------------

-- Check distribution of users by admin status
select is_admin,
    count(*) as user_count
from sqlps.users
group by 1;

-- Use COALESCE to replace NULL values as FALSE
select coalesce(is_admin, false) as is_admin,
    count(*) as user_count
from sqlps.users
group by 1;

-- If the is_admin column was accidentally stored as a string
-- Use CASE to convert it to boolean
with cte_is_admin_string as (
    select cast(is_admin as varchar) as is_admin_string
    from sqlps.users
)
select case when is_admin_string = 'true' then true
            when is_admin_string = 'false' then false
            else null
       end as is_admin,
    count(*) as user_count
from cte_is_admin_string
group by 1;

-- Use CAST to convert string to boolean
with cte_is_admin_string as (
    select cast(is_admin as varchar) as is_admin_string
    from sqlps.users
)
select cast(is_admin_string as boolean) as is_admin,
    count(*) as user_count
from cte_is_admin_string
group by 1;


----------------------------------------------------------
-- Getting the data type right unlocks more functionality
----------------------------------------------------------

-- Convert string to date using CAST and perform date arithmetic
with cte_orders as (
    select id as order_id,
        created_timestamp,
        cast(created_timestamp as date) as order_date_converted
    from sqlps.orders
)
select order_id,
    created_timestamp,
    order_date_converted,
    -- number of days since order date
    current_date - order_date_converted as days_since_order,
    -- extract year from order date
    date_part('year', order_date_converted) as order_year,
    -- number of days since 2017-01-01 to order date
    order_date_converted - date '2017-01-01' as days_since_2017,
    -- one year after order date
    order_date_converted + interval '1 year' as one_year_after_order
from cte_orders
order by order_id
limit 10;

-- We can extract parts of the date/time for more granular analysis, e.g., by year-month
select to_char(created_timestamp::timestamp, 'YYYY-MM') as year_month,
    count(*) as users_created_in_month
from sqlps.users
group by 1
order by 1;

-- Number formatting
with cte_line_price as (
    select id as line_item_id,
        price,
        cast(price as decimal(10,1)) as price_converted
    from sqlps.line_items
)
select line_item_id,
    price,
    price_converted,
    -- round to nearest integer
    round(price_converted) as price_rounded,
    -- round to 2 decimal places
    round(price_converted, 2) as price_rounded_2dp,
    -- truncate to 2 decimal places
    trunc(price_converted, 2) as price_truncated_2dp,
    -- format with dollar sign and commas
    to_char(price_converted, 'L999,999.99') as price_formatted
from cte_line_price
order by line_item_id
limit 10;

----------------------------------------------------------
-- String manipulation
----------------------------------------------------------

-- Check for empty or whitespace-only usernames
select *
from sqlps.users
where username trim(username) = '';

-- Convert empty or whitespace-only usernames to NULL
-- Use SPLIT_PART to extract part of the email address
-- Then use COALESCE to impute null username from email address
with cte_cleaned_users as (
    select id,
        email_address,
        username,
        nullif(trim(username), '') as username_cleaned
    from sqlps.users
)
select id as user_id,
    email_address,
    split_part(email_address, '@', 1) as email_name,
    username_cleaned as username,
    COALESCE(username_cleaned, split_part(email_address, '@', 1), '') as username_imputed
from cte_cleaned_users
order by user_id
;
