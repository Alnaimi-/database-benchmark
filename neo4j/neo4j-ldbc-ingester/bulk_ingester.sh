#This file contains the LDBC import command using the Neo4J import tool
#The sytax is fairly self explainitory, but for a better understanding 
#the usage documents can be accessed via the wayback machine
#as the actual page 404's :
#https://web.archive.org/web/20160329053359/http://neo4j.com/docs/milestone/import-tool-usage.html

DATA_LOCATION=$1
FOLDER_NAME=$2

echo "Populating NEO4J LDBC database"

$NEO4J_HOME/bin/neo4j-import \
 --into $FOLDER_NAME \
 --delimiter '|' \
 --id-type integer \
 --nodes:Person $DATA_LOCATION/person_complete_0_0.csv \
 --nodes:City:Place $DATA_LOCATION/city_0_0.csv \
 --nodes:Country:Place $DATA_LOCATION/country_0_0.csv \
 --nodes:Continent:Place $DATA_LOCATION/continent_0_0.csv \
 --nodes:Forum $DATA_LOCATION/forum_0_0.csv \
 --nodes:Post:Message $DATA_LOCATION/post_0_0.csv \
 --nodes:Comment:Message $DATA_LOCATION/comment_0_0.csv \
 --nodes:Company:Organisation $DATA_LOCATION/company_0_0.csv \
 --nodes:University:Organisation $DATA_LOCATION/university_0_0.csv \
 --nodes:Tag $DATA_LOCATION/tag_0_0.csv \
 --nodes:TagClass $DATA_LOCATION/tagclass_0_0.csv \
 --relationships:IS_SUBCLASS_OF $DATA_LOCATION/tagclass_isSubclassOf_tagclass_0_0.csv \
 --relationships:HAS_TYPE $DATA_LOCATION/tag_hasType_tagclass_0_0.csv \
 --relationships:KNOWS $DATA_LOCATION/person_knows_person_0_0.csv \
 --relationships:IS_LOCATED_IN $DATA_LOCATION/person_isLocatedIn_place_0_0.csv \
 --relationships:HAS_INTEREST $DATA_LOCATION/person_hasInterest_tag_0_0.csv \
 --relationships:LIKES $DATA_LOCATION/person_likes_post_0_0.csv \
 --relationships:LIKES $DATA_LOCATION/person_likes_comment_0_0.csv \
 --relationships:STUDY_AT $DATA_LOCATION/person_studyAt_organisation_0_0.csv \
 --relationships:WORKS_AT $DATA_LOCATION/person_workAt_organisation_0_0.csv \
 --relationships:IS_LOCATED_IN $DATA_LOCATION/organisation_isLocatedIn_place_0_0.csv \
 --relationships:IS_PART_OF $DATA_LOCATION/place_isPartOf_place_0_0.csv \
 --relationships:HAS_CREATOR $DATA_LOCATION/comment_hasCreator_person_0_0.csv \
 --relationships:HAS_CREATOR $DATA_LOCATION/post_hasCreator_person_0_0.csv \
 --relationships:HAS_TAG $DATA_LOCATION/comment_hasTag_tag_0_0.csv \
 --relationships:HAS_TAG $DATA_LOCATION/post_hasTag_tag_0_0.csv \
 --relationships:REPLY_OF $DATA_LOCATION/comment_replyOf_comment_0_0.csv \
 --relationships:REPLY_OF $DATA_LOCATION/comment_replyOf_post_0_0.csv \
 --relationships:IS_LOCATED_IN $DATA_LOCATION/comment_isLocatedIn_place_0_0.csv \
 --relationships:IS_LOCATED_IN $DATA_LOCATION/post_isLocatedIn_place_0_0.csv \
 --relationships:HAS_MEMBER $DATA_LOCATION/forum_hasMember_person_0_0.csv \
 --relationships:HAS_MODERATOR $DATA_LOCATION/forum_hasModerator_person_0_0.csv \
 --relationships:CONTAINER_OF $DATA_LOCATION/forum_containerOf_post_0_0.csv \
 --relationships:HAS_TAG $DATA_LOCATION/forum_hasTag_tag_0_0.csv

