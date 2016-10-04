# Query 9: Recent posts and comments by friends and friends of friends
# ====================================================================================================================

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
    f_fof.VID AS personId,
    CASE
      WHEN f_fof.LBL1 = "HAS_CREATOR" THEN f_fof.VAL1
      WHEN f_fof.LBL2 = "HAS_CREATOR" THEN f_fof.VAL2
      WHEN f_fof.LBL3 = "HAS_CREATOR" THEN f_fof.VAL3
      WHEN f_fof.LBL4 = "HAS_CREATOR" THEN f_fof.VAL4
      WHEN f_fof.LBL5 = "HAS_CREATOR" THEN f_fof.VAL5
      WHEN f_fof.LBL6 = "HAS_CREATOR" THEN f_fof.VAL6
      WHEN f_fof.LBL7 = "HAS_CREATOR" THEN f_fof.VAL7
      WHEN f_fof.LBL8 = "HAS_CREATOR" THEN f_fof.VAL8
      WHEN f_fof.LBL9 = "HAS_CREATOR" THEN f_fof.VAL9
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
      JOIN IPA friends ON COALESCE(friends_relation.VAL, person_relation.knows) = friends.VID
    ) AS friends
    LEFT JOIN OSA fof_relation ON (fof_relation.VALID = friends.fKnows)
    JOIN OPA fof ON COALESCE(fof_relation.VAL, friends.fKnows) = fof.VID
  ) AS f_fof
) AS f_fof_messages
LEFT JOIN ISA has_message ON (has_message.VALID = hasMessage)
JOIN VA message ON COALESCE(has_message.VAL, hasMessage) = message.VID
JOIN VA creator ON (creator.VID = personId)
ORDER BY creationDate Desc, message.VID
LIMIT 20;
