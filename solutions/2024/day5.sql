DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

DROP TABLE IF EXISTS toy_production CASCADE;
CREATE TABLE toy_production (
                                production_date DATE PRIMARY KEY,
                                toys_produced INTEGER
);

INSERT INTO toy_production (production_date, toys_produced) VALUES
                                                                ('2024-12-18', 500),
                                                                ('2024-12-19', 550),
                                                                ('2024-12-20', 525),
                                                                ('2024-12-21', 600),
                                                                ('2024-12-22', 580),
                                                                ('2024-12-23', 620),
                                                                ('2024-12-24', 610);

/**

Example Answer
 production_date | toys_produced | previous_day_production | production_change | production_change_percentage
-----------------+---------------+-------------------------+-------------------+------------------------------
 2024-12-21      |           600 |                     525 |                75 |                        14.29
 2024-12-19      |           550 |                     500 |                50 |                        10.00
 2024-12-23      |           620 |                     580 |                40 |                         6.90
 2024-12-24      |           610 |                     620 |               -10 |                        -1.61
 2024-12-22      |           580 |                     600 |               -20 |                        -3.33
 2024-12-20      |           525 |                     550 |               -25 |                        -4.55
 2024-12-18      |           500 |                         |                   |

 */

SELECT
    today.production_date,
    today.toys_produced,
    yesterday.toys_produced AS previous_day_production,
    today.toys_produced - yesterday.toys_produced AS production_change,
    ROUND((today.toys_produced - yesterday.toys_produced) * 100.0 / yesterday.toys_produced, 2) AS production_change_percentage
FROM
    toy_production AS today
LEFT JOIN
    toy_production AS yesterday ON yesterday.production_date = today.production_date - INTERVAL '1 day'
WHERE
    yesterday.toys_produced IS NOT NULL
ORDER BY
    production_change_percentage DESC
LIMIT 1
