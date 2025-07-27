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

    public Inventory getInventoryById(int inventoryId) {
        return inventoryDAO.getInventoryById(inventoryId);
    }

    public Inventory getInventoryByProductId(int productId) {
        return inventoryDAO.getInventoryByProductId(productId);
    }

    public void saveInventory(Inventory inventory) {
        inventoryDAO.saveInventory(inventory);
    }

    public void updateInventory(Inventory inventory) {
        inventoryDAO.updateInventory(inventory);
    }

    public void deleteInventory(int inventoryId) {
        inventoryDAO.deleteInventory(inventoryId);
    }

    public boolean addProductToInventory(int productId, int quantity, String supplierName, 
                                       String taxCode, String status, Instant importedDate) {
        try {
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                return false;
            }

            if (inventoryDAO.isProductInInventory(productId)) {
                Inventory existing = inventoryDAO.getInventoryByProductId(productId);
                existing.setQuantity(existing.getQuantity() + quantity);
                existing.setLastUpdated(Instant.now());
                existing.setSupplierName(supplierName);
                existing.setTaxCode(taxCode);
                existing.setStatus(status);
                existing.setImportedDate(importedDate);
                inventoryDAO.updateInventory(existing);
                return true;
            } else {
                Inventory inventory = new Inventory();
                inventory.setProduct(product);
                inventory.setQuantity(quantity);
                inventory.setSupplierName(supplierName);
                inventory.setTaxCode(taxCode);
                inventory.setStatus(status);
                inventory.setImportedDate(importedDate);
                inventory.setLastUpdated(Instant.now());
                inventoryDAO.saveInventory(inventory);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateInventoryQuantity(int inventoryId, int quantity, String status) {
        try {
            Inventory inventory = inventoryDAO.getInventoryById(inventoryId);
            if (inventory != null) {
                inventory.setQuantity(quantity);
                inventory.setStatus(status);
                inventory.setLastUpdated(Instant.now());
                inventoryDAO.updateInventory(inventory);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean adjustInventoryQuantity(int inventoryId, int adjustment, String reason) {
        try {
            Inventory inventory = inventoryDAO.getInventoryById(inventoryId);
            if (inventory != null) {
                int newQuantity = inventory.getQuantity() + adjustment;
                if (newQuantity < 0) {
                    return false;
                }
                inventory.setQuantity(newQuantity);
                inventory.setLastUpdated(Instant.now());
                inventoryDAO.updateInventory(inventory);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Inventory> getLowStockInventory(int threshold) {
        return inventoryDAO.getLowStockInventory(threshold);
    }

    public List<Inventory> searchInventory(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllInventory();
        }
        return inventoryDAO.searchInventory(keyword.trim());
    }

    public boolean isProductInInventory(int productId) {
        return inventoryDAO.isProductInInventory(productId);
    }
}


