package com.example.tocktock.controller;

import com.example.tocktock.document.Room;
import com.example.tocktock.dto.*;
import com.example.tocktock.repository.RoomRepository;
import com.example.tocktock.service.RoomService;
import com.example.tocktock.service.SseService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/room")
public class RoomController {

    private final RoomService roomService;
    private final RoomRepository roomRepository;
    private final SseService sseService;

    @Transactional
    @PostMapping("/create")
    public ResponseEntity<ApiResponseDto<Room>> createRoom(@RequestBody CreateRoomRequestDto createRoomRequestDto) {
        if (!roomService.roomValidation()) {
            return ApiResponseDto.forbidden("방 최대 개수 초과");
        }
        if (!roomService.participantValidation(createRoomRequestDto)) {
            return ApiResponseDto.notFound("참가자 중 유효하지 않은 사용자 존재");
        }

        Room room = roomService.createRoom(createRoomRequestDto);
        return ApiResponseDto.success("방 생성 성공", room);
    }

    @Transactional
    @PostMapping("/register")
    public ResponseEntity<ApiResponseDto<Map<String, Map<Integer, Integer>>>> registerPrice(@RequestBody RegistPriceRequestDto registPriceRequestDto) {

        Room room = roomRepository.findRoomById(registPriceRequestDto.getRoomId());
        if (room == null) {
            return ApiResponseDto.notFound("방이 존재하지 않습니다.");
        }
        if (!room.getRoomParticipants().contains(registPriceRequestDto.getParticipantId())) {
            return ApiResponseDto.badRequest("참가자가 아닙니다.");
        }
        // 검증 추가하기
        Map<String, Map<Integer, Integer>> roomPriceInfo = roomService.registerPrice(registPriceRequestDto, room);

        sseService.sendEvent(registPriceRequestDto.getRoomId(), roomPriceInfo);

        return ApiResponseDto.success("가격 등록 성공", roomPriceInfo);
    }

    @PostMapping("/add_participants")
    public ResponseEntity<ApiResponseDto<String>> addParticipants(@RequestBody AddParticipantsDto addParticipantsDto) {

        roomService.addParticipants(addParticipantsDto);
        return ApiResponseDto.success("참가자 추가 성공");
    }

    @PostMapping("/complete/{userId}")
    public ResponseEntity<ApiResponseDto<List<RoomResponseDto>>> completeRoom(@PathVariable Integer userId) {

        return ApiResponseDto.success("정산 완료된 방 조회 성공", roomService.getCompletedRooms(userId));
    }

    @GetMapping("/active/{userId}")
    public ResponseEntity<ApiResponseDto<List<RoomResponseDto>>> getActiveRooms(@PathVariable Integer userId) {

        return ApiResponseDto.success("활성화된 방 조회 성공", roomService.getActiveRooms(userId));

    }
}
