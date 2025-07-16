package Jobs;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.logging.Logger;

/**
 * ServletContextListener để khởi động và dừng scheduler khi ứng dụng được triển
 * khai và dừng lại
 */
@WebListener
public class SchedulerServletContextListener implements ServletContextListener {
    private static final Logger LOGGER = Logger.getLogger(SchedulerServletContextListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Khởi tạo ứng dụng, bắt đầu scheduler");
        SchedulerManager.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("Dừng ứng dụng, dừng scheduler");
        SchedulerManager.shutdown();
    }
}