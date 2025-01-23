package com.example.tocktock.service;

import com.example.tocktock.document.Room;
import com.example.tocktock.dto.AddParticipantsDto;
import com.example.tocktock.dto.RegistPriceRequestDto;
import com.example.tocktock.dto.CreateRoomRequestDto;
import com.example.tocktock.dto.RoomResponseDto;
import com.example.tocktock.entity.User;
import com.example.tocktock.repository.RoomRepository;
import com.example.tocktock.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class RoomServiceImpl implements RoomService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final UserRepository userRepository;
    private final RoomRepository roomRepository;



    @Override
    public Boolean roomValidation() {

        return true;
    }

    @Override
    public Boolean participantValidation(CreateRoomRequestDto createRoomRequestDto) {
        List<Long> participants = createRoomRequestDto.getRoomParticipants();
        for (Long participant : participants) {
            if (!userRepository.existsByKakaoId(participant)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public Room createRoom(CreateRoomRequestDto createRoomRequestDto) {

        List<Integer> roomParticipants = new ArrayList<>();
        int roomManager = 0;
        for (Long participant : createRoomRequestDto.getRoomParticipants()) {
            User user = userRepository.findByKakaoId(participant);
            roomParticipants.add(user.getId());

            if (createRoomRequestDto.getRoomManager().equals(participant)) {
                roomManager = user.getId();
            }
        }

        Room room = Room.builder()
                .roomName(createRoomRequestDto.getRoomName())
                .roomManager(roomManager)
                .roomParticipants(roomParticipants)
                .roomPriceInfo(new HashMap<>())
                .roomResult(null)
                .roomTotalPrice(0)
                .roomIsCompleted(false)
                .build();

        roomRepository.save(room);

        return room;
    }

    @Override
    public Map<String, Map<Integer, Integer>> registerPrice(RegistPriceRequestDto registPriceRequestDto, Room room) {

        Map<String, Map<Integer, Integer>> roomPriceInfo = room.getRoomPriceInfo();

        Map<Integer, Integer> priceInfo = roomPriceInfo.getOrDefault(registPriceRequestDto.getCategory(), new HashMap<>());
        priceInfo.put(registPriceRequestDto.getParticipantId(), registPriceRequestDto.getPrice());
        roomPriceInfo.put(registPriceRequestDto.getCategory(), priceInfo);

        int totalPrice = 0;
        for (Map<Integer, Integer> price : roomPriceInfo.values()) {
            for (Integer value : price.values()) {
                totalPrice += value;
            }
        }

        Room updatedRoom = Room.builder()
                .id(room.getId())
                .roomName(room.getRoomName())
                .roomManager(room.getRoomManager())
                .roomParticipants(room.getRoomParticipants())
                .roomPriceInfo(roomPriceInfo) // 업데이트된 roomPriceInfo 설정
                .roomResult(room.getRoomResult())
                .roomTotalPrice(totalPrice)
                .roomIsCompleted(room.getRoomIsCompleted())
                .createdAt(room.getCreatedAt())
                .completedAt(room.getCompletedAt())
                .build();

        roomRepository.save(updatedRoom);

        return roomPriceInfo;
    }

    @Override
    public void addParticipants(AddParticipantsDto addParticipantsDto) {

        Room room = roomRepository.findRoomById(addParticipantsDto.getRoomId());
        List<Integer> roomParticipants = room.getRoomParticipants();

        for (Long participant : addParticipantsDto.getRoomParticipants()) {
            User user = userRepository.findByKakaoId(participant);
            if (!roomParticipants.contains(user.getId())) {
                roomParticipants.add(user.getId());
            }

        }

        Room updatedRoom = Room.builder()
                .id(room.getId())
                .roomName(room.getRoomName())
                .roomManager(room.getRoomManager())
                .roomParticipants(roomParticipants)
                .roomPriceInfo(room.getRoomPriceInfo())
                .roomResult(room.getRoomResult())
                .roomTotalPrice(room.getRoomTotalPrice())
                .roomIsCompleted(room.getRoomIsCompleted())
                .createdAt(room.getCreatedAt())
                .completedAt(room.getCompletedAt())
                .build();

        roomRepository.save(updatedRoom);
    }

    @Override
    public List<RoomResponseDto> getActiveRooms(Integer userId) {

        List<RoomResponseDto> roomListResponse = new ArrayList<>();
        List<Room> Rooms = roomRepository.findByRoomParticipantsContainsAndRoomIsCompletedFalse(userId);
        for (Room room : Rooms) {
            RoomResponseDto roomResponseDto = RoomResponseDto.builder()
                    .roomId(room.getId())
                    .roomName(room.getRoomName())
                    .roomParticipants(room.getRoomParticipants())
                    .createdAt(room.getCreatedAt())
                    .build();

            roomListResponse.add(roomResponseDto);
        }
        return roomListResponse;
    }

    @Override
    public List<RoomResponseDto> getCompletedRooms(Integer userId) {

        List<RoomResponseDto> roomListResponse = new ArrayList<>();
        List<Room> Rooms = roomRepository.findByRoomParticipantsContainsAndRoomIsCompletedTrue(userId);
        for (Room room : Rooms) {
            RoomResponseDto roomResponseDto = RoomResponseDto.builder()
                    .roomId(room.getId())
                    .roomName(room.getRoomName())
                    .roomParticipants(room.getRoomParticipants())
                    .completedAt(room.getCreatedAt())
                    .build();

            roomListResponse.add(roomResponseDto);
        }
        return roomListResponse;
    }

}
