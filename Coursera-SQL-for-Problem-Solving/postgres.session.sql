---------------------------------
-- Getting the data type right
---------------------------------

-- Check the distribution of users by their admin status
select is_admin, 
    count(*) as user_count
from sqlps.users
group by 1;

-- If the is_admin column has NULL values, we can use COALESCE to treat them as false
select COALESCE(is_admin, false) as recoded_is_admin,
    count(*) as user_count
from sqlps.users
group by 1;


-- If the is_admin was accidetally stored as a string, we can recode it back to boolean
WITH cte_string_is_admin AS (
select id,
    cast(is_admin as varchar) as is_admin_as_string
from sqlps.users
)
select 
    case 
        when is_admin_as_string = 'true' then true
        when is_admin_as_string = 'false' then false
        else null
    end as recoded_is_admin,
    count(*) as user_count
from cte_string_is_admin
group by 1;

-- Alternatively, we can use CAST to convert the string back to boolean
WITH cte_string_is_admin AS (
select id,
    cast(is_admin as varchar) as is_admin_as_string
from sqlps.users
)
select 
    CAST(is_admin_as_string AS boolean) as recoded_is_admin,
    count(*) as user_count
from cte_string_is_admin
group by 1;


-------------------------------------------------------
-- Getting the data type right unloacks fucntionality
-------------------------------------------------------

-- If the data type is boolean, we can simplify our queries
-- using boolean logic in conditional statements
select id,
    is_admin,
    case 
        when is_admin then 'Admin User'
        else 'Regular User'
    end as user_type
from sqlps.users;

-- Date and time data types allow us to perform date arithmetic
select id,
    created_timestamp,
    -- Calculate the number of days since the user was created
    current_date - created_timestamp::date as days_since_creation,
    -- Calculate the number of days when the user account was created since 2017-01-01
    (created_timestamp::date - '2017-01-01'::date) as days_since_2017,
    -- Calculate the date when the user account reaches its one year anniversary
    created_timestamp::timestamp + interval '1 year' as one_year_anniversary
from sqlps.users;


-----------------------------------------
-- Pivot and rollup data
-----------------------------------------

-- Rollup data using GROUP BY single column
select assembly_type,
    count(*) as item_count,
    avg(list_price) as avg_list_price
from sqlps.items
group by 1
order by 1;

-- Rollup data using GROUP BY multiple columns
select category,
    material,
    count(*) as item_count
from sqlps.items
group by category,
    material
order by category,
    material;

-- "Bruce force" pivot in a wide table format using conditional aggregation
select category,
    count(CASE WHEN material='Carbon Fiber' THEN id ELSE NULL END) as carbon_fiber_count,
    count(CASE WHEN material='Steel' THEN id ELSE NULL END) as steel_count,
    count(CASE WHEN material='Composite' THEN id ELSE NULL END) as composite_count,
    count(CASE WHEN material='Organic' THEN id ELSE NULL END) as organic_count,
    count(CASE WHEN material NOT IN ('Carbon Fiber', 'Steel', 'Composite', 'Organic') THEN id ELSE NULL END) as other_material_count
from sqlps.items
group by 1
order by 1;
