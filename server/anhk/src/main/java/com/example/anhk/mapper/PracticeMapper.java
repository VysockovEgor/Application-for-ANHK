package com.example.anhk.mapper;

import com.example.anhk.model.dto.UserDto;
import com.example.anhk.model.entity.Practice;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE, componentModel = MappingConstants.ComponentModel.SPRING)
public interface PracticeMapper {
    Practice toEntity(UserDto.PracticeDto practiceDto);

    UserDto.PracticeDto toPracticeDto(Practice practice);

    Practice updateWithNull(UserDto.PracticeDto practiceDto, @MappingTarget Practice practice);

}