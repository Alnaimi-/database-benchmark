#This file changes the headers of the LDBC csv files to 
#the syntax requried by the neo4j bulk ingester

DATALOCATION=$1
echo "Changing Node Headers"
############################################ NODE CHANGES ###################################################

#Person file changes
sed -i '1,1s/id/id:ID(Person)/g' $DATALOCATION/person_complete_0_0.csv
#City file changes
sed -i '1,1s/id/id:ID(Place)/g' $DATALOCATION/city_0_0.csv
#Country file changes
sed -i '1,1s/id/id:ID(Place)/g' $DATALOCATION/country_0_0.csv
#Continent file changes
sed -i '1,1s/id/id:ID(Place)/g' $DATALOCATION/continent_0_0.csv
#Forum file changes
sed -i '1,1s/id/id:ID(Forum)/g' $DATALOCATION/forum_0_0.csv
#Post file changes
sed -i '1,1s/id/id:ID(Message)/g' $DATALOCATION/post_0_0.csv
#Comment file changes
sed -i '1,1s/id/id:ID(Message)/g' $DATALOCATION/comment_0_0.csv
#Company file changes
sed -i '1,1s/id/id:ID(Organisation)/g' $DATALOCATION/company_0_0.csv
#University file changes
sed -i '1,1s/id/id:ID(Organisation)/g' $DATALOCATION/university_0_0.csv
#Tag file changes
sed -i '1,1s/id/id:ID(Tag)/g' $DATALOCATION/tag_0_0.csv
#TagClass file changes
sed -i '1,1s/id/id:ID(TagClass)/g' $DATALOCATION/tagclass_0_0.csv

######################################## RELATIONSHIP CHANGES ###############################################

echo "Changing relationship headers "
#TagClass subclass of tagclass
sed -i '1,1s/TagClass.id/:START_ID(TagClass)/' $DATALOCATION/tagclass_isSubclassOf_tagclass_0_0.csv
sed -i '1,1s/TagClass.id/:END_ID(TagClass)/' $DATALOCATION/tagclass_isSubclassOf_tagclass_0_0.csv

#Tag has type TagClass
sed -i '1,1s/Tag.id/:START_ID(Tag)/' $DATALOCATION/tag_hasType_tagclass_0_0.csv
sed -i '1,1s/TagClass.id/:END_ID(TagClass)/' $DATALOCATION/tag_hasType_tagclass_0_0.csv

#person knows person
sed -i '1,1s/Person.id/:START_ID(Person)/' $DATALOCATION/person_knows_person_0_0.csv
sed -i '1,1s/Person.id/:END_ID(Person)/' $DATALOCATION/person_knows_person_0_0.csv

#Person is located in city
sed -i '1,1s/Person.id/:START_ID(Person)/' $DATALOCATION/person_isLocatedIn_place_0_0.csv
sed -i '1,1s/Place.id/:END_ID(Place)/' $DATALOCATION/person_isLocatedIn_place_0_0.csv

#Person has Interest Tag
sed -i '1,1s/Person.id/:START_ID(Person)/' $DATALOCATION/person_hasInterest_tag_0_0.csv
sed -i '1,1s/Tag.id/:END_ID(Tag)/' $DATALOCATION/person_hasInterest_tag_0_0.csv

#Person likes Post
sed -i '1,1s/Person.id/:START_ID(Person)/' $DATALOCATION/person_likes_post_0_0.csv
sed -i '1,1s/Post.id/:END_ID(Message)/' $DATALOCATION/person_likes_post_0_0.csv

#Person likes Comment
sed -i '1,1s/Person.id/:START_ID(Person)/' $DATALOCATION/person_likes_comment_0_0.csv
sed -i '1,1s/Comment.id/:END_ID(Message)/' $DATALOCATION/person_likes_comment_0_0.csv

#Person Study At University
sed -i '1,1s/Person.id/:START_ID(Person)/' $DATALOCATION/person_studyAt_organisation_0_0.csv
sed -i '1,1s/Organisation.id/:END_ID(Organisation)/' $DATALOCATION/person_studyAt_organisation_0_0.csv

#Person works at organisation
sed -i '1,1s/Person.id/:START_ID(Person)/' $DATALOCATION/person_workAt_organisation_0_0.csv
sed -i '1,1s/Organisation.id/:END_ID(Organisation)/' $DATALOCATION/person_workAt_organisation_0_0.csv

