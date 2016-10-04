MATCH (person:Person {id:2199023259437})-[:KNOWS*1..2]->(friend:Person),
(friend)<-[:HAS_CREATOR]-(friendPost:Post)-[:HAS_TAG]->(knownTag:Tag {name:"A_Woman_and_a_Man"})
WHERE not(person=friend)
MATCH (friendPost)-[:HAS_TAG]->(commonTag:Tag)
WHERE not(commonTag=knownTag)
WITH DISTINCT commonTag, knownTag, friend
MATCH (commonTag)<-[:HAS_TAG]-(commonPost:Post)-[:HAS_TAG]->(knownTag)
WHERE (commonPost)-[:HAS_CREATOR]->(friend)
RETURN
commonTag.name AS tagName,
count(commonPost) AS postCount
ORDER BY postCount DESC, tagName ASC
LIMIT 20;
