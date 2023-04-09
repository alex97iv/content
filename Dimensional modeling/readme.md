## Module02 - homework:

### Cкрипты загрузки данных в БД:
*Схема БД представлена тремя таблицами:* </br>
1. **orders** - содержит сведения о заказе </br> 

|Атрибут|Расшифровка|
|---|---|
|Row ID|Идентификатор строки (уникальный)|
|Order ID|Идентификатор заказа|
|Order Date|Дата заказа|
|Ship Date|Дата доставки|
|Ship Mode|Класс доставки|
|Customer ID|Идентификатор покупателя|
|Customer Name|Имя и фамилия покупателя|
|Segment|Сегмент покупателя|
|Country|Страна|
|City|Город |
|State|Штат|
|Postal Code|Почтовый индекс|
|Region|	Регион|
|Product ID|	Идентификатор товара|
|Category|	Категория|
|Sub-Category|	Подкатегория|
|Product Name|	Название товара|
|Sales|	Продажи (Доход)|
|Quantity|	Количество|
|Discount|	Скидка в %|
|Profit|	Прибыль|
|Person|	Региональный менеджер|
|Returned|	Возвраты товара|

[скрипт загрузки таблицы orders](https://github.com/alex97iv/DE-content/blob/main/data-learn-course/module02/scripts/orders.sql) </br> 
2. **people** - содержит данные о продавце с привязкой к конкретному региону; </br> 

|Атрибут|Расшифровка|
|---|---|
|Person|менеджер|
|Region|регион ответственности|

[скрипт загрузки таблицы people](https://github.com/alex97iv/DE-content/blob/main/data-learn-course/module02/scripts/people.sql) </br>
3. **returns** - содержит сведения о возврате заказов (атрибуты: Returned, Order_ID); </br> 

|Атрибут|Расшифровка|
|---|---|
|Returned|факт возврата|
|Order_ID|номер заказа|

[скрипт загрузки таблицы returns](https://github.com/alex97iv/DE-content/blob/main/data-learn-course/module02/scripts/returns.sql)

### Обзор ключевых бизнес-метрик:
* **Total sales:** *2297200.86 $* 
``` 
SELECT ROUND(SUM(sales), 2)
FROM orders; 
```
* **Total profits:** *286397.02 $* 
```
SELECT ROUND(SUM(profit), 2)
FROM orders;
```
* **Profit ratio:** *8,02 %*
```
SELECT CONCAT(ROUND((SUM(sales) / SUM(profit)), 2), ' %')
FROM orders;
```
* **Profit per Order:**
```
SELECT order_id, SUM(profit) AS "profit per order"
FROM orders
GROUP BY order_id;
```
* **Sales per Customer:**
```
SELECT customer_name, SUM(sales) as "sales per customer"
FROM orders
GROUP BY customer_name;
```
* **Avg. Discount:**
```
SELECT AVG(discount) as "total avg discount"
FROM orders;
```
* **Monthly Sales by Segment:**
```
SELECT segment, 
       EXTRACT(MONTH FROM DATE (Order_Date)) AS month, 
       SUM(sales) AS "total sales"
FROM orders
GROUP BY segment, EXTRACT(MONTH FROM DATE (Order_Date))
ORDER BY segment, EXTRACT(MONTH FROM DATE (Order_Date)) ASC;
```
* **Monthly Sales by Product Category:**
```
SELECT category, 
       EXTRACT(MONTH FROM DATE (Order_Date)) AS month, 
       SUM(sales) AS "total sales"
FROM orders
GROUP BY category, EXTRACT(MONTH FROM DATE (Order_Date))
ORDER BY category, EXTRACT(MONTH FROM DATE (Order_Date)) ASC;
```
### Обзор продуктовых метрик:
* **Sales by Product Category over time:**
```
SELECT category, SUM(sales) AS "sales", Order_Date AS "order date"
FROM orders
GROUP BY category, Order_Date
ORDER BY category, Order_date;
```
### Обзор покупателей:
* **Sales and Profit by Customer:**
```
SELECT Customer_ID AS "ID",
       Customer_Name "Name",
       SUM(sales) AS "Total sales", 
       SUM(profit) AS "Total profit"
FROM orders
GROUP BY Customer_ID, Customer_Name
ORDER BY Customer_ID;
```
* **Customer Ranking:**
```
SELECT Customer_ID, Customer_Name, COUNT(*) AS "orders number"
FROM orders
GROUP BY Customer_ID, Customer_Name
ORDER BY COUNT(*) DESC;
```
* **Sales per region:**
```
SELECT region, COUNT(*) AS "sales number"
FROM orders
GROUP BY region
ORDER BY COUNT(*) DESC;
```
### Dimensional data model design:
*Conceptual stage:* <br>
![Conceptual stage of design](https://github.com/alex97iv/DE-content/blob/main/data-learn-course/module02/conceptual_diagram.png)

*Logical stage:* <br>
![Logical stage of design](https://github.com/alex97iv/DE-content/blob/main/data-learn-course/module02/logical_diagram.png)

*Physical stage:* <br>
![Physical stage of design](https://github.com/alex97iv/DE-content/blob/main/data-learn-course/module02/physical_diagram.png)

### Analytical cloud DWH example:
The following analytical decision was chosen to complete the exercise with AWS cloud.
![Yandex cloud analytical decision](https://github.com/alex97iv/DE-content/blob/main/data-learn-course/module02/cloud_desicion.png)
The Postgres DB contains two schemas: staging and business.<br>
Staging part of the DB was populated by scripts mentioned above.
Dimensional model diagram for business part of the DB represented in 'Dimensional data model design' part. <br>
[Script](https://github.com/alex97iv/DE-content/blob/main/data-learn-course/module02/scripts/from_stg_to_bsns.sql) for migrating data from staging layer to business layer is provided.
P.S. The DB diagram provided above was changed while I was deploying DWH's business layer. <br>
Changed some attributes' names and types to make it more convenient.

### Dashboard sample:
I've used DataLens from Yandex as BI tool :
![pic1](https://github.com/alex97iv/DE-content/blob/main/data-learn-course/module02/dashboard_dataset.png)
![pic2](https://github.com/alex97iv/DE-content/blob/main/data-learn-course/module02/datalens_dashboard.png)
