-- ============================================
-- Step 0: Data Cleaning (run BEFORE analysis)
-- Table: zomato
-- ============================================

-- 1. Check total row count
SELECT COUNT(*) AS total_rows FROM zomato;


-- 2. Check for NULL values in each important column
SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_name,
    SUM(CASE WHEN online_order IS NULL THEN 1 ELSE 0 END) AS null_online_order,
    SUM(CASE WHEN book_table IS NULL THEN 1 ELSE 0 END) AS null_book_table,
    SUM(CASE WHEN rate IS NULL THEN 1 ELSE 0 END) AS null_rate,
    SUM(CASE WHEN votes IS NULL THEN 1 ELSE 0 END) AS null_votes,
    SUM(CASE WHEN cost IS NULL THEN 1 ELSE 0 END) AS null_cost,
    SUM(CASE WHEN restaurant IS NULL THEN 1 ELSE 0 END) AS null_restaurant
FROM zomato;


-- 3. Check for duplicate rows (based on name + restaurant type, adjust as needed)
SELECT name, restaurant, COUNT(*) AS duplicate_count
FROM zomato
GROUP BY name, restaurant
HAVING COUNT(*) > 1;


-- 4. Check for blank/empty strings (not NULL, but empty '')
SELECT COUNT(*) AS blank_names FROM zomato WHERE name = '';
SELECT COUNT(*) AS blank_online_order FROM zomato WHERE online_order = '';
SELECT COUNT(*) AS blank_restaurant FROM zomato WHERE restaurant = '';


-- 5. Check rate range (should be between 0 and 5 — flag anything odd)
SELECT MIN(rate) AS min_rate, MAX(rate) AS max_rate FROM zomato;


-- 6. Check cost range (flag negative or unusually high values)
SELECT MIN(cost) AS min_cost, MAX(cost) AS max_cost FROM zomato;


-- 7. Check distinct values in categorical columns (spot inconsistent spellings/casing)
SELECT DISTINCT online_order FROM zomato;
SELECT DISTINCT book_table FROM zomato;
SELECT DISTINCT restaurant FROM zomato;


-- 8. If NULLs found, remove them (only run this if step 2 showed nulls)
DELETE FROM zomato
WHERE name IS NULL 
   OR rate IS NULL 
   OR cost IS NULL 
   OR restaurant IS NULL;


-- 9. If duplicates found, remove them (keeps one copy, removes extras)
-- Safer approach: create a cleaned table instead of deleting in place
CREATE TABLE zomato_cleaned AS
SELECT DISTINCT * FROM zomato;