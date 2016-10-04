// Node Loading section:

// Load Person
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file://{{ LDBC_LOCATION }}/person_complete_0_0.csv" AS csvLine FIELDTERMINATOR "|"
CREATE (p:Person { id: toInt(csvLine.id), firstName: csvLine.firstName, lastName: csvLine.lastName, gender: csvLine.gender, birthday: csvLine.birthday, birthday_day: substring(csvLine.birthday, 8, 2), birthday_month: substring(csvLine.birthday, 5, 2), birthday_year: substring(csvLine.birthday, 0, 4), creationDate: csvLine.creationDate, locationIP: csvLine.locationIP, browserUsed: csvLine.browserUsed, languages: csvLine.languages, emails: csvLine.emails})
RETURN "Done creating " + count(csvLine) + " Person nodes"
;

// Load Cities
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file://{{ LDBC_LOCATION }}/city_0_0.csv" AS csvLine FIELDTERMINATOR "|"
CREATE (c:City:Place { id: toInt(csvLine.id), name: csvLine.name, url: csvLine.url })
RETURN "Done creating " + count(csvLine) + " Cities nodes"
;

// Load Countries
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file://{{ LDBC_LOCATION }}/country_0_0.csv" AS csvLine FIELDTERMINATOR "|"
CREATE (c:Country:Place { id: toInt(csvLine.id), name: csvLine.name, url: csvLine.url })
RETURN "Done creating " + count(csvLine) + " Countries nodes"
;

// Load Continents
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file://{{ LDBC_LOCATION }}/continent_0_0.csv" AS csvLine FIELDTERMINATOR "|"
CREATE (c:Continent:Place { id: toInt(csvLine.id), name: csvLine.name, url: csvLine.url })
RETURN "Done creating " + count(csvLine) + " Continents nodes"
;

// Load Forums
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file://{{ LDBC_LOCATION }}/forum_0_0.csv" AS csvLine FIELDTERMINATOR "|"
CREATE (f:Forum { id: toInt(csvLine.id), title: csvLine.title, creationDate: csvLine.creationDate })
RETURN "Done creating " + count(csvLine) + " Forums nodes"
;

// Load Post
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file://{{ LDBC_LOCATION }}/post_0_0.csv" AS csvLine FIELDTERMINATOR "|"
CREATE (p:Post:Message { id: toInt(csvLine.id), imageFile: csvLine.imageFile, creationDate: csvLine.creationDate, locationIP: csvLine.locationIP, browserUsed: csvLine.browserUsed, language: csvLine.language, content: csvLine.content, length: csvLine.length})
RETURN "Done creating " + count(csvLine) + " Post nodes"
;

// Load Comment
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file://{{ LDBC_LOCATION }}/comment_0_0.csv" AS csvLine FIELDTERMINATOR "|"
CREATE (p:Comment:Message { id: toInt(csvLine.id), creationDate: csvLine.creationDate, locationIP: csvLine.locationIP, browserUsed: csvLine.browserUsed, content: csvLine.content, length: csvLine.length})
RETURN "Done creating " + count(csvLine) + " Comment nodes"
;

// Load Companies
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file://{{ LDBC_LOCATION }}/company_0_0.csv" AS csvLine FIELDTERMINATOR "|"
CREATE (c:Company:Organisation { id: toInt(csvLine.id), name: csvLine.name, url: csvLine.url })
RETURN "Done creating " + count(csvLine) + " Companies nodes"
;

// Load Universities
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file://{{ LDBC_LOCATION }}/university_0_0.csv" AS csvLine FIELDTERMINATOR "|"
CREATE (u:University:Organisation { id: toInt(csvLine.id), name: csvLine.name, url: csvLine.url })
RETURN "Done creating " + count(csvLine) + " Universities nodes"
;

// Load Tag
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file://{{ LDBC_LOCATION }}/tag_0_0.csv" AS csvLine FIELDTERMINATOR "|"
CREATE (t:Tag { id: toInt(csvLine.id), name: csvLine.name, url: csvLine.url})
RETURN "Done creating " + count(csvLine) + " Tag nodes"
;

// Load Tag Class
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file://{{ LDBC_LOCATION }}/tagclass_0_0.csv" AS csvLine FIELDTERMINATOR "|"
CREATE (t:TagClass { id: toInt(csvLine.id), name: csvLine.name, url: csvLine.url})
RETURN "DONE creating " + count(csvLine) + " Tag Class nodes" 
;

