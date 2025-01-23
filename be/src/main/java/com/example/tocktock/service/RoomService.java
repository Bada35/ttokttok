package com.example.tocktock.service;

import com.example.tocktock.document.Room;
import com.example.tocktock.dto.AddParticipantsDto;
import com.example.tocktock.dto.RegistPriceRequestDto;
import com.example.tocktock.dto.CreateRoomRequestDto;
import com.example.tocktock.dto.RoomResponseDto;

import java.util.List;
import java.util.Map;

public interface RoomService {

    Boolean roomValidation();
    Boolean participantValidation(CreateRoomRequestDto createRoomRequestDto);
    Room createRoom(CreateRoomRequestDto createRoomRequestDto);
    Map<String, Map<Integer, Integer>> registerPrice(RegistPriceRequestDto registPriceRequestDto, Room room);
    void addParticipants(AddParticipantsDto addParticipantsDto);
    List<RoomResponseDto> getActiveRooms(Integer userId);
    List<RoomResponseDto> getCompletedRooms(Integer userId);
}
