-- populating region_dim
INSERT INTO bsns.region_dim (country, state, city, postal_code, region)
SELECT DISTINCT country, state, city, postal_code, region
  FROM stg.orders;

SELECT country, state, city, postal_code, region
  FROM stg.orders o
 WHERE country IS NULL
    OR state IS NULL
    OR city IS NULL
    OR postal_code IS NULL
    OR region IS NULL;

UPDATE stg.orders   
   SET postal_code = '05401'
 WHERE city = 'Burlington';
   
 ALTER TABLE stg.orders
 ALTER postal_code TYPE VARCHAR(50);

SELECT * FROM bsns.region_dim;

DELETE FROM bsns.region_dim;

 ALTER SEQUENCE bsns.region_dim_region_id_seq RESTART WITH 1;


-- populating salesman_dim
INSERT INTO bsns.salesman_dim (person)
SELECT DISTINCT person
  FROM stg.people;

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

-- rename columns in customer_dim
ALTER TABLE bsns.customer_dim RENAME COLUMN customer_id TO cust_id;
ALTER TABLE bsns.customer_dim RENAME COLUMN customer_id1 TO customer_id;
ALTER TABLE bsns.sales_fact RENAME COLUMN customer_id TO cust_id;
ALTER TABLE bsns.product_dim RENAME COLUMN sub_category TO subcategory;


-- check number of rows in sales_fact
SELECT COUNT(*)
  FROM bsns.sales_fact 
  JOIN bsns.customer_dim USING(cust_id)
  JOIN bsns.product_dim USING(prod_id)
  JOIN bsns.order_dim USING(ord_id)
  JOIN bsns.region_dim USING(region_id);