// Index creation to improve relationship connection ===================================================================
CREATE CONSTRAINT ON (person:Person) ASSERT person.id IS UNIQUE;
CREATE CONSTRAINT ON (city:City) ASSERT city.id IS UNIQUE;
CREATE CONSTRAINT ON (country:Country) ASSERT country.id IS UNIQUE;
CREATE CONSTRAINT ON (continent:Continent) ASSERT continent.id IS UNIQUE;
CREATE CONSTRAINT ON (place:Place) ASSERT place.id IS UNIQUE;
CREATE CONSTRAINT ON (forum:Forum) ASSERT forum.id IS UNIQUE;
CREATE CONSTRAINT ON (post:Post) ASSERT post.id IS UNIQUE;
CREATE CONSTRAINT ON (comment:Comment) ASSERT comment.id IS UNIQUE;
CREATE CONSTRAINT ON (message:Message) ASSERT message.id IS UNIQUE;
CREATE CONSTRAINT ON (company:Company) ASSERT company.id IS UNIQUE;
CREATE CONSTRAINT ON (university:University) ASSERT university.id IS UNIQUE;
CREATE CONSTRAINT ON (organisation:Organisation) ASSERT organisation.id IS UNIQUE;
CREATE CONSTRAINT ON (tag:Tag) ASSERT tag.id IS UNIQUE;
CREATE CONSTRAINT ON (tagclass:TagClass) ASSERT tagclass.id IS UNIQUE;

// Relationships Loading section: ======================================================================================

// Relationships with TAG as SOURCE

// TagClass IS SUBCLASS OF TagClass relationship
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/tagclass_isSubclassOf_tagclass_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (tagclass:TagClass { id: toInt(csvLine[0])}),(tagclass2:TagClass { id: toInt(csvLine[1])})
CREATE (tagclass)-[:IS_SUBCLASS_OF]->(tagclass2)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " TagClass subclass of TagClass edges"
;

//Tag HAS_TYPE TagClass relationship
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/tag_hasType_tagclass_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (tag:Tag { id: toInt(csvLine[0])}),(tagclass:TagClass { id: toInt(csvLine[1])})
CREATE (tag)-[:HAS_TYPE]->(tagclass)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Tag HAS_TYPE TagClass"
;



// Relationships with PERSON as SOURCE

// Person knows Person relationship
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/person_knows_person_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (person:Person { id: toInt(csvLine[0])}),(person2:Person { id: toInt(csvLine[1])})
CREATE (person)-[:KNOWS { creationDate: csvLine[2] }]->(person2)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Person knows Person edges"
;

// Person is Located In
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/person_isLocatedIn_place_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (person:Person { id: toInt(csvLine[0])}),(city:City { id: toInt(csvLine[1])})
CREATE (person)-[:IS_LOCATED_IN ]->(city)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Person is Located In Edges"
;

// Person has Interest Tag
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/person_hasInterest_tag_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (person:Person { id: toInt(csvLine[0])}),(tag:Tag { id: toInt(csvLine[1])})
CREATE (person)-[:HAS_INTEREST ]->(tag)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Person has Interest Tag Edges"
;


// Person likes Post
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/person_likes_post_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (person:Person { id: toInt(csvLine[0])}),(post:Message { id: toInt(csvLine[1])})
CREATE (person)-[:LIKES { creationDate: csvLine[2] }]->(post)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Person likes Post Edges"
;

// Person likes Comment
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/person_likes_comment_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (person:Person { id: toInt(csvLine[0])}),(comment:Message { id: toInt(csvLine[1])})
CREATE (person)-[:LIKES { creationDate: csvLine[2] }]->(comment)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Person likes Comment Edges"
;

// Person study at university
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/person_studyAt_organisation_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (person:Person { id: toInt(csvLine[0])}),(university:University { id: toInt(csvLine[1])})
CREATE (person)-[:STUDY_AT { classYear: csvLine[2] }]->(university)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Person study at university Edges"
;

// Person works at organisation
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/person_workAt_organisation_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (person:Person { id: toInt(csvLine[0])}),(company:Company { id: toInt(csvLine[1])})
CREATE (person)-[:WORKS_AT { workFrom: csvLine[2] }]->(company)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Person works at organisation Edges"
;

// Relationships with ORGANISATION as SOURCE
// Organisation is located in place
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/organisation_isLocatedIn_place_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (org:Organisation { id: toInt(csvLine[0])}),(place:Place { id: toInt(csvLine[1])})
CREATE (org)-[:IS_LOCATED_IN ]->(place)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Organisation is located in place Edges"
;

// Relationships with PLACE as SOURCE
// Place is part of Place
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/place_isPartOf_place_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (place1:Place { id: toInt(csvLine[0])}),(place2:Place { id: toInt(csvLine[1])})
CREATE (place1)-[:IS_PART_OF ]->(place2)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Place is part of Place Edges"
;

// Relationships with MESSAGE as SOURCE
// Message has creator Person
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/comment_hasCreator_person_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (comment:Message { id: toInt(csvLine[0])}),(person:Person { id: toInt(csvLine[1])})
CREATE (comment)-[:HAS_CREATOR ]->(person)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Message has creator Person Edges"
;

