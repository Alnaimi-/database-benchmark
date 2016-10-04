\o /dev/null

-- Manual created using the cypher2sql output as the starting point. 


WITH SUB_2043610698 AS (
SELECT friend.id,'Person('||friend.id||')' AS friend,friend.id AS friendId,friend.firstName AS friendFirstName,friend.lastName AS friendLastName FROM person AS person JOIN person_knows_person ON (person_knows_person.person_id = person.id)  JOIN Person AS friend ON (friend.id = person_knows_person.other_person_id) WHERE person.id = 2199023259437 AND person.id != friend.id
), SUB_1296752076 AS (
SELECT friend.id,'Person('||friend.id||')' AS friend,friend.id AS friendId,friendFirstName,friendLastName,company.name AS companyName, worksAt.workFrom AS workFrom FROM SUB_2043610698 AS friend JOIN person_workAt_company AS worksAt ON (worksAt.person_id = friend.id)  JOIN Company AS company ON (company.id = worksAt.company_id)  JOIN company_isLocatedIn_country ON (company_isLocatedIn_country.company_id = company.id)  JOIN Country AS c_$1 ON (c_$1.id = company_isLocatedIn_country.country_id) WHERE worksAt.workFrom < '2016-7-7' and c_$1.url = 'http://dbpedia.org/resource/France'
), SUB_1166431844 AS (
SELECT friend.id,'Person('||friend.id||')' AS friend,friend.id AS friendId,friend.firstName AS friendFirstName,friend.lastName AS friendLastName FROM person AS person JOIN person_knows_person ON (person_knows_person.person_id = person.id)  JOIN Person AS p_$1 ON (p_$1.id = person_knows_person.other_person_id)  JOIN person_knows_person AS person_knows_person_$1 ON (person_knows_person_$1.person_id = p_$1.id)  JOIN Person AS friend ON (friend.id = person_knows_person_$1.other_person_id) WHERE person.id = 2199023259437 AND person.id != friend.id
), SUB_1296752075 AS (
SELECT friend.id,'Person('||friend.id||')' AS friend,friend.id AS friendId,friendFirstName,friendLastName,company.name AS companyName, worksAt.workFrom AS workFrom FROM SUB_1166431844 AS friend JOIN person_workAt_company AS worksAt ON (worksAt.person_id = friend.id)  JOIN Company AS company ON (company.id = worksAt.company_id)  JOIN company_isLocatedIn_country ON (company_isLocatedIn_country.company_id = company.id)  JOIN Country AS c_$1 ON (c_$1.id = company_isLocatedIn_country.country_id) WHERE worksAt.workFrom < '2016-7-7' and c_$1.url = 'http://dbpedia.org/resource/France'
)
SELECT /*+label(query11)*/ * FROM (
SELECT workFrom AS workFromYear,SUB_1296752076.id AS friendId,SUB_1296752076.friendFirstName,SUB_1296752076.friendLastName,SUB_1296752076.companyName FROM SUB_1296752076
 union 
SELECT workFrom AS workFromYear,SUB_1296752075.id AS friendId,SUB_1296752075.friendFirstName,SUB_1296752075.friendLastName,SUB_1296752075.companyName FROM SUB_1296752075
) AS unionAlias  ORDER BY workFromYear, friendId, companyName DESC LIMIT 100;

