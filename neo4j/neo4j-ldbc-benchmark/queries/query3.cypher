MATCH (person:Person {id:2199023259437})-[:KNOWS*1..2]->(friend:Person)<-[:HAS_CREATOR]-(messageX),
(messageX)-[:IS_LOCATED_IN]->(countryX:Country)
WHERE not(person=friend) AND
not((friend)-[:IS_LOCATED_IN]->()-[:IS_PART_OF]->(countryX))
AND countryX.url="http://dbpedia.org/resource/France"
AND messageX.creationDate>="1990-7-7"
AND messageX.creationDate< "2016-7-7"
WITH friend, count(DISTINCT messageX) AS xCount
MATCH (friend)<-[:HAS_CREATOR]-(messageY)-[:IS_LOCATED_IN]->(countryY:Country)
WHERE countryY.url="http://dbpedia.org/resource/France"
AND not((friend)-[:IS_LOCATED_IN]->()-[:IS_PART_OF]->(countryY))
AND messageY.creationDate>="1990-7-7"
AND messageY.creationDate< "2016-7-7"
WITH friend.id AS friendId,
friend.firstName AS friendFirstName,
friend.lastName AS friendLastName,
xCount,
count(DISTINCT messageY) AS yCount
RETURN
friendId,
friendFirstName,
friendLastName,
xCount,
yCount,
xCount + yCount AS xyCount
ORDER BY xyCount DESC, friendId ASC
LIMIT 100
;