// Message has creator Person
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/post_hasCreator_person_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (comment:Message { id: toInt(csvLine[0])}),(person:Person { id: toInt(csvLine[1])})
CREATE (comment)-[:HAS_CREATOR ]->(person)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Message has creator Person Edges"
;

// Message has Tag
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/comment_hasTag_tag_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (message:Message { id: toInt(csvLine[0])}),(tag:Tag { id: toInt(csvLine[1])})
CREATE (message)-[:HAS_TAG ]->(tag)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Message has Tag Edges"
;

USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/post_hasTag_tag_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (message:Message { id: toInt(csvLine[0])}),(tag:Tag { id: toInt(csvLine[1])})
CREATE (message)-[:HAS_TAG ]->(tag)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Message has Tag Edges"
;

// Comment reply of comment
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/comment_replyOf_comment_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (message:Message { id: toInt(csvLine[0])}),(message2:Message { id: toInt(csvLine[1])})
CREATE (message)-[:REPLY_OF ]->(message2)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Comment reply of comment Edges"
;

// Comment reply of Post
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/comment_replyOf_post_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (message:Message { id: toInt(csvLine[0])}),(message2:Message { id: toInt(csvLine[1])})
CREATE (message)-[:REPLY_OF ]->(message2)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Comment reply of Post Edges"
;

// Message located in
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/comment_isLocatedIn_place_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (message:Message { id: toInt(csvLine[0])}),(place:Place { id: toInt(csvLine[1])})
CREATE (message)-[:IS_LOCATED_IN ]->(place)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Message located in Edges"
;

// Post is located in place
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/post_isLocatedIn_place_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (post:Message { id: toInt(csvLine[0])}),(place:Place { id: toInt(csvLine[1])})
CREATE (post)-[:IS_LOCATED_IN ]->(place)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Post is located in place Edges"
;

// Relationships with FORUM as SOURCE
// Forum has member Person
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/forum_hasMember_person_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (forum:Forum { id: toInt(csvLine[0])}),(person:Person { id: toInt(csvLine[1])})
CREATE (forum)-[:HAS_MEMBER  { joinDate: csvLine[2]}]->(person)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Forum has member Person Edges"
;

// Forum has Moderator Person
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/forum_hasModerator_person_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (forum:Forum { id: toInt(csvLine[0])}),(person:Person { id: toInt(csvLine[1])})
CREATE (forum)-[:HAS_MODERATOR  ]->(person)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Forum has Moderator Person Edges"
;

// Forum container of Post
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/forum_containerOf_post_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (forum:Forum { id: toInt(csvLine[0])}),(post:Post { id: toInt(csvLine[1])})
CREATE (forum)-[:CONTAINER_OF  ]->(post)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Forum container of Post Edges"
;

// Forum has TAG
USING PERIODIC COMMIT
LOAD CSV FROM "file://{{ LDBC_LOCATION }}/forum_hasTag_tag_0_0.csv" AS csvLine FIELDTERMINATOR "|"
MATCH (forum:Forum { id: toInt(csvLine[0])}),(tag:Tag { id: toInt(csvLine[1])})
CREATE (forum)-[:HAS_TAG  ]->(tag)
WITH csvLine SKIP 1
//LIMIT 4
RETURN "Done creating " + count(csvLine) + " Forum has TAG Edges"
;

// Remove Indexes ======================================================================================================

DROP CONSTRAINT ON (person:Person) ASSERT person.id IS UNIQUE;
DROP CONSTRAINT ON (city:City) ASSERT city.id IS UNIQUE;
DROP CONSTRAINT ON (country:Country) ASSERT country.id IS UNIQUE;
DROP CONSTRAINT ON (continent:Continent) ASSERT continent.id IS UNIQUE;
DROP CONSTRAINT ON (place:Place) ASSERT place.id IS UNIQUE;
DROP CONSTRAINT ON (forum:Forum) ASSERT forum.id IS UNIQUE;
DROP CONSTRAINT ON (post:Post) ASSERT post.id IS UNIQUE;
DROP CONSTRAINT ON (comment:Comment) ASSERT comment.id IS UNIQUE;
DROP CONSTRAINT ON (message:Message) ASSERT message.id IS UNIQUE;
DROP CONSTRAINT ON (company:Company) ASSERT company.id IS UNIQUE;
DROP CONSTRAINT ON (university:University) ASSERT university.id IS UNIQUE;
DROP CONSTRAINT ON (organisation:Organisation) ASSERT organisation.id IS UNIQUE;
DROP CONSTRAINT ON (tag:Tag) ASSERT tag.id IS UNIQUE;
DROP CONSTRAINT ON (tagclass:TagClass) ASSERT tagclass.id IS UNIQUE;
