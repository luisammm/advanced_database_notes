-- Try it 1

select
b.*,
count(*) over(partition by shape) as bricks_per_shape,
median(weight) over(partition by shape) as median_weight_per_shape
from bricks b
order by shape , weight , brick_id;


-- Try it 2

select b.brick_id, b.weight,
round(avg(weight) over(order by brick_id),2) running_average_weight
from bricks b
order by brick_id ;


-- Try it 3

select
b.*,
min(colour) over(
order by brick_id
rows between 2 preceding and 1 preceding
) as first_colour_two_prev,
count(*) over(
order by weight
range between current row and 1 following
) count_values_this_and_next
from bricks b
order by weight ;


-- Try it 4

with totals as
(
select
b.*,
sum(weight) over(partition by shape) weight_per_shape,
sum(weight) over(
order by brick_id, weight
rows between unbounded preceding and current row
) running_weight_by_id
from bricks b
)

select *
from totals
where weight_per_shape > 4
and running_weight_by_id > 4
order by brick_id ;


-- Data Lemur Challenge

with ranked as (
select
e.name,
e.salary,
e.department_id,
dense_rank() over(
partition by e.department_id
order by salary desc
) salary_rank
from employee e
)

select
d.department_name,
r.name,
r.salary
from ranked r
join department d
on d.department_id = r.department_id
where salary_rank <= 3
order by
d.department_name,
r.salary desc,
r.name;