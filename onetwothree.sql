DROP TABLE IF EXISTS onetwothree;

CREATE TABLE onetwothree ( name VARCHAR, value INTEGER);

INSERT INTO onetwothree VALUES
('one', 1),
('two', 2),
('three', 3);


-- Query:
-- Use the CROSS JOIN (on self!) to create a multiplication table.
-- Output should have three columns:
-- - "left": the "value" column of the left operand (this is INTEGER type: prints as base-10 number)
-- - "right": the "name" column of the right operand ("name" is the spelled-out number)
-- - "product": the left and right value columns multiplied together
