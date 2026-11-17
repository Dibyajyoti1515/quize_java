package com.quiztrack.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Thread-safe Database Connection Pool Manager utilizing HikariCP.
 * Reads configuration from db.properties in the classpath with environment variable overrides.
 */
public class DatabaseConnection {

    private static final Logger logger = LoggerFactory.getLogger(DatabaseConnection.class);
    private static final String CONFIG_FILE = "db.properties";
    private static HikariDataSource dataSource;

    static {
        initDataSource();
    }

    private DatabaseConnection() {
        // Private constructor for singleton utility
    }

    private static synchronized void initDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            return;
        }

        Properties props = new Properties();
        try (InputStream is = DatabaseConnection.class.getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            if (is != null) {
                props.load(is);
                logger.info("Loaded database configuration from {}", CONFIG_FILE);
            } else {
                logger.warn("Configuration file {} not found on classpath, relying on defaults/environment", CONFIG_FILE);
            }
        } catch (IOException e) {
            logger.error("Failed to read {} file: {}", CONFIG_FILE, e.getMessage());
        }

        String jdbcUrl = System.getenv("QUIZTRACK_DB_URL");
        if (jdbcUrl == null || jdbcUrl.isEmpty()) {
            jdbcUrl = props.getProperty("db.url", "jdbc:postgresql://localhost:5432/quiztrack_db");
        }

        String username = System.getenv("QUIZTRACK_DB_USER");
        if (username == null || username.isEmpty()) {
            username = props.getProperty("db.user", "postgres");
        }

        String password = System.getenv("QUIZTRACK_DB_PASSWORD");
        if (password == null) {
            password = props.getProperty("db.password", "");
        }

        String driverClass = props.getProperty("db.driver", "org.postgresql.Driver");

        HikariConfig config = new HikariConfig();
        config.setDriverClassName(driverClass);
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(username);
        config.setPassword(password);

        // Pool tuning parameters
        int maxPoolSize = Integer.parseInt(props.getProperty("hikari.maximumPoolSize", "10"));
        int minIdle = Integer.parseInt(props.getProperty("hikari.minimumIdle", "2"));
        long idleTimeout = Long.parseLong(props.getProperty("hikari.idleTimeout", "30000"));
        long connTimeout = Long.parseLong(props.getProperty("hikari.connectionTimeout", "20000"));
        long maxLifetime = Long.parseLong(props.getProperty("hikari.maxLifetime", "1800000"));
        String poolName = props.getProperty("hikari.poolName", "QuizTrackHikariPool");

        config.setMaximumPoolSize(maxPoolSize);
        config.setMinimumIdle(minIdle);
        config.setIdleTimeout(idleTimeout);
        config.setConnectionTimeout(connTimeout);
        config.setMaxLifetime(maxLifetime);
        config.setPoolName(poolName);

        // PostgreSQL specific optimizations
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

        try {
            dataSource = new HikariDataSource(config);
            logger.info("HikariCP connection pool successfully initialized for {}", jdbcUrl);
        } catch (Exception e) {
            logger.error("Failed to initialize HikariCP connection pool: {}", e.getMessage(), e);
            throw new RuntimeException("Database connection pool initialization failed", e);
        }
    }

    /**
     * Obtains an active connection from the pool.
     *
     * @return java.sql.Connection
     * @throws SQLException If a connection cannot be acquired
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null || dataSource.isClosed()) {
            initDataSource();
        }
        return dataSource.getConnection();
    }

    /**
     * Closes the connection pool gracefully upon application shutdown.
     */
    public static synchronized void closePool() {
        if (dataSource != null && !dataSource.isClosed()) {
            logger.info("Closing HikariCP connection pool...");
            dataSource.close();
            dataSource = null;
        }
    }

    /**
     * Diagnostic test method.
     */
    public static void main(String[] args) {
        System.out.println("Testing DatabaseConnection with HikariCP...");
        try (Connection conn = getConnection()) {
            System.out.println("Database connection established successfully!");
            System.out.println("Database Product: " + conn.getMetaData().getDatabaseProductName());
            System.out.println("Database Version: " + conn.getMetaData().getDatabaseProductVersion());
            System.out.println("Driver Version:   " + conn.getMetaData().getDriverVersion());
            System.out.println("AutoCommit:       " + conn.getAutoCommit());
        } catch (SQLException e) {
            System.err.println("Database connection test failed: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closePool();
        }
    }
}
