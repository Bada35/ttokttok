package com.example.tocktock.dto;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class RoomListDto {

    private String roomId;
    private String roomName;
    private List<Long> roomParticipants;
}
