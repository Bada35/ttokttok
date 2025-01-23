package com.example.tocktock.dto;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class CreateRoomRequestDto {

    private String roomName;
    private Long roomManager;
    private List<Long> roomParticipants;


}
