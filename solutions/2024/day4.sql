DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

DROP TABLE IF EXISTS toy_production CASCADE;
CREATE TABLE toy_production (
                                toy_id INT,
                                toy_name VARCHAR(100),
                                previous_tags TEXT[],
                                new_tags TEXT[]
);

INSERT INTO toy_production VALUES
                               (1, 'Robot', ARRAY['fun', 'battery'], ARRAY['smart', 'battery', 'educational', 'scientific']),
                               (2, 'Doll', ARRAY['cute', 'classic'], ARRAY['cute', 'collectible', 'classic']),
                               (3, 'Puzzle', ARRAY['brain', 'wood'], ARRAY['educational', 'wood', 'strategy']);


/**
Sample result:
toy_id | toy_name |           added_tags           | unchanged_tags | removed_tags
-------+----------+--------------------------------+----------------+--------------
     1 | Robot    | {scientific,educational,smart} | {battery}      | {fun}
     3 | Puzzle   | {strategy,educational}         | {wood}         | {brain}
     2 | Doll     | {collectible}                  | {classic,cute} | {}
 */

SELECT
    toy_id,
    toy_name,
    CARDINALITY(new_tags) - unchanged_tags AS added_tags,
    unchanged_tags,
    CARDINALITY(previous_tags) - unchanged_tags AS removed_tags
FROM
    toy_production,
    CARDINALITY(ARRAY(
        SELECT UNNEST(new_tags) AS new_tag
        INTERSECT
        SELECT UNNEST(previous_tags) AS previous_tag
    )) AS unchanged_tags
ORDER BY
    added_tags DESC
LIMIT 1
