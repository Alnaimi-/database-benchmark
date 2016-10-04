MATCH (person:Person {id:2199023259437})-[:KNOWS]->(:Person)<-[:HAS_CREATOR]-(post:Post)-[HAS_TAG]->(tag:Tag)
WHERE post.creationDate >= "2010-02-01" AND post.creationDate < "2016-7-7"
OPTIONAL MATCH (tag)<-[:HAS_TAG]-(oldPost:Post)
WHERE oldPost.creationDate < "2010-02-01"
WITH tag, post, length(collect(oldPost)) AS oldPostCount
WHERE oldPostCount=0
RETURN
tag.name AS tagName,
length(collect(post)) AS postCount
ORDER BY postCount DESC, tagName ASC
LIMIT 100;

##Could not find any working dates for this one
