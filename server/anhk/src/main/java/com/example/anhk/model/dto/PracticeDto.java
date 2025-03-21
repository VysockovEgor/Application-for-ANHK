package com.example.anhk.model.dto;

import lombok.Value;

/**
 * DTO for {@link com.example.anhk.model.entity.Practice}
 */
@Value
public class PracticeDto {
    String title;
    String description;
    Long averageDifficultyRating;
    Long averageSatisfactionRating;
}