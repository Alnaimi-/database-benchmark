\o /dev/null

WITH SUB_1804388986 AS (
SELECT 
person.id as personId, 'Person('||friend.id||')' AS friend, friend.id AS friendId, friendPost.id, 'Post('||friendPost.id||')' AS friendPost, knownTag.id as knownTagId
FROM person AS person 
JOIN person_knows_person ON (person_knows_person.person_id = person.id)  JOIN Person AS friend ON (friend.id = person_knows_person.other_person_id)  
JOIN post_hasCreator_person ON (post_hasCreator_person.person_id = friend.id)  JOIN Post AS friendPost ON (friendPost.id = post_hasCreator_person.post_id)  
JOIN post_hasTag_tag ON (post_hasTag_tag.post_id = friendPost.id)  JOIN Tag AS knownTag ON (knownTag.id = post_hasTag_tag.tag_id) 
WHERE person.id = 2199023259437 AND knownTag.name = 'A_Woman_and_a_Man'
), SUB_2018627083 AS (
SELECT 
person.id as personId, 'Person('||friend.id||')' AS friend, friend.id AS friendId, friendPost.id, 'Post('||friendPost.id||')' AS friendPost, knownTag.id as knownTagId
FROM person AS person 
JOIN person_knows_person ON (person_knows_person.person_id = person.id)  JOIN Person AS p_$1 ON (p_$1.id = person_knows_person.other_person_id)  
JOIN person_knows_person AS person_knows_person_$1 ON (person_knows_person_$1.person_id = p_$1.id)  JOIN Person AS friend ON (friend.id = person_knows_person_$1.other_person_id)  
JOIN post_hasCreator_person ON (post_hasCreator_person.person_id = friend.id)  JOIN Post AS friendPost ON (friendPost.id = post_hasCreator_person.post_id)  
JOIN post_hasTag_tag ON (post_hasTag_tag.post_id = friendPost.id)  JOIN Tag AS knownTag ON (knownTag.id = post_hasTag_tag.tag_id) 
WHERE person.id = 2199023259437 AND knownTag.name = 'A_Woman_and_a_Man'
), SUB_843853757 AS (
SELECT 'Post('||friendPost.id||')' AS friendPost,commonTag.id as commonTagId,'Tag('||commonTag.id||')' AS commonTag, commonTag.name as cName, personId, friendId, knownTagId FROM SUB_1804388986 AS friendPost JOIN post_hasTag_tag ON (post_hasTag_tag.post_id = friendPost.id)  JOIN Tag AS commonTag ON (commonTag.id = post_hasTag_tag.tag_id) WHERE commonTag.id != knownTagId
), SUB_1456464649 AS (
SELECT cName, commonPost.id AS commonPost, personId, friendId, commonTagId, knownTag.id as knownTagId
FROM SUB_843853757 AS commonTag 
JOIN post_hasTag_tag ON (post_hasTag_tag.tag_id = commonTagId)  JOIN Post AS commonPost ON (commonPost.id = post_hasTag_tag.post_id)  
JOIN post_hasTag_tag AS post_hasTag_tag_$1 ON (post_hasTag_tag_$1.post_id = commonPost.id)  JOIN Tag AS knownTag ON (knownTag.id = post_hasTag_tag_$1.tag_id)  
JOIN post_hasCreator_person ON (post_hasCreator_person.post_id = commonPost.id)  JOIN Person AS friend ON (friend.id = post_hasCreator_person.person_id)
where knownTag.id = knownTagId
), SUB_843853757_V2 AS (
SELECT 'Post('||friendPost.id||')' AS friendPost,commonTag.id as commonTagId,'Tag('||commonTag.id||')' AS commonTag, commonTag.name as cName, personId, friendId, knownTagId FROM SUB_2018627083 AS friendPost JOIN post_hasTag_tag ON (post_hasTag_tag.post_id = friendPost.id)  JOIN Tag AS commonTag ON (commonTag.id = post_hasTag_tag.tag_id) WHERE commonTag.id != knownTagId
), SUB_1456464649_V2 AS (
SELECT cName, commonPost.id AS commonPost, personId, friendId, commonTagId, knownTag.id as knownTagId
FROM SUB_843853757_V2 AS commonTag 
JOIN post_hasTag_tag ON (post_hasTag_tag.tag_id = commonTagId)  JOIN Post AS commonPost ON (commonPost.id = post_hasTag_tag.post_id)  
JOIN post_hasTag_tag AS post_hasTag_tag_$1 ON (post_hasTag_tag_$1.post_id = commonPost.id)  JOIN Tag AS knownTag ON (knownTag.id = post_hasTag_tag_$1.tag_id)  
JOIN post_hasCreator_person ON (post_hasCreator_person.post_id = commonPost.id)  JOIN Person AS friend ON (friend.id = post_hasCreator_person.person_id)
where knownTag.id = knownTagId
) 
select /*+label(query6)*/ * from (
(SELECT  cName AS tagName,count (distinct SUB_1456464649.commonPost) AS postCount FROM SUB_1456464649 WHERE personId != friendId and commonTagId != knownTagId GROUP BY tagName ORDER BY postCount DESC , tagName )
union 
(SELECT  cName AS tagName,count (distinct SUB_1456464649_V2.commonPost) AS postCount FROM SUB_1456464649_V2 WHERE personId != friendId and commonTagId != knownTagId GROUP BY tagName ORDER BY postCount DESC , tagName)
) AS foo LIMIT 100;
