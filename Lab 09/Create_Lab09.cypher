CREATE (:Customer {c_id: 1, name: 'Dihan', phone_no: '018243245234', age: 22, gender: 'M'})
CREATE (:Customer {c_id: 2, name: 'Nafisa', phone_no: '015523434534', age: 21, gender: 'F'})
CREATE (:Customer {c_id: 3, name: 'Naz', phone_no: '01567889344', age: 22, gender: 'M'})
CREATE (:Customer {c_id: 7, name: 'N', phone_no: '99032432523', age: 32, gender: 'M'})

CREATE (:Genre {name: 'Action'})
CREATE (:Genre {name: 'Thriller'})
CREATE (:Genre {name: 'Romance'})

CREATE (:Author {name: 'Stephenie Meyer', country: 'USA', date_of_birth: '5-10-1982'})
CREATE (:Author {name: 'Aron Blake', country: 'USA', date_of_birth: '12-10-1963'})
CREATE (:Author {name: 'Sian Ashsad', country: 'AFR', date_of_birth: '7-31-2001'})

CREATE (:Book {title: 'Twilight', published: 1998, price: 20.00})
CREATE (:Book {title: 'Twilight : New Moon', published: 2000, price: 25.00})
CREATE (:Book {title: 'Twilight : Eclipse', published: 2001, price: 26.00})
CREATE (:Book {title: 'Twilight : Breaking Dawn Part I', published: 2002, price: 30.00})
CREATE (:Book {title: 'Twilight : Breaking Dawn Part II', published: 2003, price: 30.00})
CREATE (:Book {title: 'Twilight : Eclipse', published: 2001, price: 26.00})
CREATE (:Book {title: 'The Wolf of Wall Street', published: 1978,price: 17.00})
CREATE (:Book {title: 'Iron Shell', published: 2020, price: 5.00})

MATCH (c:Customer),(g:Genre),(a:Author),(b:Book)
WHERE c.c_id = 1 AND g.name = 'Romance' AND a.name = 'Stephenie Meyer' AND b.title = 'Twilight'
CREATE (c)-[:PURCHASED {purchasing_date: '2023-04-04', amount: 20.00}]->(b)
CREATE (c)-[:RATED {rating: 4}]->(a)
CREATE (c)-[:RATING {rating: 5}]->(b)
CREATE (b)-[:BELONGS_TO]->(g)
CREATE (b)-[:WRITTEN_BY]->(a)

MATCH (g:Genre),(a:Author),(b:Book)
WHERE g.name = 'Romance' AND a.name = 'Stephenie Meyer' AND b.title = 'Twilight : New Moon'
CREATE (b)-[:BELONGS_TO]->(g)
CREATE (b)-[:WRITTEN_BY]->(a)

MATCH (g:Genre),(a:Author),(b:Book)
WHERE g.name = 'Romance' AND a.name = 'Stephenie Meyer' AND b.title = 'Twilight : Breaking Dawn Part I'
CREATE (b)-[:BELONGS_TO]->(g)
CREATE (b)-[:WRITTEN_BY]->(a)

MATCH (g:Genre),(a:Author),(b:Book)
WHERE g.name = 'Romance' AND a.name = 'Stephenie Meyer' AND b.title = 'Twilight : Breaking Dawn Part II'
CREATE (b)-[:BELONGS_TO]->(g)
CREATE (b)-[:WRITTEN_BY]->(a)

MATCH (g:Genre),(a:Author),(b:Book)
WHERE g.name = 'Thriller' AND a.name = 'Aron Blake' AND b.title = 'The Wolf of Wall Street'
CREATE (b)-[:BELONGS_TO]->(g)
CREATE (b)-[:WRITTEN_BY]->(a)

MATCH (g:Genre),(a:Author),(b:Book)
WHERE g.name = 'Thriller' AND a.name = 'Sian Ashsad' AND b.title = 'Iron Shell'
CREATE (b)-[:BELONGS_TO]->(g)
CREATE (b)-[:WRITTEN_BY]->(a)

