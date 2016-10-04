MATCH (person1:Person {id:13194139534222}), (person2:Person {id:15393162799671})
OPTIONAL MATCH path = shortestPath((person1)-[:KNOWS]-(person2))
RETURN CASE path IS NULL
WHEN true THEN -1
ELSE length(path)
END AS pathLength
;
