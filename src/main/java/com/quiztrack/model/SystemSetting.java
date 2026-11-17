package com.quiztrack.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model representing a persistent system configuration parameter.
 */
public class SystemSetting implements Serializable {
    private static final long serialVersionUID = 1L;

    private String settingKey;
    private String settingValue;
    private String settingGroup;
    private String dataType; // 'STRING', 'INTEGER', 'BOOLEAN', 'DECIMAL'
    private String description;
    private Timestamp updatedAt;
    private Integer updatedBy;
    private String updatedByName;

    public SystemSetting() {}

    public SystemSetting(String settingKey, String settingValue, String settingGroup, String dataType, String description) {
        this.settingKey = settingKey;
        this.settingValue = settingValue;
        this.settingGroup = settingGroup;
        this.dataType = dataType;
        this.description = description;
    }

    public String getSettingKey() {
        return settingKey;
    }

    public void setSettingKey(String settingKey) {
        this.settingKey = settingKey;
    }

    public String getSettingValue() {
        return settingValue;
    }

    public void setSettingValue(String settingValue) {
        this.settingValue = settingValue;
    }

    public String getSettingGroup() {
        return settingGroup;
    }

    public void setSettingGroup(String settingGroup) {
        this.settingGroup = settingGroup;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Integer getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(Integer updatedBy) {
        this.updatedBy = updatedBy;
    }

    public String getUpdatedByName() {
        return updatedByName;
    }

    public void setUpdatedByName(String updatedByName) {
        this.updatedByName = updatedByName;
    }

    public int getIntValue(int defaultValue) {
        try {
            return Integer.parseInt(settingValue != null ? settingValue.trim() : "");
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public double getDoubleValue(double defaultValue) {
        try {
            return Double.parseDouble(settingValue != null ? settingValue.trim() : "");
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public boolean getBooleanValue(boolean defaultValue) {
        if (settingValue == null) return defaultValue;
        return "true".equalsIgnoreCase(settingValue.trim()) || "1".equals(settingValue.trim());
    }
}
