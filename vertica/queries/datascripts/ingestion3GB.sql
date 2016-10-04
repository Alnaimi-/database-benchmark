drop table if exists place_isPartOf_place CASCADE;
drop table if exists organisation_isLocatedIn_place CASCADE;
drop table if exists tagclass_isSubclassOf_tagclass CASCADE;
drop table if exists tag_hasType_tagclass CASCADE;
drop table if exists tagclass CASCADE;
drop table if exists comment_hasCreator_person CASCADE;
drop table if exists comment_hasTag_tag CASCADE;
drop table if exists comment_isLocatedIn_place CASCADE;
drop table if exists comment_replyOf_comment CASCADE;
drop table if exists post_isLocatedIn_place CASCADE;
drop table if exists post_hasTag_tag CASCADE;
drop table if exists post_hasCreator_person CASCADE;
drop table if exists comment_replyOf_post CASCADE;
drop table if exists forum_hasTag_tag CASCADE;
drop table if exists forum_hasModerator_person CASCADE;
drop table if exists forum_hasMember_person CASCADE;
drop table if exists forum_containerOf_post CASCADE;
drop table if exists forum CASCADE;
drop table if exists person_knows_person CASCADE;
drop table if exists person_isLocatedIn_place CASCADE;
drop table if exists person_hasInterest_tag CASCADE;
drop table if exists person_email_emailaddress CASCADE;
drop table if exists city_isPartOf_country CASCADE;
drop table if exists comment_hasCreator_person CASCADE;
drop table if exists comment_hasTag_tag CASCADE;
drop table if exists comment_isLocatedIn_country CASCADE;
drop table if exists comment_replyOf_comment CASCADE;
drop table if exists comment_replyOf_post CASCADE;
drop table if exists company_isLocatedIn_country CASCADE;
drop table if exists country_isPartOf_continent CASCADE;
drop table if exists forum_containerOf_post CASCADE;
drop table if exists forum_hasMember_person CASCADE;
drop table if exists forum_hasModerator_person CASCADE;
drop table if exists forum_hasTag_tag CASCADE;
drop table if exists person_email_emailaddress CASCADE;
drop table if exists person_hasInterest_tag CASCADE;
drop table if exists person_isLocatedIn_city CASCADE;
drop table if exists person_knows_person CASCADE;
drop table if exists person_likes_comment CASCADE;
drop table if exists person_likes_post CASCADE;
drop table if exists person_speaks_language CASCADE;
drop table if exists person_studyAt_university CASCADE;
drop table if exists person_workAt_company CASCADE;
drop table if exists person_isLocatedIn_country CASCADE;
drop table if exists person_isLocatedIn_continent CASCADE;
drop table if exists post_hasCreator_person CASCADE;
drop table if exists post_hasTag_tag CASCADE;
drop table if exists post_isLocatedIn_country CASCADE;
drop table if exists tag_hasType_tagclass CASCADE;
drop table if exists tagclass_isSubclassOf_tagclass CASCADE;
drop table if exists university_isLocatedIn_city CASCADE;
drop table if exists city CASCADE;
drop table if exists comment CASCADE; 
drop table if exists company CASCADE; 
drop table if exists continent CASCADE; 
drop table if exists country CASCADE; 
drop table if exists forum CASCADE; 
drop table if exists person CASCADE;
drop table if exists post CASCADE;
drop table if exists tag CASCADE;
drop table if exists tagclass CASCADE;
drop table if exists university CASCADE;
drop table if exists place_isPartOf_place;
drop table if exists person_workAt_organisation;
drop table if exists person_studyAt_organisation;
drop table if exists person_isLocatedIn_place;
drop table if exists post_isLocatedIn_place;
drop table if exists comment_isLocatedIn_place;
drop table if exists organisation_isLocatedIn_place;
drop table if exists place;
drop table if exists organisation;

create table place (
	id 	integer not null primary key,
	name 	varchar(40),
	url 	varchar(256),
	type 	varchar(40)
);

create table city (
	id 	integer not null primary key,
	name 	varchar(40),
	url 	varchar(256)
);

create table country (
	id 	integer not null primary key,
	name 	varchar(40),
	url 	varchar(256)
);

create table continent (
	id 	integer not null primary key,
	name 	varchar(40),
	url 	varchar(256)
);

