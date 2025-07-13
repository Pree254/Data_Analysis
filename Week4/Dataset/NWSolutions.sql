/*Task6. Given the Employees table, write a SQL query to convert the salary of all employees 
from integer to string data type*/
-- Task7. SQL query to trim  white spaces.
SELECT 
ship_name,
TRIM(ship_name) AS New_ship_name
FROM orders;

 /*Task 8.SQL command to replace null values with the string 'N/A'.*/
 
SELECT 
home_phone,
IFNULL(home_phone, 'N/A') AS New_home_phone,
mobile_phone,
IFNULL(mobile_phone, 'N/A') AS New_mobile_phone
FROM customers;

/*Task9. SQL command to extract the first three characters from the City column in 
the Customers table. */

SELECT
city,
SUBSTRING(city, 1, 3) AS
New_city
FROM customers;
/*SQL query to concatenate the FirstName and LastName of employees in 
the Employees table into a new column FullName.*/

SELECT
first_name,
last_name,
CONCAT(first_name,' ',last_name) AS FullName
FROM employees;
 
 /*TASK 12 Email marketing campaign targeting all customers 
based in France.*/

CREATE DATABASE Plogies;
USE Plogies;
CREATE TABLE customers(
customer_id INT PRIMARY KEY,
Cust_name VARCHAR(100),
email_address VARCHAR(100),
country VARCHAR(100),
city VARCHAR (100)
);
INSERT INTO customers
(customer_id, Cust_name, email_address, country, city)
VALUES 
(1, 'Allison Jazz',' allisonjazz@gmail.com', 'France','Paris'),
(2, 'Davis Owuor', 'daviso123@gmail.com'  ,'France','Libourne'),
(3, 'Halima Ali' , 'halimaali45@gmail.com', 'France', 'Alsace'),
(4, 'Justin Kamau',' justo254@gmail.com', 'France', 'Lasq'),
(5, 'Annete Jero', NULL , 'France', 'Paris'),
(6, 'Davis Owuor', 'daviso123@gmail.com'  ,'France','Libourne'),
(7, 'Godwin Mohammed', NULL , 'France', 'Paris');

DROP TABLES 
customers;

SELECT
email_address
FROM customers
WHERE country= 'France';

/*TASK 13 Exclude any NULL email addresses from your list. We can't send emails to 
addresses we don't have*/

SELECT
cust_name,
email_address
FROM customers
WHERE email_address IS NOT NULL;

SELECT *
FROM customers;

-- Remove all Duplicates--
SELECT 
DISTINCT email_address
FROM customers
WHERE email_address IS NOT NULL;

-- Remove any unnecessary white spaces from the start or end of the email addresses--
SELECT 
DISTINCT (TRIM( email_address)) AS New_email
FROM customers
WHERE email_address IS NOT NULL;

-- WINDOWS FUNTION--
/* Task 1 Rank all the orders of a specific customer from the most recent to the least recent using 
window functions. Assume that the customer ID is 'ALFKI'*/

USE northwind;
SELECT
customer_id,
id,
RANK() OVER (ORDER BY order_date DESC) AS Rank_order_date
FROM orders
ORDER BY 3; 

-- Task 2 Calculate a running total of the quantity of orders using window functions--
SELECT
Order_id,
quantity,
SUM(quantity) OVER (ORDER BY order_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_total
FROM order_details;

-- Use window functions to find the difference in successive order dates for each customer--
SELECT 
customer_id,
order_date,
LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order,
DATEDIFF(order_date, LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) ) AS Days_diff
FROM orders;

/* Calculate the moving average of the quantity of the last 3 orders for each product using 
window functions.*/
SELECT
order_id,
product_id,
quantity,
AVG(quantity) OVER (PARTITION BY product_id ORDER BY order_id ROWS BETWEEN 2 PRECEDING  AND CURRENT ROW) AS Moving_avg_qnt
FROM order_details;
