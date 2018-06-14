-- Ниже перечисленные запросы запускались в MySQL и PostgreSQL

--2. Создайте таблицу Категорий товаров (например "Еда", "Посуда", 
--   Обувь") и таблицу производителей (брендов)
	CREATE TABLE categories (
	  id SERIAL PRIMARY KEY,
	  name VARCHAR(100)
	);

	INSERT INTO categories (name)
	VALUES 
	('Еда'),
	('Посуда'),
	('Обувь');

	CREATE TABLE brands (
	  id SERIAL PRIMARY KEY,
	  name VARCHAR(100)
	);

	INSERT INTO brands (name)
	VALUES 
	('Веселый Молочник'),
	('Серпуховской хлеб'),
	('Nike'),
	('Puma'),
	('Allesia'),
	('Alma');

--3. Добавьте в таблицу Товаров поля для связи с Категориями и Брендами
	-- MySQL
	ALTER TABLE products
	ADD cat_id BIGINT UNSIGNED NULL;

	ALTER TABLE products
	ADD brand_id BIGINT UNSIGNED NULL;

	-- PostgreSQL
	ALTER TABLE products
	ADD cat_id INTEGER NULL;

	ALTER TABLE products
	ADD brand_id INTEGER NULL;

--4. Создайте внешние ключи для этих связей. Определите самостоятельно 
--   ограничения внешних ключей. Протестируйте работу внешних ключей.
	ALTER TABLE products
	ADD FOREIGN KEY (cat_id)
	REFERENCES categories(id)
	ON UPDATE CASCADE
	ON DELETE SET NULL;
	
	ALTER TABLE products
	ADD FOREIGN KEY (brand_id)
	REFERENCES brands(id)
	ON UPDATE CASCADE
	ON DELETE SET NULL;

--5. Создать запросы, которые:
	--1. Выберут все товары с указанием их категории и бренда
		SELECT *
		FROM products
		INNER JOIN brands ON products.brand_id = brands.id
		INNER JOIN categories ON products.cat_id = categories.id;

	--2. Выберут все товары, бренд которых начинается на букву "А"
		SELECT *
		FROM products
		INNER JOIN brands ON products.brand_id = brands.id
		WHERE brands.name LIKE 'A%';

	--3. Выведут список категорий и число товаров в каждой (используйте подзапросы
	--   и функцию COUNT(), использовать группировку нельзя)
		SELECT *, (
		  SELECT count(*)
		  FROM products
		  WHERE products.cat_id = categories.id
		) AS cnt
		FROM categories;

	--4. * Выберут для каждой категории список брендов товаров, входящих в нее
		SELECT categories.name, brands.name
		FROM products
		  INNER JOIN brands ON products.brand_id = brands.id
		  INNER JOIN categories ON products.cat_id = categories.id
		GROUP BY categories.name, brands.name