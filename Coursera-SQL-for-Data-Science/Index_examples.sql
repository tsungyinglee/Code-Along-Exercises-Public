-- Create the customer_sf100_mock table
DROP TABLE IF EXISTS customer_sf100_mock;
CREATE TABLE customer_sf100_mock (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    mktsegment VARCHAR(50)
);

-- Insert 15 million records into the table
-- Distribute 'HOUSEHOLD' and other random values in the mktsegment column
INSERT INTO customer_sf100_mock (name, mktsegment)
SELECT 
    'Customer_' || i AS name,
    CASE 
        WHEN i % 5 = 0 THEN 'HOUSEHOLD'  -- 20% of the records will have 'HOUSEHOLD'
        WHEN i % 4 = 1 THEN 'AUTOMOTIVE'
        WHEN i % 4 = 2 THEN 'TECHNOLOGY'
        WHEN i % 4 = 3 THEN 'FASHION'
        ELSE 'FOOD'
    END AS mktsegment
FROM generate_series(1, 15000000) AS i;

SELECT COUNT(*)
FROM customer_sf100_mock;

SELECT * 
FROM customer_sf100_mock
WHERE mktsegment = 'HOUSEHOLD'
LIMIT 100;

-- Query without an index
-- This will perform a full table scan
EXPLAIN ANALYZE
SELECT * FROM customer_sf100_mock WHERE mktsegment = 'HOUSEHOLD';

-- Query with the index
-- Create an index on the mktsegment column to improve the performance of queries
-- that filter by mktsegment, such as WHERE mktsegment = 'HOUSEHOLD'.
-- This index allows the database to quickly locate relevant rows without scanning the entire table.
CREATE INDEX idx_mktsegment ON customer_sf100_mock(mktsegment);
EXPLAIN ANALYZE
SELECT * FROM customer_sf100_mock WHERE mktsegment = 'HOUSEHOLD';

-- Drop the index after testing (cleanup step, not recommended in production environments)
DROP INDEX idx_mktsegment;