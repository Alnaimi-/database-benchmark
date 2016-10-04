# Query 10: Friends Recommendation
# ====================================================================================================================

SELECT
  personId,
  SUM(interest) - (count(*) - SUM(interest)) AS similarityScore,
  person.ATTR->'$.FIRST_NAME' AS firstName,
  person.ATTR->'$.LAST_NAME' AS lastName
FROM (
  SELECT
    poi_tags.personId,
    COUNT(interestId) AS interest
  FROM (
    SELECT
      poi_has_tags.personId,
      COALESCE(has_tag.VAL, poi_has_tags.hasTag) AS tagId,
      messageId
    FROM (
      SELECT
        poi_messages.personId,
        CASE
          WHEN posts.LBL1 = "HAS_TAG" THEN posts.VAL1
          WHEN posts.LBL2 = "HAS_TAG" THEN posts.VAL2
          WHEN posts.LBL3 = "HAS_TAG" THEN posts.VAL3
          WHEN posts.LBL4 = "HAS_TAG" THEN posts.VAL4
          WHEN posts.LBL5 = "HAS_TAG" THEN posts.VAL5
          WHEN posts.LBL6 = "HAS_TAG" THEN posts.VAL6
          WHEN posts.LBL7 = "HAS_TAG" THEN posts.VAL7
          WHEN posts.LBL8 = "HAS_TAG" THEN posts.VAL8
          WHEN posts.LBL9 = "HAS_TAG" THEN posts.VAL9
          WHEN posts.LBL10 = "HAS_TAG" THEN posts.VAL10
        END AS hasTag,
        messageId
      FROM (
        SELECT DISTINCT
          fof_ex_f.VID AS personId,
          COALESCE(has_message.VAL, hasMessage) AS messageId
        FROM (
          SELECT
            fof.VID,
            CASE
              WHEN fof.LBL1 = "HAS_CREATOR" THEN fof.VAL1
              WHEN fof.LBL2 = "HAS_CREATOR" THEN fof.VAL2
              WHEN fof.LBL3 = "HAS_CREATOR" THEN fof.VAL3
              WHEN fof.LBL4 = "HAS_CREATOR" THEN fof.VAL4
              WHEN fof.LBL5 = "HAS_CREATOR" THEN fof.VAL5
              WHEN fof.LBL6 = "HAS_CREATOR" THEN fof.VAL6
              WHEN fof.LBL7 = "HAS_CREATOR" THEN fof.VAL7
              WHEN fof.LBL8 = "HAS_CREATOR" THEN fof.VAL8
              WHEN fof.LBL9 = "HAS_CREATOR" THEN fof.VAL9
            END AS hasMessage
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
          WHERE fof.VID NOT IN (
            SELECT friends.VID
            FROM OPA person
            JOIN OSA friends_relation ON CASE
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
            END = friends_relation.VALID
            JOIN OPA friends ON (friends_relation.VAL = friends.VID)
            WHERE person.VID = 1502199023259437
          )
          GROUP BY fof.VID, hasMessage
        ) AS fof_ex_f
        JOIN VA person ON (person.VID = fof_ex_f.VID)
        LEFT JOIN ISA has_message ON (has_message.VALID = hasMessage)
        WHERE (month(person.ATTR->>'$.BIRTHDAY') = 3 AND day(person.ATTR->>'$.BIRTHDAY') >= 21)
          OR (month(person.ATTR->>'$.BIRTHDAY') = 4 AND day(person.ATTR->>'$.BIRTHDAY') <= 22)
      ) AS poi_messages
      JOIN OPA posts ON (posts.VID = messageId) AND posts.TYPE = "post"
    ) AS poi_has_tags
    LEFT JOIN OSA has_tag ON (has_tag.VALID = poi_has_tags.hasTag)
  ) AS poi_tags
  LEFT JOIN (
    SELECT COALESCE(interests.VAL, has_interest.hasInterest) AS interestId
    FROM (
      SELECT
        CASE
          WHEN person.LBL1 = "HAS_INTEREST" THEN person.VAL1
          WHEN person.LBL2 = "HAS_INTEREST" THEN person.VAL2
          WHEN person.LBL3 = "HAS_INTEREST" THEN person.VAL3
          WHEN person.LBL4 = "HAS_INTEREST" THEN person.VAL4
          WHEN person.LBL5 = "HAS_INTEREST" THEN person.VAL5
          WHEN person.LBL6 = "HAS_INTEREST" THEN person.VAL6
          WHEN person.LBL7 = "HAS_INTEREST" THEN person.VAL7
          WHEN person.LBL8 = "HAS_INTEREST" THEN person.VAL8
          WHEN person.LBL9 = "HAS_INTEREST" THEN person.VAL9
          WHEN person.LBL10 = "HAS_INTEREST" THEN person.VAL10
        END AS hasInterest
      FROM OPA person
      WHERE VID = 1502199023259437
    ) AS has_interest
    JOIN OSA interests ON (interests.VALID = has_interest.hasInterest)
  ) AS person_interests ON (person_interests.interestId = poi_tags.tagId)
  GROUP BY personId, messageId
) similarity
JOIN VA person ON (person.VID = similarity.personId)
GROUP BY personId
ORDER BY similarityScore Desc, personId
LIMIT 50;
