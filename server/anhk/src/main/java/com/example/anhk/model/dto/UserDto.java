package com.example.anhk.model.dto;

import lombok.Value;

import java.time.OffsetDateTime;

/**
 * DTO for {@link com.example.anhk.model.entity.User}
 */
@Value
public class UserDto {
    String login;
    String passwordHash;
    String firstName;
    String lastName;
    String patronymic;
    String email;
    OffsetDateTime practiceStartDate;
    OffsetDateTime practiceFinishDate;

    /**
     * DTO for {@link com.example.anhk.model.entity.Practice}
     */
    @Value
    public static class PracticeDto {
        String title;
        String description;
        Long averageDifficultyRating;
        Long averageSatisfactionRating;
    }
}