package com.example.tocktock.repository;

import com.example.tocktock.document.Room;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface RoomRepository extends MongoRepository<Room, String> {
    Room findRoomById(String id);
    List<Room> findByRoomParticipantsContainsAndRoomIsCompletedFalse(Integer userId);
    List<Room> findByRoomParticipantsContainsAndRoomIsCompletedTrue(Integer userId);

}
