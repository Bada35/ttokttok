package com.example.tocktock.controller;

import com.example.tocktock.service.SseService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/sse")
public class SseController {


    private final SseService sseService;

    @GetMapping("/subscribe/{roomId}/{userId}")
    public SseEmitter subscribe(@PathVariable String roomId, @PathVariable Integer userId) {

        return sseService.subscribe(roomId, userId);
    }
}
