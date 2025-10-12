-- Review SQL Queries

-- Filter: Select all items in the 'Widget' category
select *
from sqlps.items
where category = 'Widget'
;

-- Date and Aggregate: Count number of orders per day
select cast(created_timestamp as date) as order_date, count(*) as num_orders
from sqlps.orders
group by cast(created_timestamp as date)
order by order_date
;

-- When Then Condition: Price range boundaries:
select id, list_price,
    case when  0  <= list_price and list_price <  25 then '$0-$24'
         when 25  <= list_price and list_price <  50 then '$25-$49'
         when 50  <= list_price and list_price < 100 then '$50-$99'
         when 100 <= list_price then '$100+' 
         when list_price <0 then 'Negative'
         when list_price is null then 'Null'
         else 'Other'
         end as price_range
from sqlps.items
;

-- Join, Subqueries, and CTE: Average number of items per order for each user

-- Using a subquery
select u.id, avg(num_items) as avg_items_per_order
from sqlps.users u
    left join sqlps.orders o on u.id = o.user_id
    left join (
        select order_id,
            count(id) as num_items
        from sqlps.line_items
        group by order_id
    ) li on o.id = li.order_id
group by u.id
;

-- Using a CTE
with cte_lineItemCounts as (
    select order_id,
        count(id) as num_items
    from sqlps.line_items
    group by order_id
) 
select u.id, avg(num_items) as avg_items_per_order
from sqlps.users u
    left join sqlps.orders o on u.id = o.user_id
    left join cte_lineItemCounts li on o.id = li.order_id
group by u.id
;

-- replace null with 0
with cte_lineItemCounts as (
    select order_id,
        count(id) as num_items
    from sqlps.line_items
    group by order_id
)
select u.id, coalesce(avg(num_items), 0) as avg_items_per_order
from sqlps.users u
    left join sqlps.orders o on u.id = o.user_id
    left join cte_lineItemCounts li on o.id = li.order_id
group by u.id
;