create table place_isPartOf_place (
	place_id 	integer not null,
	other_place_id 	integer not null,
	primary key (place_id, other_place_id),
	foreign key(place_id) references place(id),
	foreign key(other_place_id) references place(id)
);

create table country_isPartOf_continent (
	country_id 	integer not null,
	other_continent_id 	integer not null,
	primary key (country_id, other_continent_id),
	foreign key(country_id) references country(id),
	foreign key(other_continent_id) references continent(id)
);

create table city_isPartOf_country (
	city_id 	integer not null,
	other_country_id 	integer not null,
	primary key (city_id, other_country_id),
	foreign key(city_id) references city(id),
	foreign key(other_country_id) references country(id)
);

create table organisation (
	id 	integer not null primary key,
	type 	varchar(40),
	name 	varchar(40),
	url 	varchar(256)
);

create table university (
	id 	integer not null primary key,
	type 	varchar(40),
	name 	varchar(40),
	url 	varchar(256)
);

create table company (
	id 	integer not null primary key,
	type 	varchar(40),
	name 	varchar(40),
	url 	varchar(256)
);


create table organisation_isLocatedIn_place (
	organisation_id integer not null,
	place_id 	integer not null,
	primary key (organisation_id, place_id),
	foreign key(organisation_id) references organisation(id),
	foreign key(place_id) references place(id)
);

create table university_isLocatedIn_city (
	university_id integer not null,
	city_id 	integer not null,
	primary key (university_id, city_id),
	foreign key(university_id) references university(id),
	foreign key(city_id) references city(id)
);

create table company_isLocatedIn_country (
	company_id integer not null,
	country_id 	integer not null,
	primary key (company_id, country_id),
	foreign key(company_id) references company(id),
	foreign key(country_id) references country(id)
);

create table tag (
	id 	integer not null primary key,
	name 	varchar(40),
	url 	varchar(256)
);

create table tagclass (
	id 	integer not null primary key,
	name 	varchar(40),
	url 	varchar(256)
);

create table tagclass_isSubclassOf_tagclass (
	tagclass_id 	integer not null,
	other_tagclass_id 	integer not null,
	primary key (tagclass_id, other_tagclass_id),
	foreign key(tagclass_id) references tagclass(id),
	foreign key(other_tagclass_id) references tagclass(id)
);

create table tag_hasType_tagclass (
	tag_id 	integer not null,
	tagclass_id 	integer not null,
	primary key (tag_id, tagclass_id),
	foreign key(tag_id) references tag(id),
	foreign key(tagclass_id) references tagclass(id)
);

create table comment (
	id 	integer not null primary key,
	creationDate TIMESTAMP, 
	locationIP varchar(15),
	browserUsed varchar(40),
	content varchar(500),
	length int
);

create table comment_hasTag_tag (
	comment_id integer not null,
	tag_id 	integer not null,
	primary key (comment_id, tag_id),
	foreign key(comment_id) references comment(id),
	foreign key(tag_id) references tag(id)
);

create table comment_isLocatedIn_country (
	comment_id integer not null,
	country_id 	integer not null,
	primary key (comment_id, country_id),
	foreign key(comment_id) references comment(id),
	foreign key(country_id) references country(id)
);

create table comment_isLocatedIn_place (
	comment_id integer not null,
	place_id 	integer not null,
	primary key (comment_id, place_id),
	foreign key(comment_id) references comment(id),
	foreign key(place_id) references place(id)
);

create table comment_replyOf_comment (
	comment_id integer not null,
	other_comment_id integer not null,
	primary key (comment_id, other_comment_id),
	foreign key(comment_id) references comment(id),
	foreign key(other_comment_id) references comment(id)
);

create table post (
	id integer not null primary key,
	imageFile varchar(100),
	creationDate TIMESTAMP, 
	locationIP varchar(15),
	browser varchar(50),
	language varchar(2),
	content varchar(500),
	length int
);

create table post_isLocatedIn_country (
	post_id integer not null,
	country_id integer not null,
	primary key (post_id, country_id),
	foreign key(post_id) references post(id),
	foreign key(country_id) references country(id)
);

create table post_isLocatedIn_place (
	post_id integer not null,
	place_id integer not null,
	primary key (post_id, place_id),
	foreign key(post_id) references post(id),
	foreign key(place_id) references place(id)
);