MATCH (g:Genre),(b:Book)
WHERE g.name = 'Thriller' AND b.title = 'Twilight : New Moon'
CREATE (b)-[:BELONGS_TO]->(g)


MATCH (g:Genre),(b:Book)
WHERE g.name = 'Action' AND b.title = 'The Wolf of Wall Street'
CREATE (b)-[:BELONGS_TO]->(g)


MATCH (g:Genre),(b:Book)
WHERE g.name = 'Thriller' AND b.title = 'Twilight : Breaking Dawn Part I'
CREATE (b)-[:BELONGS_TO]->(g)


MATCH (g:Genre),(b:Book)
WHERE g.name = 'Thriller' AND b.title = 'Twilight : Breaking Dawn Part II'
CREATE (b)-[:BELONGS_TO]->(g)


MATCH (b1:Book), (b2:Book)
WHERE b1.title = 'Twilight' AND b2.title = 'Twilight : New Moon'
CREATE (b2)-[:VOLUME_OF]->(b1)

MATCH (b1:Book), (b2:Book)
WHERE b1.title = 'Twilight' AND b2.title = 'Twilight : Eclipse'
CREATE (b2)-[:VOLUME_OF]->(b1)

MATCH (b1:Book), (b2:Book)
WHERE b1.title = 'Twilight' AND b2.title = 'Twilight : Breaking Dawn Part I'
CREATE (b2)-[:VOLUME_OF]->(b1)

MATCH (b1:Book), (b2:Book)
WHERE b1.title = 'Twilight' AND b2.title = 'Twilight : Breaking Dawn Part II'
CREATE (b2)-[:VOLUME_OF]->(b1)

MATCH (c:Customer), (b:Book)
WHERE c.c_id = 1 AND b.title = 'Twilight : New Moon'
CREATE (c)-[:PURCHASED {purchasing_date: '2023-04-02', amount: 20.00}]->(b)
CREATE (c)-[:RATING {rating: 5}]->(b)

MATCH (c:Customer), (b:Book) , (a: Author)
WHERE c.c_id = 2 AND b.title = 'Twilight : Eclipse' AND a.name = 'Stephenie Meyer'
CREATE (c)-[:PURCHASED {purchasing_date: '2023-04-04', amount: 25.00}]->(b)
CREATE (c)-[:RATED {rating: 3}]->(a)
CREATE (c)-[:RATING {rating: 3}]->(b)

MATCH (c:Customer), (b:Book) , (a: Author)
WHERE c.c_id = 3 AND b.title = 'Twilight : Breaking Dawn Part I' AND a.name = 'Stephenie Meyer'
CREATE (c)-[:PURCHASED {purchasing_date: '2023-03-04', amount: 30.00}]->(b)
CREATE (c)-[:RATED {rating: 4}]->(a)
CREATE (c)-[:RATING {rating: 4}]->(b)

MATCH (c:Customer), (b:Book), (a: Author)
WHERE c.c_id = 7 AND b.title = 'Twilight : Breaking Dawn Part II' AND a.name = 'Stephenie Meyer'
CREATE (c)-[:PURCHASED {purchasing_date: '2023-02-04', amount: 30.00}]->(b)
CREATE (c)-[:RATED {rating: 4}]->(a)
CREATE (c)-[:RATING {rating: 3}]->(b)

MATCH (c:Customer), (b:Book), (a: Author)
WHERE c.c_id = 7 AND b.title = 'Iron Shell' AND a.name = 'Sian Ashsad'
CREATE (c)-[:PURCHASED {purchasing_date: '2023-01-04', amount: 30.00}]->(b)
CREATE (c)-[:RATED {rating: 4}]->(a)
CREATE (c)-[:RATING {rating: 3}]->(b)

MATCH (c:Customer), (b:Book), (a: Author) 
WHERE c.c_id = 7 AND b.title = 'The Wolf of Wall Street' AND a.name = 'Aron Blake'
CREATE (c)-[:PURCHASED {purchasing_date: '2023-02-14', amount: 15.00}]->(b)
CREATE (c)-[:RATED {rating: 7}]->(a)
CREATE (c)-[:RATING {rating: 3}]->(b)