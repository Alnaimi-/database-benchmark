# Query 6: Tag co-occurence
# ====================================================================================================================

SELECT
  tags.ATTR->'$.NAME' as tagName,
  COUNT(postId) as postCount
FROM (
  SELECT
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
    END AS postHastTag,
    posts.VID AS postId,
    originalTag
  FROM (
    SELECT
      CASE
        WHEN people.LBL1 = "HAS_CREATOR" THEN people.VAL1
        WHEN people.LBL2 = "HAS_CREATOR" THEN people.VAL2
        WHEN people.LBL3 = "HAS_CREATOR" THEN people.VAL3
        WHEN people.LBL4 = "HAS_CREATOR" THEN people.VAL4
        WHEN people.LBL5 = "HAS_CREATOR" THEN people.VAL5
        WHEN people.LBL6 = "HAS_CREATOR" THEN people.VAL6
        WHEN people.LBL7 = "HAS_CREATOR" THEN people.VAL7
        WHEN people.LBL8 = "HAS_CREATOR" THEN people.VAL8
        WHEN people.LBL9 = "HAS_CREATOR" THEN people.VAL9
        WHEN people.LBL10 = "HAS_CREATOR" THEN people.VAL10
      END AS postHasCreator,
      originalId,
      originalTag
    FROM (
      SELECT
        CASE
          WHEN post_relations.LBL1 = "HAS_CREATOR" THEN post_relations.VAL1
          WHEN post_relations.LBL2 = "HAS_CREATOR" THEN post_relations.VAL2
          WHEN post_relations.LBL3 = "HAS_CREATOR" THEN post_relations.VAL3
          WHEN post_relations.LBL4 = "HAS_CREATOR" THEN post_relations.VAL4
          WHEN post_relations.LBL5 = "HAS_CREATOR" THEN post_relations.VAL5
          WHEN post_relations.LBL6 = "HAS_CREATOR" THEN post_relations.VAL6
          WHEN post_relations.LBL7 = "HAS_CREATOR" THEN post_relations.VAL7
          WHEN post_relations.LBL8 = "HAS_CREATOR" THEN post_relations.VAL8
          WHEN post_relations.LBL9 = "HAS_CREATOR" THEN post_relations.VAL9
          WHEN post_relations.LBL10 = "HAS_CREATOR" THEN post_relations.VAL10
        END AS postCreator,
        post_relations.VID AS originalId,
        originalTag
      FROM (
        SELECT
          CASE
            WHEN tag_relations.LBL1 = "HAS_TAG" THEN tag_relations.VAL1
            WHEN tag_relations.LBL2 = "HAS_TAG" THEN tag_relations.VAL2
            WHEN tag_relations.LBL3 = "HAS_TAG" THEN tag_relations.VAL3
            WHEN tag_relations.LBL4 = "HAS_TAG" THEN tag_relations.VAL4
            WHEN tag_relations.LBL5 = "HAS_TAG" THEN tag_relations.VAL5
            WHEN tag_relations.LBL6 = "HAS_TAG" THEN tag_relations.VAL6
            WHEN tag_relations.LBL7 = "HAS_TAG" THEN tag_relations.VAL7
            WHEN tag_relations.LBL8 = "HAS_TAG" THEN tag_relations.VAL8
            WHEN tag_relations.LBL9 = "HAS_TAG" THEN tag_relations.VAL9
            WHEN tag_relations.LBL10 = "HAS_TAG" THEN tag_relations.VAL10
          END AS postHasTag,
          tag.VID as originalTag
        FROM VA tag
        JOIN IPA tag_relations ON (tag_relations.VID = tag.VID)
        WHERE
          tag.TYPE = "tag"
          AND ATTR->'$.NAME' = "A_Woman_and_a_Man"
      ) AS post_has_tag
      LEFT JOIN ISA tag_posts ON (post_has_tag.postHasTag = tag_posts.VALID)
      JOIN OPA post_relations ON
        COALESCE(tag_posts.VAL, post_has_tag.postHasTag) = post_relations.VID
        AND post_relations.TYPE = "post"
    ) AS creator_of_posts
    INNER JOIN
    (
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
    ) AS f_fof ON (postCreator = f_fof.VID)
    JOIN IPA people ON (people.VID = postCreator)
  ) AS people_relations
  LEFT JOIN ISA people_post ON (people_post.VALID = people_relations.postHasCreator)
  JOIN OPA posts ON
    COALESCE(people_post.VAL, people_relations.postHasCreator) = posts.VID
    AND posts.TYPE = "post"
    AND posts.VID = originalId
) AS common_post_tag
LEFT JOIN OSA has_tag ON (has_tag.VALID = common_post_tag.postHastTag)
JOIN VA tags ON
  COALESCE(has_tag.VAL, common_post_tag.postHastTag) = tags.VID
  AND tags.VID != originalTag
GROUP BY tagName
ORDER BY
  postCount Desc,
  tagName
LIMIT 10;
