
-- Find all customers who have placed orders with a total price greater than 500,000.
-- Then, for those customers, retrieve their customer key, nation key, and market segment.
select custkey,
    nationkey, 
    mktsegment
from sf1.customer
where custkey in (
    select custkey
    from sf1.orders
    where totalprice > 500000
)
;
-- note: the innermost subquery is executed first,
-- then the outer query uses the results of the inner query to filter the customer table.


-- checking the intermediate results
select custkey,
    totalprice
from sf1.orders
where custkey in (128120, 46435)
order by custkey, totalprice desc
;

-- checking the intermediate results
select custkey,
    nationkey,
    mktsegment
from sf1.customer
where custkey in (128120, 46435)
;

-- example of cross join (cartesian product)
select totalprice, 
    orderdate, 
    name
from tiny.supplier cross JOIN tiny.orders;

-- example of inner join
select supplier.suppkey,
    supplier.name, 
    lineitem.shipmode
from tiny.supplier inner JOIN tiny.lineitem
on supplier.suppkey = lineitem.suppkey
;

-- example of inner join with multiple tables
-- Find the total price of each order, the name of the customer who placed the order,
-- the shipping mode of the order, and the name of the supplier for each line item in the order.
-- Join the `orders`, `customer`, `lineitem`, and `supplier` tables on their respective keys.
SELECT o.totalprice,
    c.name AS customer_name,
    l.shipmode,
    s.name AS supplier_name
from tiny.orders o
inner join tiny.customer c on o.custkey = c.custkey
inner join tiny.lineitem l on o.orderkey = l.orderkey
inner join tiny.supplier s on l.suppkey = s.suppkey
;


-- example of left join
-- Retrieve all customers and their corresponding orders, if any.
-- If a customer has not placed any orders, still include the customer in the result.
select c.custkey,
    c.name as customer_name,
    o.orderkey,
    o.totalprice
from tiny.customer c
left join tiny.orders o on c.custkey = o.custkey
;

-- example of right join
-- Retrieve all orders and their corresponding customers, if any.
-- If an order does not have a corresponding customer, still include the order in the result.
select o.orderkey,
    o.totalprice,
    c.custkey,
    c.name as customer_name
from tiny.orders o
right join tiny.customer c on o.custkey = c.custkey
;

-- example of full outer join
-- Retrieve all customers and their corresponding orders, if any.
-- Include customers without orders and orders without customers.
select c.custkey,
    c.name as customer_name,
    o.orderkey,
    o.totalprice
from tiny.customer c
full outer join tiny.orders o on c.custkey = o.custkey
;

-- example of union
-- Retrieve all customer keys from both the `customer` and `orders` tables.
-- Remove duplicates in the result.
select custkey
from tiny.customer
union
select custkey
from tiny.orders
;

