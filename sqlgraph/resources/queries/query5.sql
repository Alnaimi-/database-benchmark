SELECT
  forumId,
  forumName,
  count(creatorId) AS postCount
FROM (
  SELECT
    forum_messages.memberId,
    forum_messages.forumId,
    forum_messages.forumName,
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
    END AS creatorId
  FROM (
    SELECT
      has_message_relation.memberId,
      has_message_relation.forumId,
      has_message_relation.forumName,
      COALESCE(message_relation.VAL, has_message_relation.hasMessage) AS messageId
    FROM (
      SELECT
        joined_before.memberId,
        joined_before.forumId,
        forum.ATTR->'$.TITLE' AS forumName,
        CASE
          WHEN forum_relation.LBL1 = "CONTAINER_OF" THEN forum_relation.VAL1
          WHEN forum_relation.LBL2 = "CONTAINER_OF" THEN forum_relation.VAL2
          WHEN forum_relation.LBL3 = "CONTAINER_OF" THEN forum_relation.VAL3
          WHEN forum_relation.LBL4 = "CONTAINER_OF" THEN forum_relation.VAL4
          WHEN forum_relation.LBL5 = "CONTAINER_OF" THEN forum_relation.VAL5
          WHEN forum_relation.LBL6 = "CONTAINER_OF" THEN forum_relation.VAL6
          WHEN forum_relation.LBL7 = "CONTAINER_OF" THEN forum_relation.VAL7
          WHEN forum_relation.LBL8 = "CONTAINER_OF" THEN forum_relation.VAL8
          WHEN forum_relation.LBL9 = "CONTAINER_OF" THEN forum_relation.VAL9
          WHEN forum_relation.LBL10 = "CONTAINER_OF" THEN forum_relation.VAL10
        END AS hasMessage
      FROM (
        SELECT
          member_relation.memberId,
          member_relation.forumId
        FROM (
          SELECT
            has_member_relation.memberId,
            COALESCE(has_member.EID, has_member_relation.hasMemberEid) AS forumEid,
            COALESCE(has_member.VAL, has_member_relation.hasMember) AS forumId
          FROM (
            SELECT
              f_fof.VID AS memberId,
              CASE
                WHEN f_fof.LBL1 = "HAS_MEMBER" THEN f_fof.EID1
                WHEN f_fof.LBL2 = "HAS_MEMBER" THEN f_fof.EID2
                WHEN f_fof.LBL3 = "HAS_MEMBER" THEN f_fof.EID3
                WHEN f_fof.LBL4 = "HAS_MEMBER" THEN f_fof.EID4
                WHEN f_fof.LBL5 = "HAS_MEMBER" THEN f_fof.EID5
                WHEN f_fof.LBL6 = "HAS_MEMBER" THEN f_fof.EID6
                WHEN f_fof.LBL7 = "HAS_MEMBER" THEN f_fof.EID7
                WHEN f_fof.LBL8 = "HAS_MEMBER" THEN f_fof.EID8
                WHEN f_fof.LBL9 = "HAS_MEMBER" THEN f_fof.EID9
                WHEN f_fof.LBL10 = "HAS_MEMBER" THEN f_fof.EID10
              END AS hasMemberEid,
              CASE
                WHEN f_fof.LBL1 = "HAS_MEMBER" THEN f_fof.VAL1
                WHEN f_fof.LBL2 = "HAS_MEMBER" THEN f_fof.VAL2
                WHEN f_fof.LBL3 = "HAS_MEMBER" THEN f_fof.VAL3
                WHEN f_fof.LBL4 = "HAS_MEMBER" THEN f_fof.VAL4
                WHEN f_fof.LBL5 = "HAS_MEMBER" THEN f_fof.VAL5
                WHEN f_fof.LBL6 = "HAS_MEMBER" THEN f_fof.VAL6
                WHEN f_fof.LBL7 = "HAS_MEMBER" THEN f_fof.VAL7
                WHEN f_fof.LBL8 = "HAS_MEMBER" THEN f_fof.VAL8
                WHEN f_fof.LBL9 = "HAS_MEMBER" THEN f_fof.VAL9
                WHEN f_fof.LBL10 = "HAS_MEMBER" THEN f_fof.VAL10
              END AS hasMember
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
            ) AS f_fof
          ) AS has_member_relation
          LEFT JOIN ISA has_member ON (has_member.VALID = has_member_relation.hasMember)
        ) AS member_relation
        JOIN EA joined_forum ON (joined_forum.EID = member_relation.forumEid)
        WHERE joined_forum.ATTR->'$.JOIN_DATE' > "1990-01-01"
      ) AS joined_before
      JOIN VA forum ON (forum.VID = joined_before.forumId)
      JOIN OPA forum_relation ON (forum_relation.VID = joined_before.forumId)
    ) AS has_message_relation
    LEFT JOIN OSA message_relation ON (message_relation.VALID = has_message_relation.hasMessage)
  ) AS forum_messages
  JOIN OPA message_relation ON (message_relation.VID = forum_messages.messageId)
) AS message_creators
WHERE memberId = creatorId
GROUP BY forumId
ORDER BY postCount Desc, forumId
LIMIT 20;
