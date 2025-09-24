-- Create a table with values 1 to 5
create table numbers (
    num int
);

insert into numbers (num)
values (1), (2), (3), (4), (5);

-- Create a table with values A to E
create table letters (
    letter char(1)
);

insert into letters (letter)
values ('A'), ('B'), ('C'), ('D'), ('E');

select num, 
    letter
from numbers cross JOIN letters
;