create table post_hasTag_tag (
	post_id integer not null,
	tag_id integer not null,
	primary key (post_id, tag_id),
	foreign key(post_id) references post(id),
	foreign key(tag_id) references tag(id)
);

create table comment_replyOf_post (
	comment_id	 integer not null,
	post_id 	integer not null,
	primary key (comment_id, post_id),
	foreign key(comment_id) references comment(id),
	foreign key(post_id) references post(id)
);

create table forum (
	id integer not null primary key,
	title varchar(100),
	creationDate TIMESTAMP
);

create table forum_hasTag_tag (
	forum_id integer not null,
	tag_id integer not null,
	primary key (forum_id, tag_id),
	foreign key(forum_id) references forum(id),
	foreign key(tag_id) references tag(id)
);

create table forum_containerOf_post (
	forum_id integer not null,
	post_id integer not null,
	primary key (forum_id, post_id),
	foreign key(forum_id) references forum(id),
	foreign key(post_id) references post(id)
);

create table person (
	id integer not null primary key,
	firstName varchar(100),
	lastName varchar(100),
	gender varchar(10),
	birthday date,
	creationDate TIMESTAMP, 
	locationIP varchar(15),
	browserUsed varchar(40)
);

create table post_hasCreator_person (
	post_id integer not null,
	person_id integer not null,
	primary key (post_id, person_id),
	foreign key(post_id) references post(id),
	foreign key(person_id) references person(id)
);

create table forum_hasModerator_person (
	forum_id integer not null,
	person_id integer not null,
	primary key (forum_id, person_id),
	foreign key(forum_id) references forum(id),
	foreign key(person_id) references person(id)
);

create table forum_hasMember_person (
	forum_id integer not null,
	person_id integer not null,
	joinDate TIMESTAMP,
	primary key (forum_id, person_id),
	foreign key(forum_id) references forum(id),
	foreign key(person_id) references person(id)
);


create table comment_hasCreator_person  (
	comment_id integer not null,
	person_id integer not null,
	primary key (comment_id, person_id),
	foreign key(comment_id) references comment(id),
	foreign key(person_id) references person(id)
);

create table person_knows_person (
	person_id integer not null,
	other_person_id integer not null,
	creationDate TIMESTAMP,
	primary key (person_id, other_person_id),
	foreign key(person_id) references person(id),
	foreign key(other_person_id) references person(id)
);

create table person_isLocatedIn_city (
	person_id integer not null,
	city_id integer not null,
	primary key (person_id, city_id),
	foreign key(person_id) references person(id),
	foreign key(city_id) references city(id)
);

create table person_isLocatedIn_country (
	person_id integer not null,
	country_id integer not null,
	primary key (person_id, country_id),
	foreign key(person_id) references person(id),
	foreign key(country_id) references country(id)
);

create table person_isLocatedIn_continent (
	person_id integer not null,
	continent_id integer not null,
	primary key (person_id, continent_id),
	foreign key(person_id) references person(id),
	foreign key(continent_id) references continent(id)
);

create table person_isLocatedIn_place (
	person_id integer not null,
	place_id integer not null,
	primary key (person_id, place_id),
	foreign key(person_id) references person(id),
	foreign key(place_id) references place(id)
);


create table person_hasInterest_tag (
	person_id integer not null,
	tag_id integer not null,
	primary key (person_id, tag_id),
	foreign key(person_id) references person(id),
	foreign key(tag_id) references tag(id)
);

create table person_email_emailaddress (
	person_id integer not null,
	emailaddress varchar(100),
	primary key (person_id, emailaddress)
);

create table person_workAt_company (
	person_id integer not null,
	company_id integer not null,
	workFrom varchar(4),
	primary key (person_id, company_id),
	foreign key(person_id) references person(id),
	foreign key(company_id) references company(id)
);

create table person_studyAt_university (
	person_id integer not null,
	university_id integer not null,
	workFrom varchar(4),
	primary key (person_id, university_id),
	foreign key(person_id) references person(id),
	foreign key(university_id) references university(id)
);

create table person_workAt_organisation (
	person_id integer not null,
	organisation_id integer not null,
	workFrom varchar(4),
	primary key (person_id, organisation_id),
	foreign key(person_id) references person(id),
	foreign key(organisation_id) references organisation(id)
);

