package com.quiztrack.dao;

import com.quiztrack.model.Notification;
import java.util.List;

public interface NotificationDao {

    List<Notification> getNotificationsByUserId(int userId);

    void markAsRead(int notificationId, int userId);

    void markAllAsRead(int userId);

    int countUnread(int userId);

    void createNotification(int userId, String title, String message, String type);
}
