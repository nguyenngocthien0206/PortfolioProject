-- Total sales by products
select		p.product_id,
			p.product_name,
            sum(oi.order_item_subtotal) as total_sales
from 		orders o
join 		order_items oi on oi.order_item_order_id = o.order_id
join 		products p on p.product_id = oi.order_item_product_id
group by	p.product_id, p.product_name
order by	sum(oi.order_item_subtotal) desc;

-- Total sales by categories
select		c.category_id,
			c.category_name,
            sum(oi.order_item_subtotal) as total_sales
from 		orders o
join 		order_items oi on oi.order_item_order_id = o.order_id
join 		products p on p.product_id = oi.order_item_product_id
join		categories c on c.category_id = p.product_category_id
group by	c.category_id, c.category_name
order by	sum(oi.order_item_subtotal) desc;

-- Total orders by year
select year(order_date), count(*)
from orders
group by year(order_date)
order by year(order_date);
-- 30662 orders in 2013 (second half) and 38221 orders in 2014 (first half)

-- Total sales by years
select		year(o.order_date) as year,
			month(o.order_date) as month,
            sum(oi.order_item_subtotal) as total_sales
from		orders o
join		order_items oi on oi.order_item_order_id = o.order_id
group by	year(o.order_date), month(o.order_date)
order by	year(o.order_date), month(o.order_date);

-- Number of customers in each states
select 		customer_state,
			count(customer_id) as num_of_cust
from		customers
group by	customer_state
order by customer_state;

-- Total sales by states
select		c.customer_state,
			sum(oi.order_item_subtotal) as total_sales
from 		orders o
join 		order_items oi on oi.order_item_order_id = o.order_id
join		customers c on c.customer_id = o.order_customer_id
group by	c.customer_state
order by	sum(oi.order_item_subtotal) desc;