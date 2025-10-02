import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

public class App {

    private static final Logger log = LoggerFactory.getLogger(App.class);

    public static void main(String[] args) {
        // Загрузка настроек подключения
        Properties props = new Properties();
        try (InputStream is = App.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (is == null) {
                log.error("Файл application.properties не найден в classpath!");
                return;
            }
            props.load(is);
        } catch (Exception e) {
            log.error("Ошибка при загрузке файла application.properties", e);
            return;
        }

        String url = props.getProperty("db.url");
        String user = props.getProperty("db.user");
        String password = props.getProperty("db.password");

        if (url == null || user == null || password == null) {
            log.error("Отсутствуют обязательные параметры подключения в application.properties");
            return;
        }

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            log.info("✅ Успешное подключение к базе данных PostgreSQL.");

            // 1. Вставка нового клиента
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO customer (first_name, last_name, email) VALUES (?, ?, ?)")) {
                ps.setString(1, "Тест");
                ps.setString(2, "Пользователь");
                ps.setString(3, "test@jdbc.com");
                ps.executeUpdate();
                log.info("✅ Добавлен новый клиент: Тест Пользователь");
            }

            // 2. Чтение последних 5 заказов с JOIN
            String query = """
                SELECT c.first_name, c.last_name, p.description, o.quantity, o.order_date
                FROM "order" o
                JOIN customer c ON o.customer_id = c.id
                JOIN product p ON o.product_id = p.id
                ORDER BY o.order_date DESC
                LIMIT 5
                """;

            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(query)) {
                log.info("📋 Последние 5 заказов:");
                while (rs.next()) {
                    log.info("  {} {} — {} (x{}) — {}",
                            rs.getString("first_name"),
                            rs.getString("last_name"),
                            rs.getString("description"),
                            rs.getInt("quantity"),
                            rs.getTimestamp("order_date"));
                }
            }

            // 3. Обновление цены товара
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE product SET price = price * 1.1 WHERE description = ?")) {
                ps.setString(1, "Коврик для мыши");
                int updated = ps.executeUpdate();
                log.info("📈 Обновлено {} записей (цена увеличена на 10%)", updated);
            }

            // 4. Удаление тестового клиента
            try (PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM customer WHERE email = ?")) {
                ps.setString(1, "test@jdbc.com");
                int deleted = ps.executeUpdate();
                log.info("🗑️ Удалено {} тестовых клиентов", deleted);
            }

            log.info("✅ Все операции выполнены успешно.");
        } catch (SQLException e) {
            log.error("❌ Ошибка при работе с базой данных", e);
        }
    }
}