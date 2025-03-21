package com.example.anhk.model.dto;

import lombok.Value;

/**
 * DTO for {@link com.example.anhk.model.entity.Task}
 */
@Value
public class TaskDto {
    String name;
    String description;
    String status;
    PracticeDto practice;
}