create table person_studyAt_organisation (
	person_id integer not null,
	organisation_id integer not null,
	workFrom varchar(4),
	primary key (person_id, organisation_id),
	foreign key(person_id) references person(id),
	foreign key(organisation_id) references organisation(id)
);

create table person_speaks_language (
	person_id integer not null,
	language varchar(2),
	primary key (person_id, language)
);

create table person_likes_post (
	person_id integer not null,
	post_id integer not null,
	creationDate TIMESTAMP,
	primary key (person_id, post_id),
	foreign key(person_id) references person(id),
	foreign key(post_id) references post(id)
);

create table person_likes_comment (
	person_id integer not null,
	comment_id integer not null,
	creationDate TIMESTAMP,
	primary key (person_id, comment_id),
	foreign key(person_id) references person(id),
	foreign key(comment_id) references comment(id)
);

copy place from local '/data/ldbc_complete/completeLDBC/3G/social_network/place_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy place_isPartOf_place from local '/data/ldbc_complete/completeLDBC/3G/social_network/place_isPartOf_place_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy organisation from local '/data/ldbc_complete/completeLDBC/3G/social_network/organisation_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy organisation_isLocatedIn_place from local '/data/ldbc_complete/completeLDBC/3G/social_network/organisation_isLocatedIn_place_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy city from local '/data/ldbc_complete/completeLDBC/3G/social_network/city_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy country from local '/data/ldbc_complete/completeLDBC/3G/social_network/country_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy continent from local '/data/ldbc_complete/completeLDBC/3G/social_network/continent_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy company from local '/data/ldbc_complete/completeLDBC/3G/social_network/company_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy university from local '/data/ldbc_complete/completeLDBC/3G/social_network/university_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy tag from local '/data/ldbc_complete/completeLDBC/3G/social_network/tag_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy tagclass from local '/data/ldbc_complete/completeLDBC/3G/social_network/tagclass_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy tagclass_isSubclassOf_tagclass from local '/data/ldbc_complete/completeLDBC/3G/social_network/tagclass_isSubclassOf_tagclass_0_0.csv' with DELIMITER '|'ABORT ON ERROR SKIP 1;
copy tag_hasType_tagclass from local '/data/ldbc_complete/completeLDBC/3G/social_network/tag_hasType_tagclass_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy comment from local '/data/ldbc_complete/completeLDBC/3G/social_network/comment_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy comment_hasCreator_person from local '/data/ldbc_complete/completeLDBC/3G/social_network/comment_hasCreator_person_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy comment_hasTag_tag from local '/data/ldbc_complete/completeLDBC/3G/social_network/comment_hasTag_tag_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy comment_isLocatedIn_place from local '/data/ldbc_complete/completeLDBC/3G/social_network/comment_isLocatedIn_place_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy comment_replyOf_comment from local '/data/ldbc_complete/completeLDBC/3G/social_network/comment_replyOf_comment_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy post from local '/data/ldbc_complete/completeLDBC/3G/social_network/post_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy post_isLocatedIn_place from local '/data/ldbc_complete/completeLDBC/3G/social_network/post_isLocatedIn_place_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy post_hasTag_tag from local '/data/ldbc_complete/completeLDBC/3G/social_network/post_hasTag_tag_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy post_hasCreator_person from local '/data/ldbc_complete/completeLDBC/3G/social_network/post_hasCreator_person_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy comment_replyOf_post from local '/data/ldbc_complete/completeLDBC/3G/social_network/comment_replyOf_post_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy forum from local '/data/ldbc_complete/completeLDBC/3G/social_network/forum_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy forum_hasTag_tag from local '/data/ldbc_complete/completeLDBC/3G/social_network/forum_hasTag_tag_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy forum_hasModerator_person from local '/data/ldbc_complete/completeLDBC/3G/social_network/forum_hasModerator_person_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy forum_hasMember_person from local '/data/ldbc_complete/completeLDBC/3G/social_network/forum_hasMember_person_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy forum_containerOf_post from local '/data/ldbc_complete/completeLDBC/3G/social_network/forum_containerOf_post_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy person from local '/data/ldbc_complete/completeLDBC/3G/social_network/person_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy person_knows_person from local '/data/ldbc_complete/completeLDBC/3G/social_network/person_knows_person_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy person_isLocatedIn_place from local '/data/ldbc_complete/completeLDBC/3G/social_network/person_isLocatedIn_place_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy person_hasInterest_tag from local '/data/ldbc_complete/completeLDBC/3G/social_network/person_hasInterest_tag_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy person_email_emailaddress from local '/data/ldbc_complete/completeLDBC/3G/social_network/person_email_emailaddress_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy person_workAt_organisation from local '/data/ldbc_complete/completeLDBC/3G/social_network/person_workAt_organisation_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy person_studyAt_organisation from local '/data/ldbc_complete/completeLDBC/3G/social_network/person_studyAt_organisation_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy person_speaks_language from local '/data/ldbc_complete/completeLDBC/3G/social_network/person_speaks_language_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy person_likes_post from local '/data/ldbc_complete/completeLDBC/3G/social_network/person_likes_post_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;
copy person_likes_comment from local '/data/ldbc_complete/completeLDBC/3G/social_network/person_likes_comment_0_0.csv' with DELIMITER '|' ABORT ON ERROR SKIP 1;

