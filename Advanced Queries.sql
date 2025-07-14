-- Advanced queries

-- 1.calculate the moving average of orders values for each customer over their order history.

select customer_id , order_purchase_timestamp,payment,
avg(payment) over(partition by customer_id order by order_purchase_timestamp
rows between 2 preceding and current row) as mov_avg
from 
(select orders.customer_id, orders.order_purchase_timestamp, 
(payments.payment_value)as payment
from payments join orders
on payments.order_id = orders.order_id) as a;

# 2.calculate the cumulative sales per month for each year.

select years,months,payment,sum(payment)
over(order by years,months) as cumulative_sales
from
(select year(orders.order_purchase_timestamp) as years,
monthname(orders.order_purchase_timestamp) as months,
round(sum(payments.payment_value),2) payment from orders join payments
on orders.order_id = payments.order_id
group by years, months order by years, months desc) as a;

-- 3.calculate year-over-year growth rate of total sales

with a as 
(select year(orders.order_purchase_timestamp) as years,
round(sum(payments.payment_value),2) payment from orders join payments
on orders.order_id = payments.order_id
group by years order by years) 

select years, 
(payment - lag(payment ,1) over(order by years))/lag(payment ,1) over(order by years)*100
from a;

-- 4. Calculate the retension rate of customers ,
-- defined as a percentage of customers who makes another purchase within 6 months of their 1st purchase.

with a as(select customers.customer_id , min(orders.order_purchase_timestamp) as first_order
from customers join orders
on customers.customer_id = orders.customer_id
group by customers.customer_id),

b as (select a.customer_id, count(distinct orders.order_purchase_timestamp) as next_order
from a join orders
on a.customer_id = orders.customer_id
and orders.order_purchase_timestamp>first_order
and orders.order_purchase_timestamp < date_add(first_order ,interval 6 month)
group by a.customer_id)

select 100 * (count(distinct a.customer_id)/count(distinct b.customer_id))
from a left join b
on a.customer_id = b.customer_id ;

-- 5. Identify the top 3 customers who spends most money in each year.

select years,customer_id,payment,d_rank
from
(select year(orders.order_purchase_timestamp) as years,
orders.customer_id ,
sum(payments.payment_value) as payment,
dense_rank() over(partition by year(orders.order_purchase_timestamp) order by sum(payments.payment_value) desc ) d_rank 
from orders join payments
on orders.order_id = payments.order_id 
group by orders.customer_id ,years) as a
where d_rank <=3;



























































