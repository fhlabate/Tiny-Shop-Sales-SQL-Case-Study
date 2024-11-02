-- 1)¿Qué producto tiene el precio más alto? Devuelva una sola fila
SELECT * 
FROM products_tiny
ORDER BY price DESC
LIMIT 1;
#Product M = 70

-- 2)¿Qué cliente ha realizado más pedidos?
SELECT *
FROM customers;
SELECT c.first_name, c.last_name, o.customer_id, count(o.order_id) AS "orders"
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY customer_id
ORDER BY orders DESC;
#Johm Doe, Jane Smith, Bob Johnson: 2 Pedidos cada uno.

-- 3)¿Cuál es el ingreso total por producto?
SELECT oi.product_id, pt.product_name, sum(oi.quantity) AS "sold", pt.price, sum(pt.price*oi.quantity) AS "income"
FROM order_items oi
JOIN products_tiny pt
ON oi.product_id = pt.product_id
GROUP BY oi.product_id;

-- 4)Encuentra el día con mayores ingresos
SELECT o.order_date, sum(pt.price*oi.quantity) AS "income"
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products_tiny pt
ON oi.product_id = pt.product_id
GROUP BY o.order_date
ORDER BY income DESC
LIMIT 1;
#2023-05-16 = 340

-- 5)Encuentre el primer pedido (por fecha) para cada cliente
SELECT o.customer_id, c.first_name, c.last_name, min(o.order_date) AS 'first_order'
FROM orders o
JOIN customers c
on o.customer_id = c.customer_id
GROUP BY customer_id;

-- 6)Encuentre los 3 principales clientes que han pedido la mayor cantidad de productos distintos
SELECT o.customer_id, c.first_name, c.last_name, COUNT(DISTINCT oi.product_id) AS "distinct_products"
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY customer_id
ORDER BY Distinct_products DESC
LIMIT 3;
#Jhon Doe, Jane Smith & Bob Johnson = 3 products.

-- 7)¿Qué producto se ha comprado menos en cantidad?
SELECT oi.product_id, pt.product_name, sum(oi.quantity) AS "quantity_buy"
FROM order_items oi
JOIN products_tiny pt
ON oi.product_id = pt.product_id
GROUP BY oi.product_id
ORDER BY quantity_buy ASC;
#Products: D, E, G, H, I, K & L

-- 8)¿Cuál es la mediana del pedido total?
SELECT ROUND(AVG(pt.price*oi.quantity),2) AS "AVG"
FROM order_items oi
JOIN products_tiny pt
ON oi.product_id = pt.product_id;
#70.31

-- 9)Para cada pedido, determine si fue "Caro" (en total más de 300), "Asequible" (en total más de 100) o "Barato"
SELECT oi.order_id, sum(pt.price*oi.quantity) AS "income",
CASE WHEN sum(pt.price*oi.quantity) > 300 THEN "expensive"
	 WHEN sum(pt.price*oi.quantity) BETWEEN 100 AND 300 THEN "affordable"
     ELSE "cheap" END AS segmentation
FROM order_items oi
JOIN products_tiny pt
ON oi.product_id = pt.product_id
GROUP BY oi.order_id;

-- 10)Encuentre clientes que hayan pedido el producto con el precio más alto
SELECT c.customer_id, c.first_name, c.last_name
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id
JOIN customers c
ON o.customer_id = c.customer_id
WHERE oi.product_id = (
						SELECT pt.product_id
						FROM products_tiny pt
						ORDER BY pt.price DESC
						LIMIT 1
                        );
#Customers: 8 & 13 (Ivy Jones & Sophia Thomas)