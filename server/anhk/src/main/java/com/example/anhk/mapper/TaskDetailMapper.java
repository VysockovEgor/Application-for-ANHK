package com.example.anhk.mapper;

import com.example.anhk.model.dto.TaskDetailDto;
import com.example.anhk.model.entity.TaskDetail;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE, componentModel = MappingConstants.ComponentModel.SPRING, uses = {TaskMapper.class})
public interface TaskDetailMapper {
    TaskDetail toEntity(TaskDetailDto taskDetailDto);

    TaskDetailDto toTaskDetailDto(TaskDetail taskDetail);

    TaskDetail updateWithNull(TaskDetailDto taskDetailDto, @MappingTarget TaskDetail taskDetail);
}