\o /dev/null

SELECT /*+label(query9multihop4)*/ DISTINCT *
FROM
  (SELECT DISTINCT message.id AS messageId,
                   message.creationDate AS messageCreationDate,
                   friend.id AS personId,
                   friend.firstName AS personFirstName,
                   friend.lastName AS personLastName,
                   CASE
                       WHEN message.content IS NOT NULL THEN message.content
                       ELSE ''
                   END AS messageContent
   FROM person AS p_$1
   JOIN person_knows_person ON (person_knows_person.person_id = p_$1.id)
   JOIN Person AS p_$2 ON (p_$2.id = person_knows_person.other_person_id)
   JOIN person_knows_person AS person_knows_person_$1 ON (person_knows_person_$1.person_id = p_$2.id)
   JOIN Person AS friend ON (friend.id = person_knows_person_$1.other_person_id)
   JOIN comment_hasCreator_person ON (comment_hasCreator_person.person_id = friend.id)
   JOIN COMMENT AS message ON (message.id = comment_hasCreator_person.comment_id)
   WHERE p_$1.id = 2199023259437
     AND message.creationDate < '2016-7-7'
   UNION SELECT DISTINCT message.id AS messageId,
                         message.creationDate AS messageCreationDate,
                         friend.id AS personId,
                         friend.firstName AS personFirstName,
                         friend.lastName AS personLastName,
                         CASE
                             WHEN message.content IS NOT NULL THEN message.content
                             ELSE ''
                         END AS messageContent
   FROM person AS p_$1
   JOIN person_knows_person ON (person_knows_person.person_id = p_$1.id)
   JOIN Person AS p_$2 ON (p_$2.id = person_knows_person.other_person_id)
   JOIN person_knows_person AS person_knows_person_$1 ON (person_knows_person_$1.person_id = p_$2.id)
   JOIN Person AS p_$3 ON (p_$3.id = person_knows_person_$1.other_person_id)
   JOIN person_knows_person AS person_knows_person_$2 ON (person_knows_person_$2.person_id = p_$3.id)
   JOIN Person AS friend ON (friend.id = person_knows_person_$2.other_person_id)
   JOIN comment_hasCreator_person ON (comment_hasCreator_person.person_id = friend.id)
   JOIN COMMENT AS message ON (message.id = comment_hasCreator_person.comment_id)
   WHERE p_$1.id = 2199023259437
     AND message.creationDate < '2016-7-7'
   UNION SELECT DISTINCT message.id AS messageId,
                         message.creationDate AS messageCreationDate,
                         friend.id AS personId,
                         friend.firstName AS personFirstName,
                         friend.lastName AS personLastName,
                         CASE
                             WHEN message.content IS NOT NULL THEN message.content
                             ELSE ''
                         END AS messageContent
   FROM person AS p_$1
   JOIN person_knows_person ON (person_knows_person.person_id = p_$1.id)
   JOIN Person AS p_$2 ON (p_$2.id = person_knows_person.other_person_id)
   JOIN person_knows_person AS person_knows_person_$1 ON (person_knows_person_$1.person_id = p_$2.id)
   JOIN Person AS p_$3 ON (p_$3.id = person_knows_person_$1.other_person_id)
   JOIN person_knows_person AS person_knows_person_$2 ON (person_knows_person_$2.person_id = p_$3.id)
   JOIN Person AS p_$4 ON (p_$4.id = person_knows_person_$2.other_person_id)
   JOIN person_knows_person AS person_knows_person_$3 ON (person_knows_person_$3.person_id = p_$4.id)
   JOIN Person AS friend ON (friend.id = person_knows_person_$3.other_person_id)
   JOIN comment_hasCreator_person ON (comment_hasCreator_person.person_id = friend.id)
   JOIN COMMENT AS message ON (message.id = comment_hasCreator_person.comment_id)
   WHERE p_$1.id = 2199023259437
     AND message.creationDate < '2016-7-7'
   UNION SELECT DISTINCT message.id AS messageId,
                         message.creationDate AS messageCreationDate,
                         friend.id AS personId,
                         friend.firstName AS personFirstName,
                         friend.lastName AS personLastName,
                         CASE
                             WHEN message.content IS NOT NULL THEN message.content
                             ELSE message.imageFile
                         END AS messageContent
   FROM person AS p_$1
   JOIN person_knows_person ON (person_knows_person.person_id = p_$1.id)
   JOIN Person AS friend ON (friend.id = person_knows_person.other_person_id)
   JOIN post_hasCreator_person ON (post_hasCreator_person.person_id = friend.id)
   JOIN Post AS message ON (message.id = post_hasCreator_person.post_id)
   WHERE p_$1.id = 2199023259437
     AND message.creationDate < '2016-7-7'
   UNION SELECT DISTINCT message.id AS messageId,
                         message.creationDate AS messageCreationDate,
                         friend.id AS personId,
                         friend.firstName AS personFirstName,
                         friend.lastName AS personLastName,
                         CASE
                             WHEN message.content IS NOT NULL THEN message.content
                             ELSE message.imageFile
                         END AS messageContent
   FROM person AS p_$1
   JOIN person_knows_person ON (person_knows_person.person_id = p_$1.id)
   JOIN Person AS p_$2 ON (p_$2.id = person_knows_person.other_person_id)
   JOIN person_knows_person AS person_knows_person_$1 ON (person_knows_person_$1.person_id = p_$2.id)
   JOIN Person AS p_$3 ON (p_$3.id = person_knows_person_$1.other_person_id)
   JOIN person_knows_person AS person_knows_person_$2 ON (person_knows_person_$2.person_id = p_$3.id)
   JOIN Person AS friend ON (friend.id = person_knows_person_$2.other_person_id)
   JOIN post_hasCreator_person ON (post_hasCreator_person.person_id = friend.id)
   JOIN Post AS message ON (message.id = post_hasCreator_person.post_id)
   WHERE p_$1.id = 2199023259437
     AND message.creationDate < '2016-7-7'
   UNION SELECT DISTINCT message.id AS messageId,
                         message.creationDate AS messageCreationDate,
                         friend.id AS personId,
                         friend.firstName AS personFirstName,
                         friend.lastName AS personLastName,
                         CASE
                             WHEN message.content IS NOT NULL THEN message.content
                             ELSE message.imageFile
                         END AS messageContent
   FROM person AS p_$1
   JOIN person_knows_person ON (person_knows_person.person_id = p_$1.id)
   JOIN Person AS p_$2 ON (p_$2.id = person_knows_person.other_person_id)
   JOIN person_knows_person AS person_knows_person_$1 ON (person_knows_person_$1.person_id = p_$2.id)
   JOIN Person AS friend ON (friend.id = person_knows_person_$1.other_person_id)
   JOIN post_hasCreator_person ON (post_hasCreator_person.person_id = friend.id)
   JOIN Post AS message ON (message.id = post_hasCreator_person.post_id)
   WHERE p_$1.id = 2199023259437
     AND message.creationDate < '2016-7-7'
   UNION SELECT DISTINCT message.id AS messageId,
                         message.creationDate AS messageCreationDate,
                         friend.id AS personId,
                         friend.firstName AS personFirstName,
                         friend.lastName AS personLastName,
                         CASE
                             WHEN message.content IS NOT NULL THEN message.content
                             ELSE ''
                         END AS messageContent
   FROM person AS p_$1
   JOIN person_knows_person ON (person_knows_person.person_id = p_$1.id)
   JOIN Person AS friend ON (friend.id = person_knows_person.other_person_id)
   JOIN comment_hasCreator_person ON (comment_hasCreator_person.person_id = friend.id)
   JOIN COMMENT AS message ON (message.id = comment_hasCreator_person.comment_id)
   WHERE p_$1.id = 2199023259437
     AND message.creationDate < '2016-7-7'
   UNION SELECT DISTINCT message.id AS messageId,
                         message.creationDate AS messageCreationDate,
                         friend.id AS personId,
                         friend.firstName AS personFirstName,
                         friend.lastName AS personLastName,
                         CASE
                             WHEN message.content IS NOT NULL THEN message.content
                             ELSE message.imageFile
                         END AS messageContent
   FROM person AS p_$1
   JOIN person_knows_person ON (person_knows_person.person_id = p_$1.id)
   JOIN Person AS p_$2 ON (p_$2.id = person_knows_person.other_person_id)
   JOIN person_knows_person AS person_knows_person_$1 ON (person_knows_person_$1.person_id = p_$2.id)
   JOIN Person AS p_$3 ON (p_$3.id = person_knows_person_$1.other_person_id)
   JOIN person_knows_person AS person_knows_person_$2 ON (person_knows_person_$2.person_id = p_$3.id)
   JOIN Person AS p_$4 ON (p_$4.id = person_knows_person_$2.other_person_id)
   JOIN person_knows_person AS person_knows_person_$3 ON (person_knows_person_$3.person_id = p_$4.id)
   JOIN Person AS friend ON (friend.id = person_knows_person_$3.other_person_id)
   JOIN post_hasCreator_person ON (post_hasCreator_person.person_id = friend.id)
   JOIN Post AS message ON (message.id = post_hasCreator_person.post_id)
   WHERE p_$1.id = 2199023259437
     AND message.creationDate < '2016-7-7') AS unionAlias
ORDER BY messageCreationDate DESC,
         messageId LIMIT 100;

