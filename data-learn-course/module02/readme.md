## Module02 - homework:
### Cкрипты загрузки данных в БД:
*Схема БД представлена тремя таблицами:* </br>
1. **orders** - содержит сведения о заказе </br> 

|Атрибут|Расшифровка|
|---|---|
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

[скрипт загрузки таблицы order](https://github.com/alex97iv/DE-content/blob/main/data-learn-course/module02/scripts/orders.sql) </br> 
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

### Поиск ответов на бизнес-вопросы:
1. 
