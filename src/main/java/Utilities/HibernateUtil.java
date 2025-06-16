package Utilities;

import Models.Voucher;
import Models.User;
import Models.MemberLevel;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
    private static SessionFactory sessionFactory;

    static {
        try {
            Configuration configuration = new Configuration();
            configuration.addAnnotatedClass(Voucher.class);
            configuration.addAnnotatedClass(User.class);
            configuration.addAnnotatedClass(MemberLevel.class);

            configuration.setProperty("hibernate.connection.driver_class",
                    "com.microsoft.sqlserver.jdbc.SQLServerDriver");
            configuration.setProperty("hibernate.dialect", "org.hibernate.dialect.SQLServerDialect");
            configuration.setProperty("hibernate.connection.url",
                    "jdbc:sqlserver://sql.truongvu.id.vn:58833;databaseName=CGMS;encrypt=true;trustServerCertificate=true");
            configuration.setProperty("hibernate.connection.username", "admin");
            configuration.setProperty("hibernate.connection.password", "FMCSystem@1234");
            configuration.setProperty("hibernate.show_sql", "true");
            configuration.setProperty("hibernate.format_sql", "true");
            configuration.setProperty("hibernate.hbm2ddl.auto", "validate");

            StandardServiceRegistryBuilder builder = new StandardServiceRegistryBuilder()
                    .applySettings(configuration.getProperties());

            sessionFactory = configuration.buildSessionFactory(builder.build());

        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Failed to initialize Hibernate session factory: " + ex.getMessage());
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
}
