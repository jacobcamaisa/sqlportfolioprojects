-- 1.
SELECT *
FROM cars
WHERE car_id IN (SELECT car_id FROM sales WHERE YEAR(purchase_date) = 2022);

-- 2. 
SELECT salespersons.salesman_id, salespersons.name, COUNT(sales.car_id) AS total_cars_sold
FROM salespersons 
LEFT JOIN sales ON salespersons.salesman_id = sales.salesman_id
GROUP BY salespersons.salesman_id, salespersons.name;

-- 3.
SELECT sp.salesman_id, sp.name, SUM(c.cost_$) as total_revenue
FROM salespersons sp
LEFT JOIN sales s
	ON sp.salesman_id = s.salesman_id
LEFT JOIN cars c 
	ON s.car_id = c.car_id
GROUP BY sp.salesman_id, sp.name;

-- 4.
SELECT sp.salesman_id, sp.name, c.*
FROM salespersons sp
LEFT JOIN sales s ON sp.salesman_id = s.salesman_id
LEFT JOIN cars c ON s.car_id = c.car_id;

-- 5.
SELECT cars.type, SUM(cars.cost_$)
FROM cars
LEFT JOIN sales s
	ON cars.car_id = s.car_id
GROUP BY cars.type;

-- 6. 
SELECT s.sale_id, sp.name, s.purchase_date, cars.*
FROM sales s
JOIN salespersons sp
	ON s.salesman_id = sp.salesman_id
JOIN cars
	ON s.car_id = cars.car_id
WHERE sp.name = "Emily Wong" AND YEAR(s.purchase_date) = 2021;

-- 7.
SELECT c.style, SUM(c.cost_$) as total_revenue_from_hatchbacks
FROM cars c
JOIN sales s
	ON c.car_id = s.car_id
WHERE c.style = 'Hatchback';
-- 8.
SELECT c.style, SUM(c.cost_$) as total_SUV_revenue_2022
FROM cars c
JOIN sales s
	ON c.car_id = s.car_id
WHERE c.style = 'SUV' AND YEAR(s.purchase_date) = 2022;

-- 9.
SELECT sp.name, sp.city, COUNT(s.car_id) as total_cars_sold_2023
FROM salespersons sp
JOIN sales s
	ON sp.salesman_id = s.salesman_id
WHERE YEAR(s.purchase_date) = 2023
GROUP BY sp.name, sp.city
ORDER BY total_cars_sold_2023 desc
LIMIT 1;

-- 10. 
SELECT sp.name, sp.age, SUM(c.cost_$) as total_revenue
FROM salespersons sp
JOIN sales s
	ON sp.salesman_id = s.salesman_id
JOIN cars c
	ON s.car_id = c.car_id
WHERE YEAR(s.purchase_date) = 2022
GROUP BY sp.name, sp.age
ORDER BY total_revenue desc
LIMIT 1