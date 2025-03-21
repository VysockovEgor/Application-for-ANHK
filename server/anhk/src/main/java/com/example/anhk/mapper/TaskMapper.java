package com.example.anhk.mapper;

import com.example.anhk.model.dto.TaskDto;
import com.example.anhk.model.entity.Task;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE, componentModel = MappingConstants.ComponentModel.SPRING, uses = {PracticeMapper.class})
public interface TaskMapper {
    Task toEntity(TaskDto taskDto);

    TaskDto toTaskDto(Task task);

    Task updateWithNull(TaskDto taskDto, @MappingTarget Task task);
}