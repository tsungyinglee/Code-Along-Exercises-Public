-- Drop the table `shoes` if it already exists to avoid conflicts
DROP TABLE IF EXISTS shoes;

-- Create the `shoes` table with columns for various attributes of shoes
CREATE TABLE shoes (
    id SERIAL PRIMARY KEY, -- Unique identifier for each shoe
    brand VARCHAR(30) NOT NULL, -- Brand name of the shoe
    model VARCHAR(50) NOT NULL, -- Model name of the shoe
    size NUMERIC(3, 1) NOT NULL, -- Size of the shoe
    color VARCHAR(50), -- Color of the shoe (optional)
    price NUMERIC(10, 2) NOT NULL, -- Price of the shoe
    description VARCHAR(750), -- Description of the shoe (optional)
    shoe_type VARCHAR(10) CHECK (shoe_type IN ('sandals', 'shoes')) NOT NULL, -- Type of shoe (either 'sandals' or 'shoes')
    order_units INT DEFAULT 0 -- Number of units ordered (default is 0)
);

-- Insert sample data into the `shoes` table
INSERT INTO shoes (
        brand,
        model,
        size,
        color,
        price,
        description,
        shoe_type,
        order_units
    )
VALUES 
    (
        'Nike',
        'Air Max',
        9.5,
        NULL,
        120.00,
        'Comfortable running shoes with air cushioning.',
        'shoes',
        50
    ),
    (
        'Adidas',
        'Ultraboost',
        10,
        'Black',
        180.00,
        NULL,
        'shoes',
        30
    ),
    (
        'Puma',
        'Suede Classic',
        8,
        'Blue',
        70.00,
        'Classic suede sneakers with a timeless design.',
        'shoes',
        20
    ),
    (
        'Reebok',
        'Nano X1',
        11,
        NULL,
        130.00,
        NULL,
        'shoes',
        40
    ),
    (
        'New Balance',
        '574',
        9,
        'Grey',
        80.00,
        'Iconic lifestyle sneakers with a retro look.',
        'shoes',
        25
    ),
    (
        'Birkenstock',
        'Arizona',
        10.5,
        'Brown',
        100.00,
        'Classic sandals with contoured cork footbed for comfort.',
        'sandals',
        15
    ),
    (
        'Teva',
        'Hurricane XLT2',
        9,
        NULL,
        75.00,
        'Durable sandals designed for outdoor adventures.',
        'sandals',
        10
    ),
    (
        'Chaco',
        'Z/1 Classic',
        8.5,
        'Black',
        95.00,
        NULL,
        'sandals',
        12
    ),
    (
        'Crocs',
        'Classic Clog',
        10,
        'Navy',
        50.00,
        'Lightweight and comfortable clogs perfect for casual wear.',
        'sandals',
        18
    ),
    (
        'Keen',
        'Newport H2',
        11,
        NULL,
        110.00,
        'Waterproof sandals with toe protection for outdoor activities.',
        'sandals',
        22
    );

-- Query to retrieve all shoes
SELECT *
FROM shoes;

-- Query to retrieve all sandals and store them in a temporary table
CREATE TEMPORARY TABLE sandals AS
SELECT *
FROM shoes
WHERE shoe_type = 'sandals'
;

-- Query to retrieve all Birkenstock sandals
DROP TABLE IF EXISTS birkenstock_sandals;
CREATE TABLE birkenstock_sandals AS
SELECT *
FROM sandals
WHERE brand = 'Birkenstock'
;