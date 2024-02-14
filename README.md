---
title: Join Introduction and Cross Join
...



# Joins

The JOIN is a clause that is added to a SELECT to introduce a
second table, and to extract rows that are built by combining
some of the data from each of the tables.

A JOIN may have an "ON" clause, which filters how combinations are
made. By limiting the combinations to just those where Foreign Keys
match Primary Keys, a JOIN/ON can expand relationships in the
relational model.

## Kinds of JOIN

There are five ANSI/ISO/IEC joins:

| join | effect |
| ---- | ----------------------- |
| CROSS | Creates all possible pairings of rows from each table |
| INNER | Select paired rows from tables that satisfy the ON condition |
| LEFT | Like inner, but for rows in the first table that are not matched, match with record created with NULL attributes |
| RIGHT | Like left, but fill with NULLs for unmatched right rows |
| FULL | Pair using ON condition; any un-paired rows are matched with NULL records |

These are covered in detail next.


## CROSS JOIN

A CROSS JOIN combines each row of the FROM table with all the
rows of the JOIN table.

### Unspecified Many-to-Many

Consider this design:

```drawio
join-design
```

The design shows:

- a many:many relationship between alpha_start and alpha_end
- no attributes acting as FK or PK

#### Sample Data

```drawio
join-design
```

```drawio
join-table-contents
```


#### CROSS Combines

A CROSS JOIN combines each row with all other rows:

```drawio
join-cross-schematic
```

```sql
SELECT *
FROM alpha_start
CROSS JOIN alpha_end;
```

#### CROSS JOIN Results

```drawio {width=100%}
join-cross-table
```

All possible combinations are reported.

### CROSS JOIN Uses

- means "all combinations of"
- does not "follow" relationship keys
- illustrates how JOINs **combine** tables
- NOT VERY USEFUL/COMMON

<!--
## CROSS JOIN Example

Note: the cross join is not very common, and it should not be used
to connect relationships based on a foreign key (it is more efficient
to use one of the other JOIN...ON constructs).

```sql
SELECT c1, c2
FROM table1 optionalAlias1
CROSS JOIN table2 optionalAlias2;
```

Creates all possible combinations of rows from table1 and rows from table2:

```sql
CREATE TABLE pet(preference VARCHAR, median INTEGER);
CREATE TABLE pastaSauce(preference VARCHAR);
INSERT INTO pet VALUES ('has a dog', 1), ('has cats', 3);
INSERT INTO pastaSauce VALUES ('prefers Ragu'), ('prefers Prego');
-- cross join creates all permutations:
SELECT t1.preference, t2.preference FROM pet t1 CROSS JOIN pastasauce t2;
 preference |  preference   
------------+---------------
 has a dog  | prefers Ragu
 has cats   | prefers Ragu
 has a dog  | prefers Prego
 has cats   | prefers Prego
(4 rows)
```
-->

### CROSS JOIN Example: Multiplication Table

Given a single table:

```sql
CREATE TABLE onetwothree ( name VARCHAR, value INT);

INSERT INTO onetwothree VALUES
('one', 1),
('two', 2),
('three', 3);
```

#### CROSS JOIN on Self

It is possible to join on the same table (a "self-join"):

```sql
SELECT this.name,
       bythat.name,
       this.value * bythat.value as "equals"
FROM onetwothree AS this
CROSS JOIN onetwothree AS bythat;
```

Note that aliases are needed to name the left and the right
tables (here as "this" and "bythat") to make it clear which
table each column belongs to in the SELECT.


#### CROSS JOIN Output

(FROM onetwothree CROSS JOIN onetwothree)

```sql
 name  | name  | equals
-------+-------+--------
 one   | one   |      1
 one   | two   |      2
 one   | three |      3
 two   | one   |      2
 two   | two   |      4
 two   | three |      6
 three | one   |      3
 three | two   |      6
 three | three |      9
(9 rows)
```



## INNER JOIN ON

The INNER JOIN combines only rows that match/correspond-to/relate-to
each other, as defined by the ON expression. An INNER JOIN must include
an ON expression.

```sql
SELECT *
FROM alpha_start
INNER JOIN alpha_end
ON seq = pos;
```

### ON Match Expression Illustrated

```drawio {width=100%}
join-inner-matched
```

```sql
SELECT *
FROM alpha_start
INNER JOIN alpha_end
ON seq = pos;
```

### Non-Matching Rows

Any unmatched rows are not included in the INNER JOIN result.

```drawio {width=100%}
join-inner-unmatched
```


```sql
SELECT *
FROM alpha_start
INNER JOIN alpha_end
ON seq = pos - 1;
```

## LEFT and RIGHT JOINs

LEFT and RIGHT JOINs add output when one of the input rows is not
matched by the ON expression. Each unmatched row is treated as if
it matched with an entity from the other table that has NULL for all
its columns.

The LEFT or RIGHT identify the table that should have these extra
matches.

### LEFT/RIGHT Terminology

LEFT refers to the table written first in the source text (using SQL's
left-to-right parsing). RIGHT is the table that appears second. (Imagine
the source text is written out in one long line.)

