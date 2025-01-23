package com.example.tocktock.dto;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class AddParticipantsDto {

    private String roomId;
    private List<Long> roomParticipants;
}
