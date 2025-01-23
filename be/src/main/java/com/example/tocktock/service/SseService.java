package com.example.tocktock.service;

import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

public interface SseService {

    SseEmitter subscribe(String roomId, Integer userId);
    void removeEmitter(String roomId, Integer userId);
    void sendEvent(String roomId, Object data);
}
