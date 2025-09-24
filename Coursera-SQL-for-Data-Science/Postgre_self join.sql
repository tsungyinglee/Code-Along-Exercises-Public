-- Create a mock employee table with employee id, employee names, and a report_to column
CREATE TABLE mock_employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    report_to INT
);

-- Insert sample data into the mock_employee table
INSERT INTO mock_employee (emp_id, emp_name, report_to) VALUES
(1, 'Alice', NULL),  -- Alice is the top-level employee (no one to report to)
(2, 'Bob', 1),       -- Bob reports to Alice
(3, 'Charlie', 1),   -- Charlie reports to Alice
(4, 'David', 2),     -- David reports to Bob
(5, 'Eve', 2);       -- Eve reports to Bob

select * from mock_employee;

-- Perform a self-join to find each employee along with their manager's name
-- We join the mock_employee table (aliased as e1) with itself (aliased as e2)
-- on the condition that the report_to field of e1 matches the emp_id of e2
-- self join is helpful when you want to match rows within the same table
select 
    e1.emp_name as employee,
    e2.emp_name as manager
from mock_employee e1
right join mock_employee e2
on e1.report_to = e2.emp_id;

