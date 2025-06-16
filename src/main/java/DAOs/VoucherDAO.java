package DAOs;

import Models.Voucher;
import org.hibernate.Session;
import org.hibernate.Transaction;
import Utilities.HibernateUtil;

import java.util.List;

public class VoucherDAO {

    public List<Voucher> getAllVouchers() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Voucher ORDER BY id", Voucher.class).list();
        }
    }

    public Voucher getVoucherById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Voucher.class, id);
        }
    }

    public void saveVoucher(Voucher voucher) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.save(voucher);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    public void updateVoucher(Voucher voucher) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.update(voucher);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }

    public void deleteVoucher(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Voucher voucher = session.get(Voucher.class, id);
            if (voucher != null) {
                tx = session.beginTransaction();
                session.delete(voucher);
                tx.commit();
            }
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        }
    }
}