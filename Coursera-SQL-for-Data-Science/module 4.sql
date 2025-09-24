-- Example of concatenation with || operator
select company,
    phone,
    company || ' (' || phone || ')' as company_info
FROM customer
;

-- Example of using trim functions to remove whitespace from strings
select trim('    You the best!    ') as trimmed_string,
    length(trim('    You the best!    ')) as trimmed_length,
    rtrim('    You the best!    ') as rtrimmed_string,
    length(rtrim('    You the best!    ')) as rtrimmed_length,
    ltrim('    You the best!    ') as ltrimmed_string,
    length(ltrim('    You the best!    ')) as ltrimmed_length
;


-- Example of using substr function to extract a substring from a string
select first_name,
    substr(first_name, 3, 5) as substring_example,
    substr(first_name, 1, 3) as first_three_chars
FROM customer
;

-- Example of using string case functions to change the case of strings
select upper(first_name) as upper_first_name,
    lower(first_name) as lower_first_name,
    initcap(first_name) as initcap_first_name
FROM customer
;

-- Example of using date functions to manipulate and format dates
select invoice_date,
    date(invoice_date) as just_date
from invoice
;

/****************************************************
    * DATETIME VARIABLE
    ***************************************************/

-- Example of creating a table with a datetime variable
DROP TABLE IF EXISTS event_log;
CREATE TABLE event_log (
    event_id INTEGER PRIMARY KEY,
    event_name TEXT NOT NULL,
    event_timestamp TIMESTAMP NOT NULL,
    event_timestamp_with_tz TIMESTAMPTZ NOT NULL
);

-- Insert sample data into the event_log table
INSERT INTO event_log (event_id, event_name, event_timestamp, event_timestamp_with_tz)
VALUES
    (1, 'User Login', '2023-10-01 08:30:00', '2023-10-01 08:30:00+00'),
    (2, 'File Upload', '2023-10-01 09:15:00', '2023-10-01 09:15:00+00'),
    (3, 'User Logout', '2023-10-01 10:00:00', '2023-10-01 10:00:00+00');

-- Query the event_log table
SELECT * FROM event_log;

-- Example of extracting components from a timestamp using EXTRACT function
SELECT event_id,
    event_name,
    event_timestamp,
    event_timestamp_with_tz,
    EXTRACT(YEAR FROM event_timestamp) AS event_year,
    EXTRACT(MONTH FROM event_timestamp) AS event_month,
    EXTRACT(DAY FROM event_timestamp) AS event_day,
    EXTRACT(HOUR FROM event_timestamp_with_tz) AS event_hour,
    EXTRACT(MINUTE FROM event_timestamp_with_tz) AS event_minute,
    EXTRACT(SECOND FROM event_timestamp_with_tz) AS event_second,
    EXTRACT(TIMEZONE_HOUR FROM event_timestamp_with_tz) AS timezone_hour,
    EXTRACT(TIMEZONE_MINUTE FROM event_timestamp_with_tz) AS timezone_minute,
    EXTRACT(DOW FROM event_timestamp) AS day_of_week,
    EXTRACT(DOY FROM event_timestamp) AS day_of_year,
    EXTRACT(EPOCH FROM event_timestamp) AS epoch_time,
    EXTRACT(JULIAN FROM event_timestamp) AS julian_day
FROM event_log
;

-- Example of formatting timestamps using TO_CHAR function
SELECT event_id,
    event_name,
    event_timestamp,
    TO_CHAR(event_timestamp, 'YYYY-MM-DD HH24:MI:SS') AS formatted_timestamp,
    TO_CHAR(event_timestamp, 'Month DD, YYYY') AS long_date_format,
    TO_CHAR(event_timestamp, 'DD/MM/YYYY') AS european_date_format,
    TO_CHAR(event_timestamp, 'YYYY-MM-DD') AS iso_date_format,
    TO_CHAR(event_timestamp, 'MM-DD-YYYY') AS us_date_format,
    TO_CHAR(event_timestamp, 'YYYYMMDD') AS compact_date_format,
    TO_CHAR(event_timestamp, 'HH24:MI:SS') AS time_part
