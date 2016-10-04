SELECT personId, firstName, lastName, ctone, cttwo, total
FROM
(
  SELECT
    personId,
    person.ATTR->'$.FIRST_NAME' AS firstName,
    person.ATTR->'$.LAST_NAME' AS lastName
    FROM (
    SELECT
      f_fof.VID AS personId,
      CASE
        WHEN f_fof.LBL1 = "P_IS_LOCATED_IN" THEN f_fof.VAL1
        WHEN f_fof.LBL2 = "P_IS_LOCATED_IN" THEN f_fof.VAL2
        WHEN f_fof.LBL3 = "P_IS_LOCATED_IN" THEN f_fof.VAL3
        WHEN f_fof.LBL4 = "P_IS_LOCATED_IN" THEN f_fof.VAL4
        WHEN f_fof.LBL5 = "P_IS_LOCATED_IN" THEN f_fof.VAL5
        WHEN f_fof.LBL6 = "P_IS_LOCATED_IN" THEN f_fof.VAL6
        WHEN f_fof.LBL7 = "P_IS_LOCATED_IN" THEN f_fof.VAL7
        WHEN f_fof.LBL8 = "P_IS_LOCATED_IN" THEN f_fof.VAL8
        WHEN f_fof.LBL9 = "P_IS_LOCATED_IN" THEN f_fof.VAL9
        WHEN f_fof.LBL10 = "P_IS_LOCATED_IN" THEN f_fof.VAL10
      END AS friendLocation
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
      JOIN OPA friends ON COALESCE(friends_relation.VAL, person_relation.knows) = friends.VID
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
      JOIN OPA fof ON COALESCE(fof_relation.VAL, friends.fKnows) = fof.VID
    ) AS f_fof
  ) AS f_fof_has_location
  JOIN OPA city_relation ON (city_relation.VID = f_fof_has_location.friendLocation)
  JOIN VA country ON (country.VID = city_relation.VAL1)
  JOIN VA person ON (person.VID = f_fof_has_location.personID)
  WHERE country.ATTR->'$.NAME' NOT RLIKE "France|France"
) f,
(
  SELECT cone.creatorId, ctone, cttwo, (ctone + cttwo) AS total
  FROM
  (
    SELECT
      CASE
        WHEN message_relation.LBL1 = "HAS_CREATOR" THEN message_relation.VAL1
        WHEN message_relation.LBL2 = "HAS_CREATOR" THEN message_relation.VAL2
        WHEN message_relation.LBL3 = "HAS_CREATOR" THEN message_relation.VAL3
        WHEN message_relation.LBL4 = "HAS_CREATOR" THEN message_relation.VAL4
        WHEN message_relation.LBL5 = "HAS_CREATOR" THEN message_relation.VAL5
        WHEN message_relation.LBL6 = "HAS_CREATOR" THEN message_relation.VAL6
        WHEN message_relation.LBL7 = "HAS_CREATOR" THEN message_relation.VAL7
        WHEN message_relation.LBL8 = "HAS_CREATOR" THEN message_relation.VAL8
        WHEN message_relation.LBL9 = "HAS_CREATOR" THEN message_relation.VAL9
        WHEN message_relation.LBL10 = "HAS_CREATOR" THEN message_relation.VAL10
      END AS creatorId,
      COUNT(message_relation.VID) AS ctone
    FROM (
      SELECT
        CASE
          WHEN country_relation.LBL1 = "M_IS_LOCATED_IN" THEN country_relation.VAL1
          WHEN country_relation.LBL2 = "M_IS_LOCATED_IN" THEN country_relation.VAL2
          WHEN country_relation.LBL3 = "M_IS_LOCATED_IN" THEN country_relation.VAL3
          WHEN country_relation.LBL4 = "M_IS_LOCATED_IN" THEN country_relation.VAL4
          WHEN country_relation.LBL5 = "M_IS_LOCATED_IN" THEN country_relation.VAL5
          WHEN country_relation.LBL6 = "M_IS_LOCATED_IN" THEN country_relation.VAL6
          WHEN country_relation.LBL7 = "M_IS_LOCATED_IN" THEN country_relation.VAL7
          WHEN country_relation.LBL8 = "M_IS_LOCATED_IN" THEN country_relation.VAL8
          WHEN country_relation.LBL9 = "M_IS_LOCATED_IN" THEN country_relation.VAL9
          WHEN country_relation.LBL10 = "M_IS_LOCATED_IN" THEN country_relation.VAL10
        END AS hasMessages
      FROM IPA country_relation 
      WHERE country_relation.VID = (SELECT country.VID FROM VA country WHERE country.TYPE = "place" AND country.ATTR->'$.NAME' = "France")
    ) AS X
    LEFT JOIN ISA has_message ON (has_message.VALID = hasMessages)
    JOIN OPA message_relation ON COALESCE(has_message.VAL, hasMessages) = message_relation.VID
    GROUP BY creatorId
  ) cone,
  (
    SELECT
      CASE
        WHEN message_relation.LBL1 = "HAS_CREATOR" THEN message_relation.VAL1
        WHEN message_relation.LBL2 = "HAS_CREATOR" THEN message_relation.VAL2
        WHEN message_relation.LBL3 = "HAS_CREATOR" THEN message_relation.VAL3
        WHEN message_relation.LBL4 = "HAS_CREATOR" THEN message_relation.VAL4
        WHEN message_relation.LBL5 = "HAS_CREATOR" THEN message_relation.VAL5
        WHEN message_relation.LBL6 = "HAS_CREATOR" THEN message_relation.VAL6
        WHEN message_relation.LBL7 = "HAS_CREATOR" THEN message_relation.VAL7
        WHEN message_relation.LBL8 = "HAS_CREATOR" THEN message_relation.VAL8
        WHEN message_relation.LBL9 = "HAS_CREATOR" THEN message_relation.VAL9
        WHEN message_relation.LBL10 = "HAS_CREATOR" THEN message_relation.VAL10
      END AS creatorId,
      COUNT(message_relation.VID) AS cttwo
    FROM (
      SELECT
        CASE
          WHEN country_relation.LBL1 = "M_IS_LOCATED_IN" THEN country_relation.VAL1
          WHEN country_relation.LBL2 = "M_IS_LOCATED_IN" THEN country_relation.VAL2
          WHEN country_relation.LBL3 = "M_IS_LOCATED_IN" THEN country_relation.VAL3
          WHEN country_relation.LBL4 = "M_IS_LOCATED_IN" THEN country_relation.VAL4
          WHEN country_relation.LBL5 = "M_IS_LOCATED_IN" THEN country_relation.VAL5
          WHEN country_relation.LBL6 = "M_IS_LOCATED_IN" THEN country_relation.VAL6
          WHEN country_relation.LBL7 = "M_IS_LOCATED_IN" THEN country_relation.VAL7
          WHEN country_relation.LBL8 = "M_IS_LOCATED_IN" THEN country_relation.VAL8
          WHEN country_relation.LBL9 = "M_IS_LOCATED_IN" THEN country_relation.VAL9
          WHEN country_relation.LBL10 = "M_IS_LOCATED_IN" THEN country_relation.VAL10
        END AS hasMessages
      FROM IPA country_relation
      WHERE country_relation.VID = (SELECT country.VID FROM VA country WHERE country.TYPE = "place" AND country.ATTR->'$.NAME' = "France")
    ) AS X
    LEFT JOIN ISA has_message ON (has_message.VALID = hasMessages)
    JOIN OPA message_relation ON COALESCE(has_message.VAL, hasMessages) = message_relation.VID
    GROUP BY creatorId
  ) ctwo
  WHERE cone.creatorId = ctwo.creatorId
) cpc
WHERE cpc.creatorId = f.personId
ORDER BY total Desc, personId
LIMIT 10;
