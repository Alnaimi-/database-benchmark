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
  friends.VID AS personId,
  CASE
    WHEN friends.LBL1 = "HAS_CREATOR" THEN friends.VAL1
    WHEN friends.LBL2 = "HAS_CREATOR" THEN friends.VAL2
    WHEN friends.LBL3 = "HAS_CREATOR" THEN friends.VAL3
    WHEN friends.LBL4 = "HAS_CREATOR" THEN friends.VAL4
    WHEN friends.LBL5 = "HAS_CREATOR" THEN friends.VAL5
    WHEN friends.LBL6 = "HAS_CREATOR" THEN friends.VAL6
    WHEN friends.LBL7 = "HAS_CREATOR" THEN friends.VAL7
    WHEN friends.LBL8 = "HAS_CREATOR" THEN friends.VAL8
    WHEN friends.LBL9 = "HAS_CREATOR" THEN friends.VAL9
  END AS hasMessage
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
) AS f_fof_messages
LEFT JOIN ISA has_message ON (has_message.VALID = hasMessage)
JOIN VA message ON COALESCE(has_message.VAL, hasMessage) = message.VID
JOIN VA creator ON (creator.VID = personId)
ORDER BY creationDate Desc, message.VID
LIMIT 20;
