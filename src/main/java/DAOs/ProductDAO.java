package DAOs;

import Models.Product;
import Utilities.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class ProductDAO {

    // Lấy danh sách tất cả sản phẩm
    public List<Product> getAllProducts() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Product ORDER BY productId", Product.class).list();
        }
    }

    // Lấy 1 sản phẩm theo ID
    public Product getProductById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Product.class, id);
        }
    }

    // Lưu sản phẩm mới
    public void saveProduct(Product product) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(product);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    // Cập nhật sản phẩm
    public void updateProduct(Product product) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.update(product);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    // Xoá sản phẩm
    public void deleteProduct(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Product product = session.get(Product.class, id);
            if (product != null) {
                tx = session.beginTransaction();
                session.delete(product);
                tx.commit();
            }
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }
}
