MATCH (person:Person {id:2199023259437})<-[:HAS_CREATOR]-(message)<-[like:LIKES]-(liker:Person)
WITH liker, message, like.creationDate AS likeTime, person
ORDER BY likeTime DESC, message.id ASC
WITH liker, head(collect({msg: message, likeTime: likeTime})) AS latestLike, person
RETURN
liker.id AS personId,
liker.firstName AS personFirstName,
liker.lastName AS personLastName,
latestLike.likeTime AS likeTime,
not((liker)-[:KNOWS]-(person)) AS isNew,
latestLike.msg.id AS messageId,
latestLike.msg.content AS messageContent
ORDER BY likeTime DESC, personId ASC
LIMIT 100;

//removed latency as would not work with current version
