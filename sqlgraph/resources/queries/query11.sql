# Query 11: Job Referral
# ====================================================================================================================

SELECT
  personId,
  firstName,
  lastName,
  company.VID AS companyId,
  company.ATTR->'$.NAME' AS companyName,
  company_place.ATTR->'$.NAME' AS companyIn,
  work_from.ATTR->'$.WORK_FROM' AS worksFrom
FROM (
  SELECT
    f_fof.VID AS personId,
    people.ATTR->'$.FIRST_NAME' AS firstName,
    people.ATTR->'$.LAST_NAME' AS lastName,
    CASE
      WHEN f_fof.LBL1 = "WORK_AT" THEN f_fof.VAL1
      WHEN f_fof.LBL2 = "WORK_AT" THEN f_fof.VAL2
      WHEN f_fof.LBL3 = "WORK_AT" THEN f_fof.VAL3
      WHEN f_fof.LBL4 = "WORK_AT" THEN f_fof.VAL4
      WHEN f_fof.LBL5 = "WORK_AT" THEN f_fof.VAL5
      WHEN f_fof.LBL6 = "WORK_AT" THEN f_fof.VAL6
      WHEN f_fof.LBL7 = "WORK_AT" THEN f_fof.VAL7
      WHEN f_fof.LBL8 = "WORK_AT" THEN f_fof.VAL8
      WHEN f_fof.LBL9 = "WORK_AT" THEN f_fof.VAL9
      WHEN f_fof.LBL10 = "WORK_AT" THEN f_fof.VAL10
    END AS companyId,
    CASE
      WHEN f_fof.LBL1 = "WORK_AT" THEN f_fof.EID1
      WHEN f_fof.LBL2 = "WORK_AT" THEN f_fof.EID2
      WHEN f_fof.LBL3 = "WORK_AT" THEN f_fof.EID3
      WHEN f_fof.LBL4 = "WORK_AT" THEN f_fof.EID4
      WHEN f_fof.LBL5 = "WORK_AT" THEN f_fof.EID5
      WHEN f_fof.LBL6 = "WORK_AT" THEN f_fof.EID6
      WHEN f_fof.LBL7 = "WORK_AT" THEN f_fof.EID7
      WHEN f_fof.LBL8 = "WORK_AT" THEN f_fof.EID8
      WHEN f_fof.LBL9 = "WORK_AT" THEN f_fof.EID9
      WHEN f_fof.LBL10 = "WORK_AT" THEN f_fof.EID10
    END AS companyEid
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
  JOIN VA people ON (f_fof.VID = people.VID)
) AS f_fof_company_relation
LEFT JOIN OSA work_at ON (work_at.VALID = f_fof_company_relation.companyId)
JOIN VA company ON COALESCE(work_at.VAL, f_fof_company_relation.companyId) = company.VID
JOIN OPA company_relation ON (company.VID = company_relation.VID)
JOIN VA company_place ON (company_relation.VAL1 = company_place.VID)
JOIN EA work_from ON COALESCE(work_at.EID, f_fof_company_relation.companyEid) = work_from.EID
WHERE company_place.ATTR->'$.NAME' = "France" AND work_from.ATTR->'$.WORK_FROM' <= "2016-07-07"
ORDER BY worksFrom, personId
LIMIT 10;
