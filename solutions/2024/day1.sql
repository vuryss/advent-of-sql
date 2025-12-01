DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE children (
                          child_id INT PRIMARY KEY,
                          name VARCHAR(100),
                          age INT
);
CREATE TABLE wish_lists (
                            list_id INT PRIMARY KEY,
                            child_id INT,
                            wishes JSON,
                            submitted_date DATE
);
CREATE TABLE toy_catalogue (
                               toy_id INT PRIMARY KEY,
                               toy_name VARCHAR(100),
                               category VARCHAR(50),
                               difficulty_to_make INT
);


INSERT INTO children VALUES
                         (1, 'Tommy', 8),
                         (2, 'Sally', 7),
                         (3, 'Bobby', 9);

INSERT INTO wish_lists VALUES
                           (1, 1, '{"first_choice": "bike", "second_choice": "blocks", "colors": ["red", "blue"]}', '2024-11-01'),
                           (2, 2, '{"first_choice": "doll", "second_choice": "books", "colors": ["pink", "purple"]}', '2024-11-02'),
                           (3, 3, '{"first_choice": "blocks", "second_choice": "bike", "colors": ["green"]}', '2024-11-03');

INSERT INTO toy_catalogue VALUES
                              (1, 'bike', 'outdoor', 3),
                              (2, 'blocks', 'educational', 1),
                              (3, 'doll', 'indoor', 2),
                              (4, 'books', 'educational', 1);

/**
  Sample result:
  name  | primary_wish | backup_wish | favorite_color | color_count | gift_complexity | workshop_assignment
  ----------------------------------------------------------------------------------------------------------
  Tommy | bike         | blocks      | red            | 2           | Complex Gift    | Outside Workshop
  Sally | doll         | books       | pink           | 2           | Moderate Gift   | General Workshop
  Bobby | blocks       | bike        | green          | 1           | Simple Gift    | Learning Workshop

  Gift complexity can be mapped from the toy difficulty to make. Assume the following:

    Simple Gift = 1
    Moderate Gift = 2
    Complex Gift >= 3

  We assign the workshop based on the primary wish's toy category. Assume the following:

  outdoor = Outside Workshop
  educational = Learning Workshop
  all other types = General Workshop
 */

SELECT
    children.name,
    wish_lists.wishes ->> 'first_choice' AS primary_wish,
    wish_lists.wishes ->> 'second_choice' AS backup_wish,
    wish_lists.wishes -> 'colors' ->> 0 AS favorite_color,
    json_array_length(wish_lists.wishes -> 'colors') AS color_count,
    CASE
        WHEN toy_catalogue.difficulty_to_make = 1 THEN 'Simple Gift'
        WHEN toy_catalogue.difficulty_to_make = 2 THEN 'Moderate Gift'
        ELSE 'Complex Gift'
    END AS gift_complexity,
    CASE
        WHEN toy_catalogue.category = 'outdoor' THEN 'Outside Workshop'
        WHEN toy_catalogue.category = 'educational' THEN 'Learning Workshop'
        ELSE 'General Workshop'
    END AS workshop_assignment
FROM children
INNER JOIN wish_lists ON children.child_id = wish_lists.child_id
INNER JOIN toy_catalogue ON (wish_lists.wishes ->> 'first_choice') = toy_catalogue.toy_name
ORDER BY children.name
LIMIT 5;
