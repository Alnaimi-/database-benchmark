MATCH (person:Person {id:2199023259437})-[:KNOWS*1..2]-(friend:Person)<-[membership:HAS_MEMBER]-(forum:Forum)
WHERE membership.joinDate>"1990-7-7" AND not(person=friend)
WITH DISTINCT friend, forum
OPTIONAL MATCH (friend)<-[:HAS_CREATOR]-(post:Post)<-[:CONTAINER_OF]-(forum)
WITH forum, count(post) AS postCount
RETURN
forum.title AS forumName,
postCount
ORDER BY postCount DESC, forum.id ASC
LIMIT 100;

