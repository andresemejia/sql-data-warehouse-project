INSERT INTO silver.erp_cust_az12 (
		cid,
		bdate,
		gen
)

SELECT
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- Remove 'NAS' prefix if present
	ELSE cid
END cid,
CASE WHEN bdate > GETDATE() THEN NULL -- Set future birthdates to NULL
		ELSE bdate
END AS bdate,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	ELSE 'N/A'
END AS gen -- Normalize gender values and handle unknown cases
FROM bronze.erp_cust_az12;
