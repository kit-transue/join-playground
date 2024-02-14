DROP TABLE IF EXISTS contact;
DROP TABLE IF EXISTS phone;

CREATE TABLE contact (
    id INTEGER,
    name VARCHAR
);

CREATE TABLE phone (
    id INTEGER,
    number VARCHAR,
    contactid INTEGER,
    kind VARCHAR
);

INSERT INTO contact(id, name)
VALUES
(1, 'Sizwe'),
(2, 'Palomar'),
(3, 'Marvin');

INSERT INTO phone(id, number, contactid, kind)
VALUES
(1, '+27 (11) 243-9422', 1, 'office'),
(2, '+27 (81) 631-9414', 1, 'mobile'),
(3, '+1 814-339-1008', 2, 'home'),
(4, 'ext. 321', NULL, 'unassigned');
