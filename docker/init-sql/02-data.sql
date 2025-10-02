-- Вставка тестовых данных
INSERT INTO order_status (name) VALUES
('новый'), ('в обработке'), ('отправлен'), ('доставлен'), ('отменён')
ON CONFLICT DO NOTHING;

INSERT INTO product (description, price, quantity, category) VALUES
('Ноутбук Dell XPS', 75000.00, 10, 'Электроника'),
('Мышь Logitech', 2500.00, 50, 'Электроника'),
('Клавиатура механическая', 4500.00, 30, 'Электроника'),
('Рюкзак для ноутбука', 3000.00, 20, 'Аксессуары'),
('USB-флешка 64 ГБ', 1200.00, 100, 'Электроника'),
('Наушники Sony', 8000.00, 15, 'Электроника'),
('Зарядное устройство', 1500.00, 40, 'Электроника'),
('Монитор 24"', 18000.00, 8, 'Электроника'),
('Подставка под ноутбук', 2000.00, 25, 'Аксессуары'),
('Коврик для мыши', 500.00, 60, 'Аксессуары');

INSERT INTO customer (first_name, last_name, phone, email) VALUES
('Иван', 'Иванов', '+79001234567', 'ivan@example.com'),
('Мария', 'Петрова', '+79007654321', 'maria@example.com'),
('Алексей', 'Сидоров', NULL, 'alex@example.com'),
('Елена', 'Кузнецова', '+79112223344', 'elena@example.com'),
('Дмитрий', 'Смирнов', '+79223334455', 'dmitry@example.com'),
('Ольга', 'Попова', NULL, 'olga@example.com'),
('Сергей', 'Волков', '+79334445566', 'sergey@example.com'),
('Анна', 'Лебедева', '+79445556677', 'anna@example.com'),
('Павел', 'Григорьев', NULL, 'pavel@example.com'),
('Татьяна', 'Федорова', '+79556667788', 'tanya@example.com');

INSERT INTO "order" (product_id, customer_id, order_date, quantity, status_id) VALUES
(1, 1, NOW() - INTERVAL '1 day', 1, 4),
(2, 2, NOW() - INTERVAL '2 days', 2, 3),
(3, 3, NOW() - INTERVAL '3 days', 1, 2),
(4, 4, NOW() - INTERVAL '5 days', 1, 4),
(5, 5, NOW() - INTERVAL '6 days', 3, 3),
(6, 6, NOW() - INTERVAL '7 days', 1, 1),
(7, 7, NOW() - INTERVAL '8 days', 2, 2),
(8, 8, NOW() - INTERVAL '10 days', 1, 4),
(9, 9, NOW() - INTERVAL '12 days', 1, 2),
(10, 10, NOW() - INTERVAL '14 days', 2, 1);