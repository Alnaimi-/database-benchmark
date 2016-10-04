MATCH (:Person {id:2199023259437})-[:KNOWS]->(friend:Person) <-[:HAS_CREATOR]-(message)
WHERE message.creationDate <= "2016-7-7" AND (message:Post OR message:Comment)
RETURN
        friend.id AS personId,
        friend.firstName AS personFirstName,
        friend.lastName AS personLastName,
        message.id AS messageId,
        CASE has (message.content)
                WHEN true THEN message.content
                ELSE message.imageFile
        END AS messageContent,
        message.creationDate AS messageDate
ORDER BY messageDate DESC, messageId ASC
LIMIT 20
;
