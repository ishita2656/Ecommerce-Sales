-- Basic Queries
-- 1. List all unique cities where customers are located.

select distinct customer_city from customers;

-- 2. Count the number of orders placed in 2017.

select count(order_id) from orders where order_purchase_timestamp = 2017;

-- 3. Find the total sales per category.

select (products.product_category) as category ,round(sum(payments.payment_value),2)as total_sales
from products join order_items 
on products.product_id = order_items.product_id
join payments 
on payments.order_id = order_items.order_id
group by category;

-- 4. Calculate the percentage of orders that were paid in installments.

select sum(case when payment_installments >=1 then 1 else 0 end)/count(*)*100 
as percentage_of_orders_in_installment from payments;


-- 5. Count the number of customers from each state. 

select (customers.customer_state)as state, count(customer_id) 
from customers
group by state;