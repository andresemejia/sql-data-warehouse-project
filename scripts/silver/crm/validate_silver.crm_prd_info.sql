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
