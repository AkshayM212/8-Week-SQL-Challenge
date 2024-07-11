1. How many pizzas were ordered?

select count(order_id) as no_of_orders
from customer_orders_temp

2. How many unique customer orders were made?

select count(distinct order_id)
from customer_orders_temp
	
3. How many successful orders were delivered by each runner?

select runner_id, count(runner_id)
from runner_orders_temp
where pickup_time is not null
group by runner_id
order by runner_id

4. How many of each type of pizza was delivered?

select p.pizza_name, count(1)
from customer_orders_temp c
join runner_orders_temp r on c.order_id = r.order_id
join pizza_names p on p.pizza_id = c.pizza_id
where pickup_time is not null
group by p.pizza_name
	
5. How many Vegetarian and Meatlovers were ordered by each customer?

select customer_id, pizza_name, count(pizza_name)
from customer_orders_temp c
join runner_orders_temp r on c.order_id = r.order_id
join pizza_names p on p.pizza_id = c.pizza_id
group by customer_id, pizza_name
order by customer_id
	
6. What was the maximum number of pizzas delivered in a single order?

with cte as
			(select c.order_id , count(1) as no_of_pizzas,
				rank() over(order by count(1) desc)
			from customer_orders_temp c
			join runner_orders_temp r on r.order_id = c.order_id
			group by c.order_id)
select no_of_pizzas
from cte
where rank = 1

	
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select customer_id, count(pizza_id) total_pizza_delivered,
	sum(case
		when c.exclusions <>  '' or c.extras <> ''
		then 1 else 0
	end) as change,
	sum(case
		when c.exclusions = '' and c.extras = ''
		then 1 else 0
	end) as No_Change
from customer_orders_temp c
join runner_orders_temp r on r.order_id = c.order_id
where pickup_time is not null
group by customer_id

8. How many pizzas were delivered that had both exclusions and extras?

select count(c.order_id)
from customer_orders_temp c
join runner_orders_temp r on r.order_id = c.order_id
where exclusions <>  '' and extras <>  '' and pickup_time is not null
	
9. What was the total volume of pizzas ordered for each hour of the day?

select extract(hour from order_time) as hour_of_day, count(order_id) as no_of_pizzas
from customer_orders_temp
group by hour_of_day
order by hour_of_day

10. What was the volume of orders for each day of the week?

select to_char(order_time,'day') as day_of_week, count(order_id) as no_of_orders
from customer_orders_temp
group by day_of_week
