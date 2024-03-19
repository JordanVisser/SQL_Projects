CREATE TABLE customer_spending (
    sale_date       DATE,	
    sale_year       INT,
    sale_month      VARCHAR(255),
    age             INT, 
    gender          CHAR(1),
    country         VARCHAR(255),
    state           VARCHAR(255),
    category        VARCHAR(255),
    sub_category    VARCHAR(255),
    quantity        INT,
    unit_cost       NUMERIC(6,2),
    unit_price      NUMERIC(10,6),
    cost            INT,
    revenue         INT
);

COPY customer_spending
FROM 'Insert your directory here'
WITH (FORMAT CSV,HEADER);

SELECT category, SUM(revenue) AS total_revenue FROM customer_spending
WHERE sale_year = 2016
GROUP BY category
ORDER BY category;

SELECT sub_category, ROUND(AVG(unit_price),2), ROUND(AVG(unit_cost),2), ROUND(AVG(unit_price) - AVG(unit_cost), 2) AS margin FROM customer_spending
WHERE sale_year = 2015
GROUP BY sub_category
ORDER BY sub_category;

SELECT sale_year, COUNT(gender) AS total_female_buyers FROM customer_spending
WHERE gender = 'F' AND category = 'Clothing'
GROUP BY sale_year
ORDER BY sale_year;

SELECT age, sub_category, ROUND(AVG(quantity)) AS avg_quantity, ROUND(AVG(cost),2) AS avg_cost FROM customer_spending
GROUP BY age, sub_category
ORDER BY age DESC, sub_category;

SELECT country FROM customer_spending
WHERE age BETWEEN 18 AND 25
GROUP BY country
HAVING COUNT(*) > 900;

SELECT sale_year, category, SUM(revenue) AS total_revenue, SUM(cost) AS total_cost, SUM(revenue - cost) AS profit FROM customer_spending
GROUP BY sale_year, category
HAVING SUM(revenue - cost) > 0
ORDER BY profit DESC;

SELECT age, ROUND(AVG(unit_price * quantity),2) AS avg_spending
FROM customer_spending
WHERE gender = 'M'
GROUP BY age
ORDER BY avg_spending DESC;

SELECT gender, category, MAX(unit_cost) AS high_cost, MIN(unit_cost) AS low_cost, AVG(unit_cost) AS avg_cost
FROM customer_spending
GROUP BY gender, category
ORDER BY gender, category;

SELECT category, country, MIN(age) AS youngest_customer, MAX(age) AS oldest_customer, ROUND(AVG(age), 1) AS avg_customer_age
FROM customer_spending
WHERE sale_year = 2016
GROUP BY category, country
ORDER BY category, avg_customer_age;

SELECT country, ROUND(AVG(revenue),2) AS high_sales 
FROM customer_spending
GROUP BY country
ORDER BY high_sales DESC
LIMIT 1;