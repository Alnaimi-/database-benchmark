EXPORT personId=2199023259437
EXPORT date="2016-7-7"
EXPORT top=20

MATCH (:Person {id:{personId}})-[:KNOWS*1..4]->(friend:Person)<-[:HAS_CREATOR]-(message)
WHERE message.creationDate < {date}
RETURN DISTINCT
message.id AS messageId,
CASE HAS(message.content)
        WHEN true THEN message.content
        ELSE message.imageFile
END AS messageContent,
message.creationDate AS messageCreationDate,
friend.id AS personId,
friend.firstName AS personFirstName,
friend.lastName AS personLastName
ORDER BY message.creationDate DESC, message.id ASC
LIMIT {top}
;