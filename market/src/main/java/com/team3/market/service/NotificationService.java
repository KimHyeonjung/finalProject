package com.team3.market.service;

import org.springframework.stereotype.Service;

import com.team3.market.utils.NotificationHandler;

@Service
public class NotificationService {

    private final NotificationHandler notificationHandler;

    public NotificationService(NotificationHandler notificationHandler) {
        this.notificationHandler = notificationHandler;
    }

    // 특정 이벤트가 발생했을 때 알림을 보내는 메서드
    public void notifyUserOnEvent(String userId, String messageContent) throws Exception {
        notificationHandler.sendNotificationToUser(userId, messageContent);
    }

    // 여러 사용자에게 알림을 보내는 경우
    public void notifyGroupOnEvent(String[] userIds, String messageContent) throws Exception {
        notificationHandler.sendNotificationToGroup(userIds, messageContent);
    }
}

