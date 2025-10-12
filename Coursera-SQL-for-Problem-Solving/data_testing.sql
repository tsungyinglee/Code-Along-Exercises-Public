select * FROM sqlps.users;
select * from sqlps.orders;

-- calculate total number of orders by location
select u.locale, count(*) as total_orders
from sqlps.orders as o
LEFT JOIN sqlps.users as u
ON o.user_id = u.id
GROUP BY u.locale
ORDER BY total_orders DESC;

-- check if all user id in orders table exist in users table
select *
from sqlps.orders as o
LEFT JOIN sqlps.users as u
ON o.user_id = u.id
WHERE u.id IS NULL;

-- find users who have not placed any orders
select *
from sqlps.users as u
LEFT JOIN sqlps.orders as o
ON u.id = o.user_id
WHERE o.id IS NULL;