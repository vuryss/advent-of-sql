DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

DROP TABLE IF EXISTS christmas_menus CASCADE;

CREATE TABLE christmas_menus (
                                 id SERIAL PRIMARY KEY,
                                 menu_data XML
);

WITH
    ValidMenuData AS (
        SELECT
            menu_data
        FROM
            christmas_menus
        WHERE
            CASE (xpath('/*/@version', menu_data))[1]::text
                WHEN '1.0' THEN (xpath('//total_count/text()', menu_data))[1]::text::integer
                WHEN '2.0' THEN (xpath('//total_guests/text()', menu_data))[1]::text::integer
                ELSE (xpath('//total_present/text()', menu_data))[1]::text::integer
                END > 78
    ),
    ExtractedData AS (
        SELECT
            x.food_item_id
        FROM
            ValidMenuData as vmd,
            XMLTABLE(
                '//food_item_id' PASSING vmd.menu_data
                COLUMNS food_item_id INT PATH '.'
            ) AS x
    )
SELECT
    food_item_id,
    COUNT(food_item_id) AS frequency
FROM
    ExtractedData
GROUP BY
    food_item_id
ORDER BY
    frequency DESC
LIMIT 1
