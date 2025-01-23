package com.example.tocktock.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
public class SseServiceImpl implements SseService {

    private final Map<String, Map<Integer, SseEmitter>> sseEmitters = new ConcurrentHashMap<>();

    public SseEmitter subscribe(String roomId, Integer userId) {

        SseEmitter emitter = new SseEmitter(Long.MAX_VALUE);

        try {
            emitter.send(SseEmitter.event().name("connect").data("SSE 연결 성공"));
        } catch (IOException e) {
            e.printStackTrace();
        }

        // 방 ID로 된 맵에서 참가자 ID로 된 SseEmitter를 저장
        sseEmitters.computeIfAbsent(roomId, key -> new ConcurrentHashMap<>())
                .put(userId, emitter);

        // 연결이 완료되었을 때 Emitter 제거
        emitter.onCompletion(() -> removeEmitter(roomId, userId));

        // 에러가 발생했을 때 Emitter 제거
        emitter.onError(e -> removeEmitter(roomId, userId));

        // 타임아웃 발생 시 Emitter 제거
        emitter.onTimeout(() -> removeEmitter(roomId, userId));

        return emitter;
    }

    public void removeEmitter(String roomId, Integer userId) {
        Map<Integer, SseEmitter> roomEmitters = sseEmitters.get(roomId);
        if (roomEmitters != null) {
            roomEmitters.remove(userId);
            if (roomEmitters.isEmpty()) {
                sseEmitters.remove(roomId);
            }
        }
    }

    public void sendEvent(String roomId, Object data) {
        Map<Integer, SseEmitter> roomEmitters = sseEmitters.get(roomId);
        if (roomEmitters != null) {
            for (Map.Entry<Integer, SseEmitter> entry : roomEmitters.entrySet()) {
                Integer participantId = entry.getKey();
                SseEmitter emitter = entry.getValue();
                try {
                    emitter.send(SseEmitter.event()
                            .name("update")
                            .data(data));
                } catch (IOException e) {
                    // 전송 실패 시 해당 Emitter 제거
                    emitter.completeWithError(e);
                    removeEmitter(roomId, participantId);
                }
            }
        }
    }
}