FROM event_log
;

-- Example of using modifiers with timestring functions
SELECT event_id,
    event_name,
    event_timestamp,
    event_timestamp + INTERVAL '1 day' AS next_day,
    event_timestamp - INTERVAL '1 hour' AS one_hour_before,
    event_timestamp + INTERVAL '2 weeks' AS two_weeks_later,
    event_timestamp + INTERVAL '3 months' AS three_months_later,
    event_timestamp + INTERVAL '1 year' AS next_year
FROM event_log;

-- Example of using the NOW() function with modifiers
SELECT NOW() AS current_time,
    NOW() + INTERVAL '1 day' AS tomorrow,
    NOW() - INTERVAL '1 week' AS last_week,
    NOW() + INTERVAL '1 month' AS next_month,
    NOW() + INTERVAL '5 years' AS five_years_later;

/****************************************************
    * CASE STATEMENT EXERCISE
    ***************************************************/

-- Example of using CASE statements to create conditional logic
SELECT first_name,
    last_name,
    city,
    -- Simple CASE statement example
    -- using input expression city to compare with values
    CASE city
        when 'Calgary' then 'Calgary'
        else 'Other'
        end as Calgary,
    -- Search CASE statement example
    -- not using input expression but boolean conditions directly
    CASE
        WHEN city = 'Calgary' then 'Calgary'
        WHEN city = 'Edmonton' then 'Edmonton'
        ELSE 'Other'
    END AS city_group,
    case 
        when city = 'Calgary' then 1
        else 0
    end as is_calgary
FROM employee;

-- Another Search CASE statement example
-- Categorizing tracks based on their byte size into Small, Medium, and Large
-- bins: Small (<3,000,000), Medium (3,000,001 to 5,000,000), Large (>5,000,000)
select track_id,
    name, 
    bytes,
    CASE 
        WHEN bytes < 3000000 THEN 'Small'
        WHEN bytes BETWEEN 3000001 AND 5000000 THEN 'Medium'
        WHEN bytes >= 5000001 THEN 'Large'
        ELSE 'Other'
    END AS size_category
from track
;

select color,
    CASE
        WHEN color = 'Red' THEN 'Red'
        WHEN color = 'Black' THEN 'Black'
        -- leave out ELSE to return NULL for other colors
    END AS color_group
from shoes
;


/****************************************************
    * NULL COMPARISON EXAMPLE
    ***************************************************/

-- Example to demonstrate whether NULL is considered < 0
SELECT 
    -1 AS test_value,
    CASE 
        WHEN -1 < 0 THEN 'True'
        ELSE 'False'
    END AS is_negative,
    NULL AS test_value_null,
    CASE 
        WHEN NULL < 0 THEN 'True'
        ELSE 'False'
    END AS is_null_less_than_zero
FROM 
    (SELECT 1) AS dummy;


/****************************************************
    * VIEW EXERCISES
    * VIEW is a stored query that you can reference like a table.
    * VIEW does not store data physically, but dynamically retrieves data from the underlying tables when queried.
    * VIEW is temporary and only exists during the session.
    * You can use views to simplify complex queries.
    ***************************************************/

-- Example of creating a view to simplify complex queries
DROP VIEW IF EXISTS artist_album_track_view;
CREATE VIEW artist_album_track_view AS
select 
    artist.name as artist_name,
    album.title as album_title,
    track.name as track_name,
    track.unit_price as track_price
from artist artist
inner join album album on artist.artist_id = album.artist_id
inner join track track on album.album_id = track.album_id
where artist.name like 'Audioslave'
;
select * from artist_album_track_view;

-- Example of querying a view to aggregate data
select 
    artist_name,
    album_title,
    count(track_name) as total_tracks, 
    sum(track_price) as total_price
from artist_album_track_view
group by artist_name, album_title
;

