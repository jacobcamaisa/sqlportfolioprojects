----------------------

/* Database Schema */

----------------------

CREATE TABLE cars ( 
car_id INT PRIMARY KEY, 
make VARCHAR(50), 
type VARCHAR(50), 
style VARCHAR(50), 
cost_$ INT 
); 
-------------------- 
INSERT INTO cars (car_id, make, type, style, cost_$) 
VALUES (1, 'Honda', 'Civic', 'Sedan', 30000), 
(2, 'Toyota', 'Corolla', 'Hatchback', 25000), 
(3, 'Ford', 'Explorer', 'SUV', 40000), 
(4, 'Chevrolet', 'Camaro', 'Coupe', 36000), 
(5, 'BMW', 'X5', 'SUV', 55000), 
(6, 'Audi', 'A4', 'Sedan', 48000), 
(7, 'Mercedes', 'C-Class', 'Coupe', 60000), 
(8, 'Nissan', 'Altima', 'Sedan', 26000); 
-------------------- 
CREATE TABLE salespersons ( 
salesman_id INT PRIMARY KEY, 
name VARCHAR(50), 
age INT, 
city VARCHAR(50) 
); 
-------------------- 
INSERT INTO salespersons (salesman_id, name, age, city) 
VALUES (1, 'John Smith', 28, 'New York'), 
(2, 'Emily Wong', 35, 'San Fran'), 
(3, 'Tom Lee', 42, 'Seattle'), 
(4, 'Lucy Chen', 31, 'LA'); 
-------------------- 
CREATE TABLE sales ( 
sale_id INT PRIMARY KEY, 
car_id INT, 
salesman_id INT, 
purchase_date DATE, 
FOREIGN KEY (car_id) REFERENCES cars(car_id), 
FOREIGN KEY (salesman_id) REFERENCES salespersons(salesman_id) 
); 
-------------------- 
INSERT INTO sales (sale_id, car_id, salesman_id, purchase_date) 
VALUES (1, 1, 1, '2021-01-01'), 
(2, 3, 3, '2021-02-03'), 
(3, 2, 2, '2021-02-10'), 
(4, 5, 4, '2021-03-01'), 
(5, 8, 1, '2021-04-02'), 
(6, 2, 1, '2021-05-05'), 
(7, 4, 2, '2021-06-07'), 
(8, 5, 3, '2021-07-09'), 
(9, 2, 4, '2022-01-01'), 
(10, 1, 3, '2022-02-03'), 
(11, 8, 2, '2022-02-10'), 
(12, 7, 2, '2022-03-01'), 
(13, 5, 3, '2022-04-02'), 
(14, 3, 1, '2022-05-05'), 
(15, 5, 4, '2022-06-07'), 
(16, 1, 2, '2022-07-09'), 
(17, 2, 3, '2023-01-01'), 
(18, 6, 3, '2023-02-03'), 
(19, 7, 1, '2023-02-10'), 
(20, 4, 4, '2023-03-01');

------------------------

/* QUERIES */

------------------------
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
