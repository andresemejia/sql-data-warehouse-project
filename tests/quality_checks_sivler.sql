/*
===============================================================================

Quality Checks

===============================================================================

Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schema. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.

===============================================================================
*/

-- =============================================================================
-- Checking 'silver.crm_cust_info'
-- =============================================================================

-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Result

SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for unwanted Spaces
-- Expectation: No Results

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data Standardization & Consistency

SELECT DISTINCT cst_gender
FROM silver.crm_cust_info

SELECT * FROM silver.crm_cust_info

-- ============================================================================
-- Checking 'silver.crm_prd_info'
-- ============================================================================

-- Quality Checks
-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Result

SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for unwanted Spaces
-- Expectation: No Results

SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Data Standardization & Consistency

SELECT DISTINCT prd_line
FROM silver.crm_prd_info

SELECT * FROM silver.crm_cust_info

-- Check for NULLs or Negative Numbers
-- Expectation: No results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--- Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

--- FINAL LOOK 
SELECT *
FROM silver.crm_prd_info

-- ============================================================================
-- Checking 'silver.crm_sales_details'
-- ============================================================================

-- Check for Invalid Dates for sls_order_dt, sls_ship_dt, sls_due_dt 
SELECT
NULLIF(sls_due_dt,0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
OR LEN(sls_due_dt) != 8 
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101

--- Check for Invalid Date Orders (Order Date must always be earlier than shipping date or due date)
SELECT 
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

--- Check Data Consistency: Between Sales, Quantity, and Price
--- >> Sales = Quantity * Price
--- >> Values must not be NULL, zero, or negative.

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

SELECT * FROM silver.crm_sales_details

-- ============================================================================
-- Checking 'silver.erp_cust_az12'
-- ============================================================================

-- Identify Out-of-Range Dates

SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data Standardization & Consistency

SELECT DISTINCT gen
FROM silver.erp_cust_az12

SELECT * FROM silver.erp_cust_az12

-- ============================================================================
-- Checking 'silver.erp_loc_a101'
-- ============================================================================

-- Data Standardization & Consistency

SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry

SELECT * FROM silver.erp_loc_a101

-- ============================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ============================================================================

-- Check unwanted Spaces
SELECT * FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Data Standardization & Consistency
SELECT DISTINCT
cat,
subcat,
maintenance
FROM
silver.erp_px_cat_g1v2

SELECT *  FROM silver.erp_px_cat_g1v2
