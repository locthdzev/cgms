package Services;

import DAOs.InventoryDAO;
import DAOs.ProductDAO;
import Models.Inventory;
import Models.Product;

import java.time.Instant;
import java.util.List;

public class InventoryService {

    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final ProductDAO productDAO = new ProductDAO();

    public List<Inventory> getAllInventory() {
        return inventoryDAO.getAllInventory();
    }

    public Inventory getInventoryByProductId(int productId) {
        return inventoryDAO.getInventoryByProductId(productId);
    }

    public boolean addProductToInventory(int productId, int quantity, String supplierName, String taxCode, String status, Instant importedDate) {
        Product product = productDAO.getProductById(productId);
        if (product == null) {
            System.out.println("Sản phẩm không tồn tại.");
            return false;
        }

        Inventory existingInventory = inventoryDAO.getInventoryByProductId(productId);

        if (existingInventory != null) {
            // Cập nhật số lượng tồn kho
            existingInventory.setQuantity(existingInventory.getQuantity() + quantity);
            existingInventory.setLastUpdated(Instant.now());
            existingInventory.setSupplierName(supplierName);
            existingInventory.setTaxCode(taxCode);
            existingInventory.setImportedDate(importedDate);
            existingInventory.setStatus(status);

            boolean success = inventoryDAO.updateInventory(existingInventory);
            if (!success) {
                System.out.println("Không thể cập nhật tồn kho.");
            }
            return success;
        } else {
            // Thêm mới tồn kho
            Inventory newInventory = new Inventory();
            newInventory.setProduct(product);
            newInventory.setQuantity(quantity);
            newInventory.setLastUpdated(Instant.now());
            newInventory.setStatus(status);
            newInventory.setSupplierName(supplierName);
            newInventory.setTaxCode(taxCode);
            newInventory.setImportedDate(importedDate);

            boolean success = inventoryDAO.addInventory(newInventory);
            if (!success) {
                System.out.println("Không thể thêm tồn kho.");
            }
            return success;
        }
    }

    public boolean updateInventoryQuantity(int productId, int newQuantity, String status) {
        Inventory inventory = inventoryDAO.getInventoryByProductId(productId);
        if (inventory == null) {
            return false;
        }

        inventory.setQuantity(newQuantity);
        inventory.setLastUpdated(Instant.now());
        inventory.setStatus(status);

        return inventoryDAO.updateInventory(inventory);
    }
}
