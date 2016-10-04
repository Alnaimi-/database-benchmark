# Query 8: Recent Replies
# ====================================================================================================================

SELECT
  creator.ATTR->'$.FIRST_NAME' AS firstName,
  creator.ATTR->'$.LAST_NAME' AS lastName,
  comment.VID AS commentId,
  comment.ATTR->'$.CONTENT' AS content,
  comment.ATTR->'$.CREATION_DATE' AS creationdate
FROM (
  SELECT
    CASE
      WHEN message_relations.LBL1 = "REPLY_OF" THEN message_relations.VAL1
      WHEN message_relations.LBL2 = "REPLY_OF" THEN message_relations.VAL2
      WHEN message_relations.LBL3 = "REPLY_OF" THEN message_relations.VAL3
      WHEN message_relations.LBL4 = "REPLY_OF" THEN message_relations.VAL4
      WHEN message_relations.LBL5 = "REPLY_OF" THEN message_relations.VAL5
      WHEN message_relations.LBL6 = "REPLY_OF" THEN message_relations.VAL6
      WHEN message_relations.LBL7 = "REPLY_OF" THEN message_relations.VAL7
      WHEN message_relations.LBL8 = "REPLY_OF" THEN message_relations.VAL8
      WHEN message_relations.LBL9 = "REPLY_OF" THEN message_relations.VAL9
      WHEN message_relations.LBL10 = "REPLY_OF" THEN message_relations.VAL10
    END AS replyId
  FROM IPA person
  JOIN ISA messages ON CASE
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
  END = messages.VALID
  JOIN IPA message_relations ON (message_relations.VID = messages.VAL)
  WHERE person.VID = 1502199023259437
) AS reply_relation
LEFT JOIN ISA ON CASE
  WHEN reply_relation.replyId LIKE "-%" THEN reply_relation.replyId
  END = VALID
JOIN VA comment ON IF(replyId LIKE "-%", VAL, replyId) = VID
JOIN OPA comment_relation ON (comment_relation.VID = comment.VID)
JOIN VA creator ON CASE
  WHEN comment_relation.LBL1 = "HAS_CREATOR" THEN comment_relation.VAL1
  WHEN comment_relation.LBL2 = "HAS_CREATOR" THEN comment_relation.VAL2
  WHEN comment_relation.LBL3 = "HAS_CREATOR" THEN comment_relation.VAL3
  WHEN comment_relation.LBL4 = "HAS_CREATOR" THEN comment_relation.VAL4
  WHEN comment_relation.LBL5 = "HAS_CREATOR" THEN comment_relation.VAL5
  WHEN comment_relation.LBL6 = "HAS_CREATOR" THEN comment_relation.VAL6
  WHEN comment_relation.LBL7 = "HAS_CREATOR" THEN comment_relation.VAL7
  WHEN comment_relation.LBL8 = "HAS_CREATOR" THEN comment_relation.VAL8
  WHEN comment_relation.LBL9 = "HAS_CREATOR" THEN comment_relation.VAL9
  WHEN comment_relation.LBL10 = "HAS_CREATOR" THEN comment_relation.VAL10
END = creator.VID
WHERE reply_relation.replyId IS NOT NULL
ORDER BY creationDate Desc, comment.VID
LIMIT 20;