/* populate the tables that aren't directly from lnbc */
insert into person_studyAt_university (
select person_studyAt_organisation.* from person_studyAt_organisation, person, organisation AS uni where person_studyAt_organisation.person_id = person.id and person_studyAt_organisation.organisation_id = uni.id and uni.type = 'university');

/* Note, no-one works at the university */
insert into person_workAt_company (
select person_workAt_organisation.* from person_workAt_organisation, person, organisation AS company where person_workAt_organisation.person_id = person.id and person_workAt_organisation.organisation_id = company.id and company.type = 'company');

/* People are only located down the CITY in the data */
insert into person_isLocatedIn_city (
select person_isLocatedIn_place.* from person_isLocatedIn_place, person, place AS city where person_isLocatedIn_place.person_id = person.id and person_isLocatedIn_place.place_id = city.id and city.type = 'city');

/* Posts are only located down the COUNTRY in the data */
insert into post_isLocatedIn_country (
select post_isLocatedIn_place.* from post_isLocatedIn_place, post, place AS country where post_isLocatedIn_place.post_id = post.id and post_isLocatedIn_place.place_id = country.id and country.type = 'country');

/* Comments are only located down the COUNTRY in the data */
insert into comment_isLocatedIn_country (
select comment_isLocatedIn_place.* from comment_isLocatedIn_place, comment, place AS country where comment_isLocatedIn_place.comment_id = comment.id and comment_isLocatedIn_place.place_id = country.id and country.type = 'country');

/* Universities are only located down to CITY in the data */
insert into university_isLocatedIn_city (select organisation_isLocatedIn_place.* from organisation_isLocatedIn_place, organisation AS uni, place AS city where organisation_isLocatedIn_place.organisation_id = uni.id and organisation_isLocatedIn_place.place_id = city.id and uni.type = 'university' and city.type = 'city');

/* Companies are only located down to COUNTRY in the data */
insert into company_isLocatedIn_country(select organisation_isLocatedIn_place.* from organisation_isLocatedIn_place, organisation AS company, place AS country where organisation_isLocatedIn_place.organisation_id = company.id and organisation_isLocatedIn_place.place_id = country.id and company.type = 'company' and country.type = 'country');

insert into country_isPartOf_continent (
select place_isPartOf_place.* from place_isPartOf_place, place AS country, place AS continent where place_isPartOf_place.place_id = country.id and place_isPartOf_place.other_place_id = continent.id and country.type = 'country' and continent.type = 'continent');

insert into city_isPartOf_country (
select place_isPartOf_place.* from place_isPartOf_place, place AS city, place AS country where place_isPartOf_place.place_id = city.id and place_isPartOf_place.other_place_id = country.id and country.type = 'country' and city.type = 'city');

\echo Dropping tables used for ingesting.
drop table place_isPartOf_place;
drop table person_workAt_organisation;
drop table person_studyAt_organisation;
drop table person_isLocatedIn_place;
drop table post_isLocatedIn_place;
drop table comment_isLocatedIn_place;
drop table organisation_isLocatedIn_place;
drop table place;
drop table organisation;

\echo Running statistics gathering
SELECT ANALYZE_STATISTICS (''); 

