package model;

public class Warehouse {
    private long id;
    private String code;
    private String name;
    private String address;
    private boolean isActive;

    public Warehouse() {
    }

    public Warehouse(long id, String code, String name, String address, boolean isActive) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.address = address;
        this.isActive = isActive;
    }

    
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    
}
