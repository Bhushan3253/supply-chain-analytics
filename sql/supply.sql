
CREATE DATABASE supply_chain_analysis;

USE supply_chain_analysis;

-- 1. Inspect all column names and data types
DESCRIBE supply_chain;

-- 2. Check total number of rows
SELECT COUNT(*) AS total_rows
FROM supply_chain;

-- 3. Preview the imported data
SELECT *
FROM supply_chain
LIMIT 10;

ALTER TABLE supply_chain
DROP COLUMN customer_email;

ALTER TABLE supply_chain
DROP COLUMN customer_password;


USE supply_chain_analysis;

SELECT
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT order_item_id) AS distinct_order_items,
    COUNT(DISTINCT product_card_id) AS distinct_products,
    COUNT(DISTINCT customer_id) AS distinct_customers,
    MIN(order_date_dateorders) AS first_order_date,
    MAX(order_date_dateorders) AS last_order_date
FROM supply_chain;


SELECT
    COUNT(*) AS total_rows,
    SUM(order_id IS NULL) AS missing_order_ids,
    SUM(order_item_id IS NULL) AS missing_item_ids,
    SUM(order_date_dateorders IS NULL) AS missing_order_dates,
    SUM(sales IS NULL) AS missing_sales,
    SUM(order_item_quantity IS NULL) AS missing_quantities,
    SUM(delivery_status IS NULL) AS missing_delivery_status
FROM supply_chain;


SELECT
    order_item_id,
    COUNT(*) AS occurrences
FROM supply_chain
GROUP BY order_item_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;



SELECT
    DATE_FORMAT(order_date_dateorders, '%Y-%m') AS order_month,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(
        100.0 * SUM(order_profit_per_order)
        / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders
FROM supply_chain
GROUP BY DATE_FORMAT(order_date_dateorders, '%Y-%m')
ORDER BY order_month;



SELECT
    category_name,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_item_quantity) AS units_sold,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit
FROM supply_chain
GROUP BY category_name
ORDER BY total_profit DESC;


SELECT
    delivery_status,
    COUNT(*) AS order_item_rows,
    COUNT(DISTINCT order_id) AS affected_orders,
    ROUND(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM supply_chain),
        2
    ) AS pct_of_item_rows
FROM supply_chain
GROUP BY delivery_status
ORDER BY order_item_rows DESC;


SELECT
    shipping_mode,
    COUNT(*) AS total_items,
    SUM(late_delivery_risk = 1) AS items_flagged_at_risk,
    ROUND(
        100.0 * SUM(late_delivery_risk = 1)
        / NULLIF(COUNT(*), 0),
        2
    ) AS risk_rate_pct,
    ROUND(
        AVG(days_for_shipping_real), 2
    ) AS avg_actual_shipping_days,
    ROUND(
        AVG(days_for_shipment_scheduled), 2
    ) AS avg_scheduled_shipping_days
FROM supply_chain
GROUP BY shipping_mode
ORDER BY risk_rate_pct DESC;



SELECT
    customer_segment,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(
        SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS sales_per_order
FROM supply_chain
GROUP BY customer_segment
ORDER BY total_sales DESC;


SELECT
    product_name,
    category_name,
    SUM(order_item_quantity) AS units_sold,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(
        100.0 * SUM(order_profit_per_order)
        / NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_pct
FROM supply_chain
GROUP BY product_name, category_name
HAVING SUM(sales) > 0
ORDER BY profit_margin_pct ASC
LIMIT 10;


SELECT
    order_id,
    order_item_id,
    product_name,
    order_item_quantity,
    order_item_product_price,
    order_item_discount,
    sales,
    order_item_total,
    order_profit_per_order,
    benefit_per_order,
    order_item_profit_ratio
FROM supply_chain
LIMIT 20;