#Organisation is loacted in place
sed -i '1,1s/Organisation.id/:START_ID(Organisation)/' $DATALOCATION/organisation_isLocatedIn_place_0_0.csv
sed -i '1,1s/Place.id/:END_ID(Place)/' $DATALOCATION/organisation_isLocatedIn_place_0_0.csv

#Place is part of place
sed -i '1,1s/Place.id/:START_ID(Place)/' $DATALOCATION/place_isPartOf_place_0_0.csv
sed -i '1,1s/Place.id/:END_ID(Place)/' $DATALOCATION/place_isPartOf_place_0_0.csv

#Comment has creator Person
sed -i '1,1s/Comment.id/:START_ID(Message)/' $DATALOCATION/comment_hasCreator_person_0_0.csv
sed -i '1,1s/Person.id/:END_ID(Person)/' $DATALOCATION/comment_hasCreator_person_0_0.csv

#Post has creator Person
sed -i '1,1s/Post.id/:START_ID(Message)/' $DATALOCATION/post_hasCreator_person_0_0.csv
sed -i '1,1s/Person.id/:END_ID(Person)/' $DATALOCATION/post_hasCreator_person_0_0.csv

#Comment has tag
sed -i '1,1s/Comment.id/:START_ID(Message)/' $DATALOCATION/comment_hasTag_tag_0_0.csv
sed -i '1,1s/Tag.id/:END_ID(Tag)/' $DATALOCATION/comment_hasTag_tag_0_0.csv

#Post has tag
sed -i '1,1s/Post.id/:START_ID(Message)/' $DATALOCATION/post_hasTag_tag_0_0.csv
sed -i '1,1s/Tag.id/:END_ID(Tag)/' $DATALOCATION/post_hasTag_tag_0_0.csv

#Comment reply of Comment
sed -i '1,1s/Comment.id/:START_ID(Message)/' $DATALOCATION/comment_replyOf_comment_0_0.csv
sed -i '1,1s/Comment.id/:END_ID(Message)/' $DATALOCATION/comment_replyOf_comment_0_0.csv

#Comment reply of Post
sed -i '1,1s/Comment.id/:START_ID(Message)/' $DATALOCATION/comment_replyOf_post_0_0.csv
sed -i '1,1s/Post.id/:END_ID(Message)/' $DATALOCATION/comment_replyOf_post_0_0.csv

#Comment is located in place
sed -i '1,1s/Comment.id/:START_ID(Message)/' $DATALOCATION/comment_isLocatedIn_place_0_0.csv
sed -i '1,1s/Place.id/:END_ID(Place)/' $DATALOCATION/comment_isLocatedIn_place_0_0.csv

#Post is located in place
sed -i '1,1s/Post.id/:START_ID(Message)/' $DATALOCATION/post_isLocatedIn_place_0_0.csv
sed -i '1,1s/Place.id/:END_ID(Place)/' $DATALOCATION/post_isLocatedIn_place_0_0.csv

#Forum has member person
sed -i '1,1s/Forum.id/:START_ID(Forum)/' $DATALOCATION/forum_hasMember_person_0_0.csv
sed -i '1,1s/Person.id/:END_ID(Person)/' $DATALOCATION/forum_hasMember_person_0_0.csv

#Forum has moderator person
sed -i '1,1s/Forum.id/:START_ID(Forum)/' $DATALOCATION/forum_hasModerator_person_0_0.csv
sed -i '1,1s/Person.id/:END_ID(Person)/' $DATALOCATION/forum_hasModerator_person_0_0.csv

#Forum container of Post
sed -i '1,1s/Forum.id/:START_ID(Forum)/' $DATALOCATION/forum_containerOf_post_0_0.csv
sed -i '1,1s/Post.id/:END_ID(Message)/' $DATALOCATION/forum_containerOf_post_0_0.csv

#Forum has Tag
sed -i '1,1s/Forum.id/:START_ID(Forum)/' $DATALOCATION/forum_hasTag_tag_0_0.csv
sed -i '1,1s/Tag.id/:END_ID(Tag)/' $DATALOCATION/forum_hasTag_tag_0_0.csv

echo "Finished changing headers"
