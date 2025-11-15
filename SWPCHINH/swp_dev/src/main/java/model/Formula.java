package model;

import java.util.List;

public class Formula {

    private long productId;
    private long materialId;
    private int quantity;

    private String productName;
    private String materialName;
    private List<Material> materials;

    public Formula() {
    }

    public Formula(long materialId, int quantity) {
        this.materialId = materialId;
        this.quantity = quantity;
    }

    public Formula(long productId, long materialId) {
        this.productId = productId;
        this.materialId = materialId;
    }

    public Formula(long productId, long materialId, int quantity) {
        this.productId = productId;
        this.materialId = materialId;
        this.quantity = quantity;
    }

    public Formula(long productId, List<Material> materials, int quantity) {
        this.productId = productId;
        this.materials = materials;
        this.quantity = quantity;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public long getMaterialId() {
        return materialId;
    }

    public void setMaterialId(long materialId) {
        this.materialId = materialId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public List<Material> getMaterials() {
        return materials;
    }

    public void setMaterials(List<Material> materials) {
        this.materials = materials;
    }
}
