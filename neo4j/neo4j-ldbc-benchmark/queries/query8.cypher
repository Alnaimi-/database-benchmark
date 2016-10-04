MATCH (start:Person {id:2199023259437})<-[:HAS_CREATOR]-()<-[:REPLY_OF]-(comment:Comment)-[:HAS_CREATOR]->(person:Person)
RETURN
person.id AS personId,
person.firstName AS personFirstName,
person.lastName AS personLastName,
comment.id AS commentId,
comment.creationDate AS commentCreationDate,
comment.content AS commentContent
ORDER BY commentCreationDate DESC, commentId ASC
limit 20
;
