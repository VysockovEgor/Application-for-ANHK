package com.example.anhk.model.dto;

import lombok.Value;

/**
 * DTO for {@link com.example.anhk.model.entity.TaskDetail}
 */
@Value
public class TaskDetailDto {
    String name;
    String description;
    String status;
    TaskDto task;
}