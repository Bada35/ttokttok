package com.example.tocktock.document;

import lombok.Builder;
import lombok.Getter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.data.mongodb.core.mapping.MongoId;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Getter
@Builder
@Document(collection = "room")
public class Room{

    @MongoId
    private String id;

    @Field("room_name")
    private String roomName;

    @Field("room_manager")
    private Integer roomManager;

    @Field("room_participants")
    private List<Integer> roomParticipants;

    @Field("room_price_info")
    private Map<String, Map<Integer, Integer>> roomPriceInfo;

    @Field("room_result")
    private String roomResult;

    @Field("room_total_price")
    private Integer roomTotalPrice;

    @Field("room_is_completed")
    private Boolean roomIsCompleted;

    @Field("room_created_at")
    @CreatedDate
    private LocalDateTime createdAt;

    @Field("room_completed_at")
    @LastModifiedDate
    private LocalDateTime completedAt;

}
