SELECT
  creator.ATTR->'$.FIRST_NAME' AS firstName,
  creator.ATTR->'$.LAST_NAME' AS lastName,
  message.VID AS commentId,
  IF (
    message.ATTR->'$.CONTENT' = "",
    message.ATTR->'$.IMAGE_FILE',
    message.ATTR->'$.CONTENT'
  ) content,
  message.ATTR->'$.CREATION_DATE' AS creationdate
FROM (
  SELECT
    f_fof_fofof_fofofof.VID AS personId,
    CASE
      WHEN f_fof_fofof_fofofof.LBL1 = "HAS_CREATOR" THEN f_fof_fofof_fofofof.VAL1
      WHEN f_fof_fofof_fofofof.LBL2 = "HAS_CREATOR" THEN f_fof_fofof_fofofof.VAL2
      WHEN f_fof_fofof_fofofof.LBL3 = "HAS_CREATOR" THEN f_fof_fofof_fofofof.VAL3
      WHEN f_fof_fofof_fofofof.LBL4 = "HAS_CREATOR" THEN f_fof_fofof_fofofof.VAL4
      WHEN f_fof_fofof_fofofof.LBL5 = "HAS_CREATOR" THEN f_fof_fofof_fofofof.VAL5
      WHEN f_fof_fofof_fofofof.LBL6 = "HAS_CREATOR" THEN f_fof_fofof_fofofof.VAL6
      WHEN f_fof_fofof_fofofof.LBL7 = "HAS_CREATOR" THEN f_fof_fofof_fofofof.VAL7
      WHEN f_fof_fofof_fofofof.LBL8 = "HAS_CREATOR" THEN f_fof_fofof_fofofof.VAL8
      WHEN f_fof_fofof_fofofof.LBL9 = "HAS_CREATOR" THEN f_fof_fofof_fofofof.VAL9
    END AS hasMessage
  FROM (
    SELECT friends.*
    FROM (
      SELECT
        CASE
          WHEN person.LBL1 = "KNOWS" THEN person.VAL1
          WHEN person.LBL2 = "KNOWS" THEN person.VAL2
          WHEN person.LBL3 = "KNOWS" THEN person.VAL3
          WHEN person.LBL4 = "KNOWS" THEN person.VAL4
          WHEN person.LBL5 = "KNOWS" THEN person.VAL5
          WHEN person.LBL6 = "KNOWS" THEN person.VAL6
          WHEN person.LBL7 = "KNOWS" THEN person.VAL7
          WHEN person.LBL8 = "KNOWS" THEN person.VAL8
          WHEN person.LBL9 = "KNOWS" THEN person.VAL9
          WHEN person.LBL10 = "KNOWS" THEN person.VAL10
        END AS knows
      FROM OPA person
      WHERE person.VID = 1502199023259437
    ) AS person_relation
    LEFT JOIN OSA friends_relation ON (friends_relation.VALID = person_relation.knows)
    JOIN IPA friends ON COALESCE(friends_relation.VAL, person_relation.knows) = friends.VID
    UNION
    SELECT fof.*
    FROM (
      SELECT
        friends.*,
        CASE
          WHEN friends.LBL1 = "KNOWS" THEN friends.VAL1
          WHEN friends.LBL2 = "KNOWS" THEN friends.VAL2
          WHEN friends.LBL3 = "KNOWS" THEN friends.VAL3
          WHEN friends.LBL4 = "KNOWS" THEN friends.VAL4
          WHEN friends.LBL5 = "KNOWS" THEN friends.VAL5
          WHEN friends.LBL6 = "KNOWS" THEN friends.VAL6
          WHEN friends.LBL7 = "KNOWS" THEN friends.VAL7
          WHEN friends.LBL8 = "KNOWS" THEN friends.VAL8
          WHEN friends.LBL9 = "KNOWS" THEN friends.VAL9
          WHEN friends.LBL10 = "KNOWS" THEN friends.VAL10
        END AS fKnows
      FROM (
        SELECT
          CASE
            WHEN person.LBL1 = "KNOWS" THEN person.VAL1
            WHEN person.LBL2 = "KNOWS" THEN person.VAL2
            WHEN person.LBL3 = "KNOWS" THEN person.VAL3
            WHEN person.LBL4 = "KNOWS" THEN person.VAL4
            WHEN person.LBL5 = "KNOWS" THEN person.VAL5
            WHEN person.LBL6 = "KNOWS" THEN person.VAL6
            WHEN person.LBL7 = "KNOWS" THEN person.VAL7
            WHEN person.LBL8 = "KNOWS" THEN person.VAL8
            WHEN person.LBL9 = "KNOWS" THEN person.VAL9
            WHEN person.LBL10 = "KNOWS" THEN person.VAL10
          END AS knows
        FROM OPA person
        WHERE person.VID = 1502199023259437
      ) AS person_relation
      LEFT JOIN OSA friends_relation ON (friends_relation.VALID = person_relation.knows)
      JOIN OPA friends ON COALESCE(friends_relation.VAL, person_relation.knows) = friends.VID
    ) AS friends
    LEFT JOIN OSA fof_relation ON (fof_relation.VALID = friends.fKnows)
    JOIN IPA fof ON COALESCE(fof_relation.VAL, friends.fKnows) = fof.VID
    UNION
    SELECT fofof.*
    FROM (
      SELECT fof.*,
        CASE
          WHEN fof.LBL1 = "KNOWS" THEN fof.VAL1
          WHEN fof.LBL2 = "KNOWS" THEN fof.VAL2
          WHEN fof.LBL3 = "KNOWS" THEN fof.VAL3
          WHEN fof.LBL4 = "KNOWS" THEN fof.VAL4
          WHEN fof.LBL5 = "KNOWS" THEN fof.VAL5
          WHEN fof.LBL6 = "KNOWS" THEN fof.VAL6
          WHEN fof.LBL7 = "KNOWS" THEN fof.VAL7
          WHEN fof.LBL8 = "KNOWS" THEN fof.VAL8
          WHEN fof.LBL9 = "KNOWS" THEN fof.VAL9
          WHEN fof.LBL10 = "KNOWS" THEN fof.VAL10
        END AS fofKnows
      FROM (
        SELECT
          friends.*,
          CASE
            WHEN friends.LBL1 = "KNOWS" THEN friends.VAL1
            WHEN friends.LBL2 = "KNOWS" THEN friends.VAL2
            WHEN friends.LBL3 = "KNOWS" THEN friends.VAL3
            WHEN friends.LBL4 = "KNOWS" THEN friends.VAL4
            WHEN friends.LBL5 = "KNOWS" THEN friends.VAL5
            WHEN friends.LBL6 = "KNOWS" THEN friends.VAL6
            WHEN friends.LBL7 = "KNOWS" THEN friends.VAL7
            WHEN friends.LBL8 = "KNOWS" THEN friends.VAL8
            WHEN friends.LBL9 = "KNOWS" THEN friends.VAL9
            WHEN friends.LBL10 = "KNOWS" THEN friends.VAL10
          END AS fKnows
        FROM (
          SELECT
            CASE
              WHEN person.LBL1 = "KNOWS" THEN person.VAL1
              WHEN person.LBL2 = "KNOWS" THEN person.VAL2
              WHEN person.LBL3 = "KNOWS" THEN person.VAL3
              WHEN person.LBL4 = "KNOWS" THEN person.VAL4
              WHEN person.LBL5 = "KNOWS" THEN person.VAL5
              WHEN person.LBL6 = "KNOWS" THEN person.VAL6
              WHEN person.LBL7 = "KNOWS" THEN person.VAL7
              WHEN person.LBL8 = "KNOWS" THEN person.VAL8
              WHEN person.LBL9 = "KNOWS" THEN person.VAL9
              WHEN person.LBL10 = "KNOWS" THEN person.VAL10
            END AS knows
          FROM OPA person
          WHERE person.VID = 1502199023259437
        ) AS person_relation
        LEFT JOIN OSA friends_relation ON (friends_relation.VALID = person_relation.knows)
        JOIN OPA friends ON COALESCE(friends_relation.VAL, person_relation.knows) = friends.VID
      ) AS friends
      LEFT JOIN OSA fof_relation ON (fof_relation.VALID = friends.fKnows)
      JOIN OPA fof ON COALESCE(fof_relation.VAL, friends.fKnows) = fof.VID
    ) AS fof
    LEFT JOIN OSA fofof_relation ON (fofof_relation.VALID = fof.fofKnows)
    JOIN IPA fofof ON COALESCE(fofof_relation.VAL, fof.fofKnows) = fofof.VID
    UNION
    SELECT fofofof.*
    FROM (
      SELECT fofof.*,
        CASE
          WHEN fofof.LBL1 = "KNOWS" THEN fofof.VAL1
          WHEN fofof.LBL2 = "KNOWS" THEN fofof.VAL2
          WHEN fofof.LBL3 = "KNOWS" THEN fofof.VAL3
          WHEN fofof.LBL4 = "KNOWS" THEN fofof.VAL4
          WHEN fofof.LBL5 = "KNOWS" THEN fofof.VAL5
          WHEN fofof.LBL6 = "KNOWS" THEN fofof.VAL6
          WHEN fofof.LBL7 = "KNOWS" THEN fofof.VAL7
          WHEN fofof.LBL8 = "KNOWS" THEN fofof.VAL8
          WHEN fofof.LBL9 = "KNOWS" THEN fofof.VAL9
          WHEN fofof.LBL10 = "KNOWS" THEN fofof.VAL10
        END AS fofofKnows
      FROM (
        SELECT fof.*,
          CASE
            WHEN fof.LBL1 = "KNOWS" THEN fof.VAL1
            WHEN fof.LBL2 = "KNOWS" THEN fof.VAL2
            WHEN fof.LBL3 = "KNOWS" THEN fof.VAL3
            WHEN fof.LBL4 = "KNOWS" THEN fof.VAL4
            WHEN fof.LBL5 = "KNOWS" THEN fof.VAL5
            WHEN fof.LBL6 = "KNOWS" THEN fof.VAL6
            WHEN fof.LBL7 = "KNOWS" THEN fof.VAL7
            WHEN fof.LBL8 = "KNOWS" THEN fof.VAL8
            WHEN fof.LBL9 = "KNOWS" THEN fof.VAL9
            WHEN fof.LBL10 = "KNOWS" THEN fof.VAL10
          END AS fofKnows
        FROM (
          SELECT
            friends.*,
            CASE
              WHEN friends.LBL1 = "KNOWS" THEN friends.VAL1
              WHEN friends.LBL2 = "KNOWS" THEN friends.VAL2
              WHEN friends.LBL3 = "KNOWS" THEN friends.VAL3
              WHEN friends.LBL4 = "KNOWS" THEN friends.VAL4
              WHEN friends.LBL5 = "KNOWS" THEN friends.VAL5
              WHEN friends.LBL6 = "KNOWS" THEN friends.VAL6
              WHEN friends.LBL7 = "KNOWS" THEN friends.VAL7
              WHEN friends.LBL8 = "KNOWS" THEN friends.VAL8
              WHEN friends.LBL9 = "KNOWS" THEN friends.VAL9
              WHEN friends.LBL10 = "KNOWS" THEN friends.VAL10
            END AS fKnows
          FROM (
            SELECT
              CASE
                WHEN person.LBL1 = "KNOWS" THEN person.VAL1
                WHEN person.LBL2 = "KNOWS" THEN person.VAL2
                WHEN person.LBL3 = "KNOWS" THEN person.VAL3
                WHEN person.LBL4 = "KNOWS" THEN person.VAL4
                WHEN person.LBL5 = "KNOWS" THEN person.VAL5
                WHEN person.LBL6 = "KNOWS" THEN person.VAL6
                WHEN person.LBL7 = "KNOWS" THEN person.VAL7
                WHEN person.LBL8 = "KNOWS" THEN person.VAL8
                WHEN person.LBL9 = "KNOWS" THEN person.VAL9
                WHEN person.LBL10 = "KNOWS" THEN person.VAL10
              END AS knows
            FROM OPA person
            WHERE person.VID = 1502199023259437
          ) AS person_relation
          LEFT JOIN OSA friends_relation ON (friends_relation.VALID = person_relation.knows)
          JOIN OPA friends ON COALESCE(friends_relation.VAL, person_relation.knows) = friends.VID
        ) AS friends
        LEFT JOIN OSA fof_relation ON (fof_relation.VALID = friends.fKnows)
        JOIN OPA fof ON COALESCE(fof_relation.VAL, friends.fKnows) = fof.VID
      ) AS fof
      LEFT JOIN OSA fofof_relation ON (fofof_relation.VALID = fof.fofKnows)
      JOIN OPA fofof ON COALESCE(fofof_relation.VAL, fof.fofKnows) = fofof.VID
    ) AS fofof
    LEFT JOIN OSA fofofof_relation ON (fofofof_relation.VALID = fofof.fofofKnows)
    JOIN IPA fofofof ON COALESCE(fofofof_relation.VAL, fofof.fofofKnows) = fofofof.VID
  ) AS f_fof_fofof_fofofof
) AS f_fof_fofof_fofofof_messages
LEFT JOIN ISA has_message ON (has_message.VALID = hasMessage)
JOIN VA message ON COALESCE(has_message.VAL, hasMessage) = message.VID
JOIN VA creator ON (creator.VID = personId)
ORDER BY creationDate Desc, message.VID
LIMIT 20;