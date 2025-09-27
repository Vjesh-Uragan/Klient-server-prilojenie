-- test-queries.sql

-- 1. Заказы за последние 7 дней с именем клиента и товаром
SELECT
    c.first_name, c.last_name, p.description, o.quantity, o.order_date
FROM "order" o
JOIN customer c ON o.customer_id = c.id
JOIN product p ON o.product_id = p.id
WHERE o.order_date >= NOW() - INTERVAL '7 days'
ORDER BY o.order_date DESC;

-- 2. Топ-3 самых популярных товаров (по количеству заказанных единиц)
SELECT
    p.description, SUM(o.quantity) AS total_sold
FROM "order" o
JOIN product p ON o.product_id = p.id
GROUP BY p.id, p.description
ORDER BY total_sold DESC
LIMIT 3;

-- 3. Средняя цена товаров по категориям
SELECT category, AVG(price) AS avg_price
FROM product
GROUP BY category;

-- 4. Клиенты без заказов
SELECT c.first_name, c.last_name, c.email
FROM customer c
LEFT JOIN "order" o ON c.id = o.customer_id
WHERE o.id IS NULL;

-- 5. Общая выручка по статусам заказов
SELECT
    os.name AS status,
    SUM(p.price * o.quantity) AS revenue
FROM "order" o
JOIN product p ON o.product_id = p.id
JOIN order_status os ON o.status_id = os.id
GROUP BY os.name;

-- 6. Обновление цены у всех товаров в категории "Аксессуары"
UPDATE product
SET price = price * 1.1
WHERE category = 'Аксессуары';

-- 7. Увеличение количества на складе для товара с id=1
UPDATE product
SET quantity = quantity + 5
WHERE id = 1;

-- 8. Изменение статуса всех "новых" заказов на "в обработке"
UPDATE "order"
SET status_id = (SELECT id FROM order_status WHERE name = 'в обработке')
WHERE status_id = (SELECT id FROM order_status WHERE name = 'новый');

-- 9. Удаление клиентов без заказов
DELETE FROM customer
WHERE id NOT IN (SELECT DISTINCT customer_id FROM "order");

-- 10. Удаление товаров с нулевым количеством и без заказов
DELETE FROM product
WHERE quantity = 0
  AND id NOT IN (SELECT DISTINCT product_id FROM "order");