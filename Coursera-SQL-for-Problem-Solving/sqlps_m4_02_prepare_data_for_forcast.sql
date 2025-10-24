-- This query prepares daily sales data for forecasting by aggregating the number of items sold per day across all items.
DROP TABLE IF EXISTS sqlps.daily_orders;
CREATE TABLE IF NOT EXISTS sqlps.daily_orders AS
WITH daily_orders_by_item AS (
select
    li.item_id,
    CAST(o.created_timestamp AS DATE) AS order_date,
    COUNT(li.item_id) AS num_orders_by_item
from sqlps.orders o
inner join sqlps.line_items li
    on o.id = li.order_id
group by
    li.item_id,
    CAST(o.created_timestamp AS DATE)
order by
    li.item_id,
    order_date
)
select 
    order_date,
    sum(num_orders_by_item) AS total_orders
from daily_orders_by_item
group by
    order_date
order by
    order_date;
