-- Select all shoes with a price less than $100
select brand
, model
, price
from shoes
where price < 100.00
;

-- Select all shoes that are not from the brand 'Puma'
select brand
, model
, price
from shoes
where brand <> 'Puma'
;

-- Select all shoes with a price between $80 and $110
select brand
, model
, price
from shoes
where price between 80 and 110
;

-- Select all shoes where the color is not specified
select brand
, model
, price
, color
from shoes
where color is NULL;

-- Use IN to find shoes with specific ID
select *
from shoes
where id in (2, 6, 9);

-- Use IN with upper function to find shoes from specific brands regardless of case
select *
from shoes
where upper(brand) in ('NIKE', 'ADIDAS', 'PUMA');

-- Use OR to find shoes from specific brands
select
    id,
    brand,
    model,
    price
from shoes
where brand = 'Nike' or brand = 'Adidas' or brand = 'Puma';


-- SQL processes AND before OR, so parentheses can be used to clarify precedence and ensure correct logic
select
    id,
    brand,
    model,
    price
from shoes
where id=1 or id=2 and price > 150;

select
    id,
    brand,
    model,
    price
from shoes
where (id=1 or id=2) and price > 150;


-- Select shoes where the color is not 'Black' or 'Grey'
select *
from shoes
where not color = 'Black' and not color='Grey';
-- Note that rows where "color" is NULL are excluded, as the condition "not color = 'value'" does not match NULL values.
-- In SQL, NULL represents an unknown value, and comparisons with NULL always result in NULL (not true).


-- Select shoes where the color is not 'Black' or 'Grey', or is NULL
select *
from shoes
where (not color = 'Black' and not color='Grey') or color is null;


-- Using the LIKE operator:
-- 1. Descriptions starting with "Comfort" ('Comfort%').
select description
from shoes
where description like 'Comfort%';

-- 2. Descriptions ending with "comfort." ('%comfort\.').
select description
from shoes
where description like '%comfort\.';

-- 3. Descriptions containing "comfort" anywhere ('%comfort%').
select description
from shoes
where description like '%comfort%';

-- 4. Descriptions with "Classic" at the start and "design." at the end ('Classic%design\.').
select description
from shoes
where description like 'Classic%design\.';

-- 5. Descriptions with "omfort" starting from the second character ('_omfort%').
select description
from shoes
where description like '_omfort%';

-- Using the ILIKE operator (case-insensitive), some DBMS may not support.
select description
from shoes
where description ilike 'comfort%';

select description
from shoes
where lower(description) ilike 'comfort%';

-- Order results by id in descending order
-- note id is not selected in output but can still be used for ordering
select brand,
    model,
    size
from shoes
order by id desc;

-- Order results by color (ascending) and size (ascending)
select *
from shoes
order by color, size;

-- alternatively, can sort by column position numbers
select *
from shoes
order by 5, 4;

-- Order results by color (descending) and size (ascending)
select *
from shoes
order by color desc, size asc;

-- Calculate total sales for each shoe (price * order_units)
select id,
    -- price,
    -- order_units,
    (price * order_units) as total_sales
from shoes;


-- Calculate average price of shoes by shoe_type
select shoe_type,
    avg(price) as avg_price
from shoes
group by shoe_type;


/*
This SQL query retrieves the shoe type, price, and the average price of shoes grouped by their type from the "shoes" table. It uses a window function to calculate the average price for each shoe type without collapsing the rows.

The "avg(price) over(partition by shoe_type)" clause calculates the average price for each shoe type while retaining the individual rows in the result set.
*/
select shoe_type,
    price,
    avg(price) over(partition by shoe_type) as avg_price_by_shoe_type
from shoes;

select *,
    avg(price) over(partition by shoe_type) as avg_price_by_shoe_type
from shoes;

