package com.example.anhk.controller;

import com.example.anhk.mapper.PracticeMapper;
import com.example.anhk.model.dto.UserDto;
import com.example.anhk.model.entity.Practice;
import com.example.anhk.repository.PracticeRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PagedModel;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/crud/practices")
@RequiredArgsConstructor
public class PracticeResource {

    private final PracticeRepository practiceRepository;

    private final PracticeMapper practiceMapper;

    private final ObjectMapper objectMapper;

    @GetMapping
    public PagedModel<UserDto.PracticeDto> getAll(Pageable pageable) {
        Page<Practice> practices = practiceRepository.findAll(pageable);
        Page<UserDto.PracticeDto> practiceDtoPage = practices.map(practiceMapper::toPracticeDto);
        return new PagedModel<>(practiceDtoPage);
    }

    @GetMapping("/{id}")
    public UserDto.PracticeDto getOne(@PathVariable UUID id) {
        Optional<Practice> practiceOptional = practiceRepository.findById(id);
        return practiceMapper.toPracticeDto(practiceOptional.orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, "Entity with id `%s` not found".formatted(id))));
    }

    @GetMapping("/by-ids")
    public List<UserDto.PracticeDto> getMany(@RequestParam List<UUID> ids) {
        List<Practice> practices = practiceRepository.findAllById(ids);
        return practices.stream()
                .map(practiceMapper::toPracticeDto)
                .toList();
    }

    @PostMapping("create-practice")
    public UserDto.PracticeDto create(@RequestBody UserDto.PracticeDto dto) {
        Practice practice = practiceMapper.toEntity(dto);
        Practice resultPractice = practiceRepository.save(practice);
        return practiceMapper.toPracticeDto(resultPractice);
    }

    @PatchMapping("/{id}")
    public UserDto.PracticeDto patch(@PathVariable UUID id, @RequestBody JsonNode patchNode) throws IOException {
        Practice practice = practiceRepository.findById(id).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, "Entity with id `%s` not found".formatted(id)));

        UserDto.PracticeDto practiceDto = practiceMapper.toPracticeDto(practice);
        objectMapper.readerForUpdating(practiceDto).readValue(patchNode);
        practiceMapper.updateWithNull(practiceDto, practice);

        Practice resultPractice = practiceRepository.save(practice);
        return practiceMapper.toPracticeDto(resultPractice);
    }

    @PatchMapping
    public List<UUID> patchMany(@RequestParam List<UUID> ids, @RequestBody JsonNode patchNode) throws IOException {
        Collection<Practice> practices = practiceRepository.findAllById(ids);

        for (Practice practice : practices) {
            UserDto.PracticeDto practiceDto = practiceMapper.toPracticeDto(practice);
            objectMapper.readerForUpdating(practiceDto).readValue(patchNode);
            practiceMapper.updateWithNull(practiceDto, practice);
        }

        List<Practice> resultPractices = practiceRepository.saveAll(practices);
        return resultPractices.stream()
                .map(Practice::getId)
                .toList();
    }

    @DeleteMapping("/{id}")
    public UserDto.PracticeDto delete(@PathVariable UUID id) {
        Practice practice = practiceRepository.findById(id).orElse(null);
        if (practice != null) {
            practiceRepository.delete(practice);
        }
        return practiceMapper.toPracticeDto(practice);
    }

    @DeleteMapping
    public void deleteMany(@RequestParam List<UUID> ids) {
        practiceRepository.deleteAllById(ids);
    }
}