LEFT is the table in the FROM clause. RIGHT is the table in the JOIN
clause.

#### Example

```sql
SELECT person.name, phone.number FROM person
JOIN phone ON person.id = phone.ownerid;
```

- "person" is LEFT table
- "phone" is RIGHT table
- formatting is not important
- "person" comes first
- "person" would be LEFT if written as one long line


### LEFT JOIN

- "LEFT JOIN" replaces "INNER JOIN"
- matches are made just like INNER JOIN using ON expression
- unmatched rows from the left table are added to the output, padded with NULL


```sql
SELECT *
FROM alpha_start
LEFT JOIN alpha_end
ON seq = pos - 1;
```

#### LEFT JOIN Illustration

```drawio {width=100%}
join-left
```

```sql
SELECT *
FROM alpha_start
LEFT JOIN alpha_end
ON seq = pos - 1;
```

### RIGHT JOIN

- "RIGHT JOIN" replaces "INNER JOIN"
- matches are made just like INNER JOIN using ON expression
- unmatched rows from the right table are added to the output, padded with NULL


```sql
SELECT *
FROM alpha_start
RIGHT JOIN alpha_end
ON seq = pos - 1;
```

#### RIGHT JOIN Illustration

```drawio {width=100%}
join-right
```

```sql
SELECT *
FROM alpha_start
RIGHT JOIN alpha_end
ON seq = pos - 1;
```

## FULL JOIN

FULL JOIN creates NULL-padded matches for unmatched rows
in both tables. All the data in both tables will be shown.

```sql
SELECT *
FROM alpha_start
FULL JOIN alpha_end
ON seq = pos - 1;
```

### FULL JOIN Illustration

```drawio {width=100%}
join-full
```

```sql
SELECT *
FROM alpha_start
FULL JOIN alpha_end
ON seq = pos - 1;
```

<!--
## JOIN Example

A JOIN operates on two tables (possibly the same table, but
independently).  Most JOINs require an ON clause to define how the
table rows should be related. The ON associates the foreign keys in
one table with the primary keys in the table they reference.

Starting with two tables that relate using the FK "phone.contactid"
that contains a value from the PK "contact.id":


```
SELECT * FROM contact;
 id |  name   
----+---------
  1 | Sizwe
  2 | Palomar
  3 | Marvin
(3 rows)

SELECT * FROM phone;
 contactid |    kind    |      number       
-----------+------------+-------------------
         1 | office     | +27 (11) 243-9422
         1 | mobile     | +27 (81) 631-9414
         2 | home       | +1 814-339-1008
           | unassigned | ext. 321
(4 rows)
```

The JOIN brings the number table in, and the ON explains
how the PK/FK values should be matched:

```
SELECT contact.name, number.kind, number.number
FROM contact
LEFT JOIN number
ON number.contactid = contact.id;
  name   |  kind  |      number       
---------+--------+-------------------
 Sizwe   | office | +27 (11) 243-9422
 Sizwe   | mobile | +27 (81) 631-9414
 Palomar | home   | +1 814-339-1008
 Marvin  |        | 
(4 rows)
```


## JOIN Generalities

### LEFT/RIGHT

All JOINS involve two tables: one named in the FROM clause of a
select, the other from the JOIN clause. The first is called the "left
table" because it appears first/left if the statement is written as a
single line; the second is the "right table" by the same logic.

### Column ambiguity

As always, the "SELECT" clause indicates what columns should be
included in the output. ON and WHERE clauses refer to columns.
Since there are two tables involved in a JOIN, it is necessary to
be clear which table/column is being referred to at all times.

Consider using AS and table aliases (covered later in "Naming") to
clarify names and simplify your code.




## JOIN Syntax

- column names can be qualified with "table.columnname" or "alias.columnname"
- table aliases are made by giving the alias name separated by a space after the table name use in the SELECT/JOIN
- SELECTs from joins can be additionally filtered with WHERE clauses


```sql
SELECT c1, c2
FROM table1 optionalAlias1
CROSS JOIN table2 optionalAlias2;
```

-->




<!-- DO NOT INCLUDE: 
### Old-style join using WHERE

Before ANSI/ISO introduced the more-efficient (and more clear) JOIN..ON that
we cover next, SQL used a cross join to de-normalize tables.

Starting with a cross join of all combinations (like: <code>SELECT c.name, n.kind, n.number FROM contact c CROSS JOIN number n</code>),
the join added a WHERE clause to filter only the rows where the relation
was valid:

```sql
SELECT c.name, n.kind, n.number
  FROM contact c
    CROSS JOIN number n
  WHERE c.id = n.contactid;
  name   |  kind  |      number       
---------+--------+-------------------
 Sizwe   | office | +27 (11) 243-9422
 Sizwe   | mobile | +27 (81) 631-9414
 Palomar | home   | +1 814-339-1008
(3 rows)
```

Writing this style join makes a lot of work somewhere: either it causes
a lot of extra work in expansion, or it requires smarts in the database
to realize the WHERE clause makes the result more of a pairing of IDs
and not a true "all combinations" expansion.

This extra work was the driver for ANSI/ISO to introduce the "JOIN..ON"
style of joins.
-->
