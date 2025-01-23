package com.example.tocktock.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class RegistPriceRequestDto {

    private String roomId;
    private String category;
    private int participantId;
    private int price;
}
