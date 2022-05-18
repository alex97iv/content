/* populating region_dim
   got an error at first
   so I checked it for having NULLs
   and then I filled in NULLs 
   and tried again - it worked
*/
INSERT INTO bsns.region_dim (country, state, city, postal_code, region)
SELECT DISTINCT country, state, city, postal_code, region
  FROM stg.orders;
  
-- check for having NULLs
SELECT country, state, city, postal_code, region
  FROM stg.orders o
 WHERE country IS NULL
    OR state IS NULL
    OR city IS NULL
    OR postal_code IS NULL
    OR region IS NULL;

-- filling in NULLs
UPDATE stg.orders   
   SET postal_code = '05401'
 WHERE city = 'Burlington';  

-- populating salesman_dim
INSERT INTO bsns.salesman_dim (person)
SELECT DISTINCT person
  FROM stg.people;

-- insert data into order_dim
INSERT INTO bsns.order_dim (order_id, returned, ship_date, ship_mode)
SELECT t1.order_id, 
       CASE WHEN returned IS NULL THEN 'no'
            ELSE 'yes'
        END,
       ship_date, ship_mode
  FROM (SELECT DISTINCT order_id, ship_date, ship_mode 
          FROM stg.orders) t1
       LEFT JOIN (SELECT DISTINCT order_id, returned
                    FROM stg."returns") t2 USING(order_id);
		    
-- insert data into 
INSERT INTO bsns.product_dim (product_id, product_name, category, sub_category)
SELECT DISTINCT product_id, product_name, category, subcategory
  FROM stg.orders 

-- populating sales_fact 
INSERT INTO bsns.sales_fact 
       (sales, profit, quantity, discount, ord_id, region_id,
       salesman_id, cust_id, prod_id)
SELECT sales, profit, quantity, discount,
       od.ord_id, rd.region_id, sd.salesman_id,
       cd.cust_id, pd.prod_id 
  FROM stg.orders o 
       LEFT JOIN stg.people USING(region)
       LEFT JOIN bsns.customer_dim cd USING(customer_name, segment, customer_id)
	   LEFT JOIN bsns.order_dim od USING(order_id, ship_date, ship_mode)
	   LEFT JOIN bsns.product_dim pd USING(product_id, product_name, category, subcategory)
	   LEFT JOIN bsns.region_dim rd USING(country, state, city, postal_code, region)
	   LEFT JOIN bsns.salesman_dim sd USING(person);

-- check number of rows in sales_fact
SELECT COUNT(*)
  FROM bsns.sales_fact 
  JOIN bsns.customer_dim USING(cust_id)
  JOIN bsns.product_dim USING(prod_id)
  JOIN bsns.order_dim USING(ord_id)
  JOIN bsns.region_dim USING(region_id);
        
-- insert data into 
INSERT INTO bsns.product_dim (product_id, product_name, category, sub_category)
SELECT DISTINCT product_id, product_name, category, subcategory
  FROM stg.orders 
  
