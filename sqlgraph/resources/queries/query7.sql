SELECT
  messageId,
  CONCAT(SUBSTR(IF(                                             -- Substring the the value to restrict
    message.ATTR->'$.CONTENT' = "",                             -- output to one row selecting image
    message.ATTR->'$.IMAGE_FILE',                               -- file if empty else the content of
    message.ATTR->'$.CONTENT'
  ), 1, 20), "...") AS content,
  message.ATTR->>'$.CREATION_DATE' AS messageDate,
  likerId,
  person.ATTR->'$.FIRST_NAME' AS firstName,
  person.ATTR->'$.LAST_NAME' AS lastName,
  likeDate,
  TIMESTAMPDIFF(MINUTE, message.ATTR->>'$.CREATION_DATE', likeDate) AS latency,
  isFriend
FROM (
  SELECT
    likes.likeId AS likerId,                                     -- Below is the first/least/max problem
    SUBSTR(MAX(                                                  -- MySQL disallows to select first item
      CONCAT(                                                    -- in a group, and the other row values
        LPAD(like_relation.ATTR->'$.CREATION_DATE', 10, '0'),    -- this hack bypasses that, essentially
        likes.messageId                                          -- creating same value as one we aggreg
      )                                                          -- around and then substring to extract
    ), 11) AS messageId,
    MAX(like_relation.ATTR->>'$.CREATION_DATE') AS likeDate,
    CASE
      WHEN likes.likeId IN (
        SELECT friends.VID
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
      ) THEN 1 ELSE 0
    END AS isFriend
  FROM (
    SELECT
      has_like_relation.messageId,
      COALESCE(has_like.VAL, hasLike) AS likeId,
      COALESCE(has_like.EID, hasLikeEID) AS likeEid
    FROM (
      SELECT
        has_message.messageId,
        CASE
          WHEN message_relation.LBL1 = "LIKES" THEN message_relation.VAL1
          WHEN message_relation.LBL2 = "LIKES" THEN message_relation.VAL2
          WHEN message_relation.LBL3 = "LIKES" THEN message_relation.VAL3
          WHEN message_relation.LBL4 = "LIKES" THEN message_relation.VAL4
          WHEN message_relation.LBL5 = "LIKES" THEN message_relation.VAL5
          WHEN message_relation.LBL6 = "LIKES" THEN message_relation.VAL6
          WHEN message_relation.LBL7 = "LIKES" THEN message_relation.VAL7
          WHEN message_relation.LBL7 = "LIKES" THEN message_relation.VAL8
          WHEN message_relation.LBL9 = "LIKES" THEN message_relation.VAL9
          WHEN message_relation.LBL10 = "LIKES" THEN message_relation.VAL10
        END AS hasLike,
        CASE
          WHEN message_relation.LBL1 = "LIKES" THEN message_relation.EID1
          WHEN message_relation.LBL2 = "LIKES" THEN message_relation.EID2
          WHEN message_relation.LBL3 = "LIKES" THEN message_relation.EID3
          WHEN message_relation.LBL4 = "LIKES" THEN message_relation.EID4
          WHEN message_relation.LBL5 = "LIKES" THEN message_relation.EID5
          WHEN message_relation.LBL6 = "LIKES" THEN message_relation.EID6
          WHEN message_relation.LBL7 = "LIKES" THEN message_relation.EID7
          WHEN message_relation.LBL8 = "LIKES" THEN message_relation.VAL8
          WHEN message_relation.LBL9 = "LIKES" THEN message_relation.EID9
          WHEN message_relation.LBL10 = "LIKES" THEN message_relation.EID10
        END AS hasLikeEID
      FROM (
        SELECT
          COALESCE(has_message.VAL, hasMessage) AS messageId
        FROM (
          SELECT
            CASE
              WHEN person.LBL1 = "HAS_CREATOR" THEN person.VAL1
              WHEN person.LBL2 = "HAS_CREATOR" THEN person.VAL2
              WHEN person.LBL3 = "HAS_CREATOR" THEN person.VAL3
              WHEN person.LBL4 = "HAS_CREATOR" THEN person.VAL4
              WHEN person.LBL5 = "HAS_CREATOR" THEN person.VAL5
              WHEN person.LBL6 = "HAS_CREATOR" THEN person.VAL6
              WHEN person.LBL7 = "HAS_CREATOR" THEN person.VAL7
              WHEN person.LBL8 = "HAS_CREATOR" THEN person.VAL8
              WHEN person.LBL9 = "HAS_CREATOR" THEN person.VAL9
              WHEN person.LBL10 = "HAS_CREATOR" THEN person.VAL10
            END AS hasMessage
          FROM IPA person
          WHERE VID = 1502199023259437
        ) AS has_message_relation
        LEFT JOIN ISA has_message ON (has_message.VALID = has_message_relation.hasMessage)
      ) AS has_message
      JOIN IPA message_relation ON (message_relation.VID = has_message.messageId)
    ) AS has_like_relation
    LEFT JOIN ISA has_like ON (has_like.VALID = has_like_relation.hasLike)
  ) AS likes
  JOIN EA like_relation ON (like_relation.EID = likes.likeEid)
  GROUP BY likerId
) AS recent_likes
JOIN VA message ON (message.VID = recent_likes.messageId)
JOIN VA person ON (person.VID = likerId)
ORDER BY likeDate Desc, likerId
LIMIT 10;
