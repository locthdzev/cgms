/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utilities;


import org.hibernate.SessionFactory;
import org.hibernate.boot.Metadata;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
/**
 *
 * @author Admin
 */
public class HibernateUtil {
    // StandardServiceRegistry chứa các dịch vụ cần thiết cho Hibernate
    private static StandardServiceRegistry registry;
    
    // SessionFactory dùng để tạo các Session, là cầu nối giữa ứng dụng và cơ sở dữ liệu
    private static SessionFactory sessionFactory;

    /**
     * Phương thức để lấy SessionFactory
     * Nếu SessionFactory chưa được tạo, phương thức sẽ tạo mới
     * @return SessionFactory đã được cấu hình
     */
    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            try {
                // Tạo registry từ file cấu hình hibernate.cfg.xml
                registry = new StandardServiceRegistryBuilder()
                        .configure() // Mặc định sẽ tìm file hibernate.cfg.xml trong thư mục resources
                        .build();

                // Tạo MetadataSources từ registry
                MetadataSources sources = new MetadataSources(registry);

                // Tạo Metadata từ MetadataSources
                Metadata metadata = sources.getMetadataBuilder().build();

                // Tạo SessionFactory từ Metadata
                sessionFactory = metadata.getSessionFactoryBuilder().build();
            } catch (Exception e) {
                e.printStackTrace();
                // Nếu có lỗi xảy ra, hủy registry để giải phóng tài nguyên
                if (registry != null) {
                    StandardServiceRegistryBuilder.destroy(registry);
                }
            }
        }
        return sessionFactory;
    }

    /**
     * Phương thức để đóng SessionFactory và giải phóng tài nguyên
     * Nên gọi phương thức này khi ứng dụng kết thúc
     */
    public static void shutdown() {
        if (registry != null) {
            StandardServiceRegistryBuilder.destroy(registry);
        }
    }
}