-- More examples of window functions
select shoe_type,
    price,
    order_units,
    
    min(price) over(partition by shoe_type) as min_price_by_shoe_type,
    max(price) over(partition by shoe_type) as max_price_by_shoe_type,
    count(*) over(partition by shoe_type) as count_by_shoe_type,
    
    -- Calculate the cumulative sum of prices within each shoe type, ordered by price
    sum(price) over(partition by shoe_type order by price) as cumulative_sum_by_shoe_type,
    
    sum(price) over(partition by shoe_type) as total_price_by_shoe_type,
    avg(price) over(partition by shoe_type) as avg_price_by_shoe_type,
from shoes
order by shoe_type, price
;

-- Count total number of shoes
select count(*) as total_shoes
from shoes
;

-- Count number of shoes with color specified (not NULL)
select count(color) as shoes_with_color_specified
from shoes
;

-- Count number of distinct colors
select count(distinct color) as distinct_colors
from shoes
;

-- Aggregate functions to get max, min, avg, sum of prices and count of missing values
select max(price) as max_price,
    min(price) as min_price,
    avg(price) as avg_price,
    sum(price) as total_price,
    count(*) - count(price) as missing_price_count
from shoes
;

-- Count number of missing color values
select count(*) as total_shoes,
    count(color) as shoes_with_color_specified,
    count(*) - count(color) as missing_color_count
from shoes
;

-- Count number of shoes per color, ordered by the count in descending order, including NULL colors
select color,
    count(*) as shoes_per_color
from shoes
group by color
order by shoes_per_color desc
;

-- Count number of shoes per color, excluding NULL colors
select color,
    count(color) as shoes_per_color
from shoes
where color is not null
group by color
order by shoes_per_color desc
;

-- Calculate total revenue (price * order_units) across all shoes
select sum(price*order_units) as total_revenue
from shoes
;

-- Calculate total revenue (price * order_units) for each shoe type
select shoe_type, 
    sum(price*order_units) as total_revenue
from shoes
group by shoe_type
;

-- Count total number of shoe types and number of distinct shoe types
select count(shoe_type) as non_null_shoe_type_count,
    count(distinct shoe_type) as distinct_shoe_type_count
from shoes
;



-- Create a mock sales dataset with 100 records
drop table if exists sales;
create table sales as
select 
    floor(random() * 50 + 1) as customer_id,
    CASE floor(random() * 5)
        WHEN 0 THEN 'New York'
        WHEN 1 THEN 'Los Angeles'
        WHEN 2 THEN 'Chicago'
        WHEN 3 THEN 'Houston'
        WHEN 4 THEN 'Phoenix'
    END as city,
    CASE floor(random() * 4)
        WHEN 0 THEN 'North'
        WHEN 1 THEN 'South'
        WHEN 2 THEN 'East'
        WHEN 3 THEN 'West'
    END as region,
    -- Generate a random unit price between $10.00 and $110.00
    round((random() * 100 + 10)::numeric, 2) as unit_price,
    -- Generate a random number of units sold between 1 and 50
    floor(random() * 50 + 1) as unit_on_order,
    -- Generate a random date within the last year
    current_date - floor(random() * 365)::int as order_date
from generate_series(1, 100);

-- View the first 10 records of the sales table
select *
from sales
limit 10
;

-- Count number of customers per region, ordered by the count in descending order
select region,
    count(customer_id) as num_customers
from sales
group by region
order by num_customers desc
;

-- Find customers with at least 2 orders, ordered by number of orders in descending order
select customer_id,
    count(*) as num_orders
from sales
group by customer_id
having count(*) >=2
order by num_orders desc
;
-- note that HAVING is used to filter groups after aggregation, whereas WHERE filters rows before aggregation.

-- Find customers with at least 2 orders and a minimum unit price greater than $50, ordered by number of orders in descending order
-- the WHERE clause filters rows before aggregation, so it affects the count of orders
select customer_id,
    count(*) as num_orders,
    min(unit_price) as min_unit_price
from sales
where unit_price > 50
group by customer_id
having count(*) >=2
order by num_orders desc
;