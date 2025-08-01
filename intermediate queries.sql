-- Intermediate queries

-- 1.calculate the number of orders per month in 2018

select monthname(order_purchase_timestamp) as month ,count(order_id)
from orders
where year(order_purchase_timestamp) = 2018
group by month;

#2 find the average number of products per order, grouped by customer city.

with count_per_order as
(select orders.customer_id ,orders.order_id, count(order_items.order_id) as oc
from orders join order_items
on order_items.order_id = orders.order_id
group by orders.customer_id ,orders.order_id)

select customers.customer_city, round(avg(count_per_order.oc),2) as average_orders
from customers join count_per_order 
on customers.customer_id = count_per_order.customer_id
group by customers.customer_city;

-- 3.calculate the percentage of total revenue contribution by each product category.

select (products.product_category) category,
round((sum(payments.payment_value)/(select sum(payment_value) from payments))*100,2) as total_percentage_revenue 
from products join order_items
on products.product_id = order_items.product_id
join payments
on payments.order_id = order_items.order_id
group by category
order by total_percentage_revenue desc;

-- isko hi divide karna h for percentage of total revenue
select sum(payment_value) from payments; 

-- 4.identify the correlation between product price and the number of times a product has been purchased

select (products.product_category) category,
count(order_items.product_id) as count,
avg(order_items.price) as average_price
from products join order_items
on products.product_id = order_items.product_id
group by category;

# calculate the total revenue generated by each seller and rank them by revenue

select *,dense_rank() over(order by total_revenue) 
from
(select order_items.seller_id ,sum(payments.payment_value) as total_revenue
from order_items join payments
on payments.order_id = order_items.order_id
group by  order_items.seller_id ) as a;









































