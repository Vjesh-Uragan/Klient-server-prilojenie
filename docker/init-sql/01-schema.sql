-- Создание схемы
CREATE TABLE IF NOT EXISTS order_status (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS product (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    price NUMERIC(10, 2) CHECK (price >= 0),
    quantity INT CHECK (quantity >= 0),
    category VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS customer (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(150) UNIQUE
);

CREATE TABLE IF NOT EXISTS "order" (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES product(id) ON DELETE CASCADE,
    customer_id INT NOT NULL REFERENCES customer(id) ON DELETE CASCADE,
    order_date TIMESTAMP NOT NULL DEFAULT NOW(),
    quantity INT CHECK (quantity > 0),
    status_id INT NOT NULL REFERENCES order_status(id)
);

CREATE INDEX IF NOT EXISTS idx_order_product_id ON "order"(product_id);
CREATE INDEX IF NOT EXISTS idx_order_customer_id ON "order"(customer_id);
CREATE INDEX IF NOT EXISTS idx_order_date ON "order"(order_date);
CREATE INDEX IF NOT EXISTS idx_product_category ON product(category);