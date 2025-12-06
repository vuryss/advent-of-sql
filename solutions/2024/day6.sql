DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

DROP TABLE IF EXISTS children CASCADE;
DROP TABLE IF EXISTS gifts CASCADE;
CREATE TABLE children (
                          child_id SERIAL PRIMARY KEY,
                          name VARCHAR(100),
                          age INTEGER,
                          city VARCHAR(100)
);
CREATE TABLE gifts (
                       gift_id SERIAL PRIMARY KEY,
                       name VARCHAR(100),
                       price DECIMAL(10,2),
                       child_id INTEGER REFERENCES children(child_id)
);


INSERT INTO children (name, age, city) VALUES
                                           ('Tommy', 8, 'London'),
                                           ('Sarah', 7, 'London'),
                                           ('James', 9, 'Paris'),
                                           ('Maria', 6, 'Madrid'),
                                           ('Lucas', 10, 'Berlin');

INSERT INTO gifts (name, price, child_id) VALUES
                                              ('Robot Dog', 45.99, 1),
                                              ('Paint Set', 15.50, 2),
                                              ('Gaming Console', 299.99, 3),
                                              ('Book Collection', 25.99, 4),
                                              ('Chemistry Set', 109.99, 5);

/**
Write a query that returns the name of each child and the name and price of their gift, but only for children who received gifts more expensive than the average gift price.
The results should be ordered by the gift price in ascending order.

Give the name of the child with the first gift thats higher than the average.

Example solution
 child_name |   gift_name    | gift_price
------------+----------------+------------
 Lucas      | Chemistry Set  |     109.99
 James      | Gaming Console |     299.99
 */

WITH AverageGiftPrice AS (
    SELECT
        AVG(price) AS average_price
    FROM
        gifts
)
SELECT
    *
FROM
    children c
INNER JOIN
    gifts g on c.child_id = g.child_id
CROSS JOIN AverageGiftPrice
WHERE
    g.price > AverageGiftPrice.average_price
ORDER BY
    g.price ASC
LIMIT 1
