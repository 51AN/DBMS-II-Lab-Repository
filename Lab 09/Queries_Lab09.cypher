-->2<--

--a
MATCH (c:Customer)-[p:PURCHASED]->(b:Book)
RETURN b.title, SUM(p.amount) AS revenue
ORDER BY revenue DESC

--b
MATCH (c:Customer)-[r:RATING]->(b:Book)-[:BELONGS_TO]->(g:Genre)
RETURN g.name, AVG(r.rating) AS avg_rating
ORDER BY avg_rating DESC

--c
MATCH (c:Customer {name: 'N'})-[:PURCHASED]->(b:Book)
WHERE b.purchasing_date >= '2023-01-01' AND b.purchasing_date <= '2023-04-09'
RETURN b.title
ORDER BY b.purchasing_date DESC

--d
MATCH (c:Customer)-[:PURCHASED]->(b:Book)
WITH c, count(b) AS num_books
RETURN c.name
ORDER BY num_books DESC
LIMIT 1

--e
MATCH (b:Book)<-[:PURCHASED]-(c:Customer)
RETURN b.title, COUNT(c) AS purchases
ORDER BY purchases DESC


--f
MATCH (c:Customer)-[pr : PURCHASED|RATING]->(b:Book)
WHERE b.title = 'Twilight : New Moon'
RETURN c.name, pr.rating, pr.purchasing_date

--g
MATCH (c:Customer)-[:PURCHASED]->(b:Book)-[:WRITTEN_BY]->(a:Author)
WHERE a.name = 'Stephenie Meyer'
RETURN DISTINCT c.name

--h
CALL algo.apriori(
  'MATCH (c:Customer)-[:PURCHASED]->(b:Book) RETURN c.c_id as customer, collect(b.title) as books',
  'WITH minSupport=0.01, minConfidence=0.5
   RETURN *
   ORDER BY support DESC',
  {graph: 'cypher', write:true, writeProperty:'rules'}
)
