CREATE DATABASE company_sales;

USE company_sales;

CREATE TABLE sales (
    id INT,
    employee VARCHAR(50),
    department VARCHAR(10),
    sales_amount INT,
    sale_date DATE
);

-- Insert Data
INSERT INTO sales VALUES
(1, 'Alice', 'A', 1000, '2024-01-01'),
(2, 'Bob',   'B', 1500, '2024-01-02'),
(3, 'Alice', 'A', 2000, '2024-01-03'),
(4, 'Bob',   'B', 1800, '2024-01-04'),
(5, 'Alice', 'A', 1200, '2024-01-05'),
(6, 'Bob',   'B', 1600, '2024-01-06');

SELECT *,
SUM(sales_amount) OVER(
    PARTITION BY employee
    ORDER BY sale_date
) AS running_total
FROM sales;

SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY employee
    ORDER BY sale_date
) AS row_num
FROM sales;

SELECT *,
RANK() OVER(
    PARTITION BY department
    ORDER BY sales_amount DESC
) AS sales_rank
FROM sales;

SELECT *,
LEAD(sales_amount) OVER(
    PARTITION BY employee
    ORDER BY sale_date
) AS next_sale
FROM sales;

SELECT *,
LAG(sales_amount) OVER(
    PARTITION BY employee
    ORDER BY sale_date
) AS previous_sale
FROM sales;

SELECT *,
AVG(sales_amount) OVER(
    PARTITION BY employee
) AS avg_sales
FROM sales;

SELECT *,
FIRST_VALUE(sales_amount) OVER(
    PARTITION BY employee
    ORDER BY sale_date
) AS first_sale,

LAST_VALUE(sales_amount) OVER(
    PARTITION BY employee
    ORDER BY sale_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS last_sale
FROM sales;

SELECT *,
DENSE_RANK() OVER(
    PARTITION BY department
    ORDER BY sales_amount DESC
) AS dense_rank_no_gap
FROM sales;

SELECT *,
AVG(sales_amount) OVER(
    PARTITION BY employee
    ORDER BY sale_date
) AS cumulative_avg
FROM sales;

SELECT *,
MAX(sales_amount) OVER(
    PARTITION BY employee
) AS highest_sale
FROM sales;


SELECT *,
sales_amount -
LAG(sales_amount) OVER(
    PARTITION BY employee
    ORDER BY sale_date
) AS sales_difference
FROM sales;

SELECT *,
COUNT(*) OVER(
    PARTITION BY employee
    ORDER BY sale_date
) AS cumulative_count
FROM sales;

SELECT *,
CASE
    WHEN sales_amount >
         AVG(sales_amount) OVER(PARTITION BY employee)
    THEN 'Above Average'
    ELSE 'Below Average'
END AS sale_status
FROM sales;

SELECT *
FROM (
    SELECT *,
    DENSE_RANK() OVER(
        PARTITION BY employee
        ORDER BY sales_amount DESC
    ) AS rnk
    FROM sales
) t
WHERE rnk = 2;