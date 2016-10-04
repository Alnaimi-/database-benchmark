SELECT tag.ATTR->'$.NAME' AS tagName, COUNT(*) AS postCount
FROM
(
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
    END AS knowsId
  FROM OPA person
  WHERE person.VID = 1502199023259437
) p_r, OSA knows, IPA has_post, ISA has_post_rel, OPA post_rel, OSA has_tag, VA post, VA tag
WHERE
  knows.VALID = knowsId
  AND has_post.VID = COALESCE(knows.VAL, knowsId)
  AND has_post_rel.VALID =
  CASE
    WHEN has_post.LBL1 = "HAS_CREATOR" THEN has_post.VAL1
    WHEN has_post.LBL2 = "HAS_CREATOR" THEN has_post.VAL2
    WHEN has_post.LBL3 = "HAS_CREATOR" THEN has_post.VAL3
    WHEN has_post.LBL4 = "HAS_CREATOR" THEN has_post.VAL4
    WHEN has_post.LBL5 = "HAS_CREATOR" THEN has_post.VAL5
    WHEN has_post.LBL6 = "HAS_CREATOR" THEN has_post.VAL6
    WHEN has_post.LBL7 = "HAS_CREATOR" THEN has_post.VAL7
    WHEN has_post.LBL8 = "HAS_CREATOR" THEN has_post.VAL8
    WHEN has_post.LBL9 = "HAS_CREATOR" THEN has_post.VAL9
    WHEN has_post.LBL10 = "HAS_CREATOR" THEN has_post.VAL10
  END
  AND post_rel.VID = has_post_rel.VAL
  AND post_rel.TYPE = "post"
  AND post.VID = post_rel.VID
  AND post.ATTR->'$.CREATION_DATE' >= "2011-06-06" AND post.ATTR->'$.CREATION_DATE' <= "2016-06-06"
  AND has_tag.VALID =
  CASE
    WHEN post_rel.LBL1 = "HAS_TAG" THEN post_rel.VAL1
    WHEN post_rel.LBL2 = "HAS_TAG" THEN post_rel.VAL2
    WHEN post_rel.LBL3 = "HAS_TAG" THEN post_rel.VAL3
    WHEN post_rel.LBL4 = "HAS_TAG" THEN post_rel.VAL4
    WHEN post_rel.LBL5 = "HAS_TAG" THEN post_rel.VAL5
    WHEN post_rel.LBL6 = "HAS_TAG" THEN post_rel.VAL6
    WHEN post_rel.LBL7 = "HAS_TAG" THEN post_rel.VAL7
    WHEN post_rel.LBL8 = "HAS_TAG" THEN post_rel.VAL8
    WHEN post_rel.LBL9 = "HAS_TAG" THEN post_rel.VAL9
    WHEN post_rel.LBL10 = "HAS_TAG" THEN post_rel.VAL10
  END
  AND tag.VID = has_tag.VAL
  AND tag.VID NOT IN (
    SELECT has_tag.VAL
    FROM
    (
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
        END AS knowsId
      FROM OPA person
      WHERE person.VID = 1502199023259437
    ) p_r, OSA knows, IPA has_post, ISA has_post_rel, OPA post_rel, OSA has_tag, VA post
    WHERE
      knows.VALID = knowsId
      AND has_post.VID = COALESCE(knows.VAL, knowsId)
      AND has_post_rel.VALID =
      CASE
        WHEN has_post.LBL1 = "HAS_CREATOR" THEN has_post.VAL1
        WHEN has_post.LBL2 = "HAS_CREATOR" THEN has_post.VAL2
        WHEN has_post.LBL3 = "HAS_CREATOR" THEN has_post.VAL3
        WHEN has_post.LBL4 = "HAS_CREATOR" THEN has_post.VAL4
        WHEN has_post.LBL5 = "HAS_CREATOR" THEN has_post.VAL5
        WHEN has_post.LBL6 = "HAS_CREATOR" THEN has_post.VAL6
        WHEN has_post.LBL7 = "HAS_CREATOR" THEN has_post.VAL7
        WHEN has_post.LBL8 = "HAS_CREATOR" THEN has_post.VAL8
        WHEN has_post.LBL9 = "HAS_CREATOR" THEN has_post.VAL9
        WHEN has_post.LBL10 = "HAS_CREATOR" THEN has_post.VAL10
      END
      AND post_rel.VID = has_post_rel.VAL
      AND post_rel.TYPE = "post"
      AND post.VID = post_rel.VID
      AND post.ATTR->'$.CREATION_DATE' < "2011-06-06"
      AND has_tag.VALID =
      CASE
        WHEN post_rel.LBL1 = "HAS_TAG" THEN post_rel.VAL1
        WHEN post_rel.LBL2 = "HAS_TAG" THEN post_rel.VAL2
        WHEN post_rel.LBL3 = "HAS_TAG" THEN post_rel.VAL3
        WHEN post_rel.LBL4 = "HAS_TAG" THEN post_rel.VAL4
        WHEN post_rel.LBL5 = "HAS_TAG" THEN post_rel.VAL5
        WHEN post_rel.LBL6 = "HAS_TAG" THEN post_rel.VAL6
        WHEN post_rel.LBL7 = "HAS_TAG" THEN post_rel.VAL7
        WHEN post_rel.LBL8 = "HAS_TAG" THEN post_rel.VAL8
        WHEN post_rel.LBL9 = "HAS_TAG" THEN post_rel.VAL9
        WHEN post_rel.LBL10 = "HAS_TAG" THEN post_rel.VAL10
      END
  )
GROUP BY tagName
ORDER BY 2 Desc, 1
LIMIT 5;
