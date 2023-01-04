-->a<--

select f_name, total(c_id) as TotalCustomers
from customer_franchise
group by f_name;

-->b<--

select cuisine_id ,avg(rating) as AverageRating
from rating
group by cuisine_id;

-->c<--

select cuisine_id as Item_ID
from(select cuisine_id, total(order_id)
    from order
    group by cuisine_id
    order by DESC)
where ROWNUM <=5;


-->d<--

-- select c.c_name, COUNT(m.f_name) as count
-- from prefered_cuisine p, menu m, customer c
-- where p.c_id = c.c_id AND p.cuisine_id = m.cuisine_id

select c.c_name, a.count
from(select c.c_name, COUNT(m.f_name) as count
    from prefered_cuisine p, menu m, customer c
    where p.c_id = c.c_id AND p.cuisine_id = m.cuisine_id
    group by c.c_name
    ) a
where a.count>=2;


-->e<--

select c_id, c_name
from customer

MINUS

select C.c_id, C.c_name
from customer C, order O
where C.c_id = O.c_id;