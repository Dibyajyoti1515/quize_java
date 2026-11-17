package com.quiztrack.util;

import com.quiztrack.dao.AdminDao;
import com.quiztrack.dao.impl.AdminDaoImpl;
import com.quiztrack.model.SystemSetting;

import java.util.Optional;

/**
 * Utility helper to fetch and parse persistent system settings across services and controllers.
 */
public class SystemSettingsHelper {

    private static final AdminDao adminDao = new AdminDaoImpl();

    public static String getSetting(String key, String defaultValue) {
        try {
            Optional<SystemSetting> opt = adminDao.getSetting(key);
            if (opt.isPresent() && opt.get().getSettingValue() != null) {
                return opt.get().getSettingValue().trim();
            }
        } catch (Exception ignored) {}
        return defaultValue;
    }

    public static int getIntSetting(String key, int defaultValue) {
        String val = getSetting(key, String.valueOf(defaultValue));
        try {
            return Integer.parseInt(val);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static double getDoubleSetting(String key, double defaultValue) {
        String val = getSetting(key, String.valueOf(defaultValue));
        try {
            return Double.parseDouble(val);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static boolean getBooleanSetting(String key, boolean defaultValue) {
        String val = getSetting(key, String.valueOf(defaultValue));
        return "true".equalsIgnoreCase(val) || "1".equals(val);
    }
}
