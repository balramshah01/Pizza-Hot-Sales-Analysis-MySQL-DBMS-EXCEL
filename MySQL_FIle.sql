-- Query file 1
create database Pizza_Hot;

-- Query file 2
-- Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS total_order
FROM
    orders;
    
    -- Query File 3
    -- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(sum(order_details.quantity * pizzas.price),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id
    
    -- Query File 4
    -- Identify the highest-priced pizza.

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 3;

-- Query File 5
-- Identify the most common pizza size ordered.

SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_size
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_size DESC
LIMIT 4;

-- Query File 6
-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS order_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY order_quantity DESC
LIMIT 5;

-- Query File 7
-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    SUM(order_details.quantity) AS total_quantity,
    pizza_types.category AS pizza_category
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_category
ORDER BY total_quantity DESC;


-- Query File 8
-- Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time), COUNT(order_id) as count
FROM
    orders
GROUP BY HOUR(order_time) order by count;


-- Query File 9
-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) from pizza_types
group by category;

-- Query File 10
-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(pizza_ordered), 0) AS average_pizza_order
FROM
    (SELECT 
        orders.order_date,
            SUM(order_details.quantity) AS pizza_ordered
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;
    
    -- Query File 11
    -- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name,
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

-- Query File 12
-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS revenue
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS total_revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category
ORDER BY total_revenue DESC;


-- Query File 13
-- Analyze the cumulative revenue generated over time.

select order_date,
sum(revenue) over(order by order_date) as cum_revenue
from
(select orders.order_date,
sum(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on order_details.order_id = orders.order_id
group by orders.order_date) as daily_sales;


-- Query File 14
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category, name, revenue 

from
(select category, name, revenue,
rank() over (partition by category order by revenue) as cr

from
(select pizza_types.category, pizza_types.name,
sum(order_details.quantity * pizzas.price) as revenue

from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id

group by pizza_types.category, pizza_types.name) as cat_name_revenue) as name_revenue 
where cr <=3 ;





