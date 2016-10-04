MATCH (person:Person {id:2199023259437})-[:KNOWS*1..2]-(friend:Person)
WHERE not(person=friend)
WITH DISTINCT friend
MATCH (friend)-[worksAt:WORKS_AT]->(company:Company)-[:IS_LOCATED_IN]->(:Country {url:"http://dbpedia.org/resource/France"})
WHERE worksAt.workFrom < "2016-7-7"
RETURN
friend.id AS friendId,
friend.firstName AS friendFirstName,
friend.lastName AS friendLastName,
worksAt.workFrom AS workFromYear,
company.name AS companyName
ORDER BY workFromYear ASC, friendId ASC, companyName DESC
LIMIT 20
;
