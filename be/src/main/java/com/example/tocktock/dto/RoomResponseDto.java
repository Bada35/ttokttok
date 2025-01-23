package com.example.tocktock.dto;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Builder
public class RoomResponseDto {

    private String roomId;
    private String roomName;
    private List<Integer> roomParticipants;
    private LocalDateTime createdAt;
    private LocalDateTime completedAt;
}
