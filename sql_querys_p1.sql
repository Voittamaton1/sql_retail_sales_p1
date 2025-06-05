	CREATE DATABASE sql_project_p1;


	CREATE TABLE retail_sales
		(
		transactions_id  INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,  
		customer_id	INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),
		quantiy  INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
		);

SELECT * FROM retail_sales
LIMIT 10

SELECT COUNT(*) FROM retail_sales

---DATA CLEANING

SELECT * from retail_sales
WHERE 
	  transactions_id IS NULL
	  OR
  	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL;
	  

DELETE FROM retail_sales
WHERE 
transactions_id IS NULL
	  OR
  	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL;

---DATA EXPLORATION


--HOW MANY SALES WE HAVE?

SELECT COUNT(*) as total_sales FROM retail_sales


--HOW MANY UNIQUE CUSTOMERS WE HAVE?

SELECT COUNT(DISTINCT customer_id) as total_customer FROM retail_sales

SELECT  DISTINCT category FROM retail_sales

--DATA ANALYSIS && BUSINESS KEY PROBLEMS

--0.Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * from retail_sales
WHERE sale_date ='2022-11-05';

--1.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * from retail_sales

WHERE category =  'Clothing'
AND
quantiy >=4
AND 
to_char(sale_date,'YYYY-MM') = '2022-11'



--2.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT 
  ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category='Beauty'

--3.Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales

WHERE total_sale > 1000
--4.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:


SELECT gender,
	   category,
	   COUNT(*) as total_trans
FROM retail_sales
GROUP BY category,gender 
ORDER BY 2

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1
--5.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT year,month,avg_sale
FROM 
(
SELECT 
	EXTRACT (YEAR FROM sale_date) as year,
	EXTRACT (MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	from retail_sales
	GROUP BY 1,2
	) as t1
	WHERE rank=1
	
	
--6.Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT customer_id,SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--7.Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT category,
COUNT(DISTINCT customer_id) as cnt_unique_id
FROM retail_sales
GROUP BY category
--8.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'MORNING'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		ELSE 'EVENING'
	END as shift
FROM retail_sales
)

SELECT 
	SHIFT,COUNT(*) as total_orders
FROM hourly_sale
GROUP BY SHIFT

--9.Write a SQL query to calculate the total sales (total_sale) for each category.:


SELECT 
category,
SUM(total_sale) as net_sale,
count(*) as total_orders
FROM retail_sales
GROUP by 1
