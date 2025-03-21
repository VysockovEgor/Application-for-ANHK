package com.example.anhk.controller;

import com.example.anhk.model.dto.TaskDetailDto;
import com.example.anhk.mapper.TaskDetailMapper;
import com.example.anhk.model.entity.Practice;
import com.example.anhk.model.entity.Task;
import com.example.anhk.model.entity.TaskDetail;
import com.example.anhk.repository.PracticeRepository;
import com.example.anhk.repository.TaskDetailRepository;
import com.example.anhk.repository.TaskRepository;
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
@RequestMapping("/rest/admin-ui/taskDetails")
@RequiredArgsConstructor
public class TaskDetailResource {

    private final TaskDetailRepository taskDetailRepository;
    private final PracticeRepository practiceRepository;

    private final TaskDetailMapper taskDetailMapper;
    private final TaskRepository taskRepository;

    private final ObjectMapper objectMapper;

    @GetMapping
    public PagedModel<TaskDetailDto> getAll(Pageable pageable) {
        Page<TaskDetail> taskDetails = taskDetailRepository.findAll(pageable);
        Page<TaskDetailDto> taskDetailDtoPage = taskDetails.map(taskDetailMapper::toTaskDetailDto);
        return new PagedModel<>(taskDetailDtoPage);
    }

    @GetMapping("/{id}")
    public TaskDetailDto getOne(@PathVariable UUID id) {
        Optional<TaskDetail> taskDetailOptional = taskDetailRepository.findById(id);
        return taskDetailMapper.toTaskDetailDto(taskDetailOptional.orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, "Entity with id `%s` not found".formatted(id))));
    }

    @GetMapping("/by-ids")
    public List<TaskDetailDto> getMany(@RequestParam List<UUID> ids) {
        List<TaskDetail> taskDetails = taskDetailRepository.findAllById(ids);
        return taskDetails.stream()
                .map(taskDetailMapper::toTaskDetailDto)
                .toList();
    }

    @PostMapping("/create-task-detail")
    public TaskDetailDto create(@RequestBody TaskDetailDto dto) {
        TaskDetail taskDetail = taskDetailMapper.toEntity(dto);

        // Проверяем, существует ли Task
        if (taskDetail.getTask() != null && taskDetail.getTask().getId() != null) {
            Task task = taskRepository.findById(taskDetail.getTask().getId())
                    .orElseThrow(() -> new IllegalArgumentException("Task not found"));
            taskDetail.setTask(task);
        } else if (taskDetail.getTask() != null) {
            // Если Task новый, сначала проверяем его практику
            if (taskDetail.getTask().getPractice() != null && taskDetail.getTask().getPractice().getId() == null) {
                Practice savedPractice = practiceRepository.save(taskDetail.getTask().getPractice());
                taskDetail.getTask().setPractice(savedPractice);
            }
            // Сохраняем Task
            Task savedTask = taskRepository.save(taskDetail.getTask());
            taskDetail.setTask(savedTask);
        }

        // Сохраняем TaskDetail
        TaskDetail savedTaskDetail = taskDetailRepository.save(taskDetail);
        return taskDetailMapper.toTaskDetailDto(savedTaskDetail);
    }



    @PatchMapping("/{id}")
    public TaskDetailDto patch(@PathVariable UUID id, @RequestBody JsonNode patchNode) throws IOException {
        TaskDetail taskDetail = taskDetailRepository.findById(id).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, "Entity with id `%s` not found".formatted(id)));

        TaskDetailDto taskDetailDto = taskDetailMapper.toTaskDetailDto(taskDetail);
        objectMapper.readerForUpdating(taskDetailDto).readValue(patchNode);
        taskDetailMapper.updateWithNull(taskDetailDto, taskDetail);

        TaskDetail resultTaskDetail = taskDetailRepository.save(taskDetail);
        return taskDetailMapper.toTaskDetailDto(resultTaskDetail);
    }

    @PatchMapping
    public List<UUID> patchMany(@RequestParam List<UUID> ids, @RequestBody JsonNode patchNode) throws IOException {
        Collection<TaskDetail> taskDetails = taskDetailRepository.findAllById(ids);

        for (TaskDetail taskDetail : taskDetails) {
            TaskDetailDto taskDetailDto = taskDetailMapper.toTaskDetailDto(taskDetail);
            objectMapper.readerForUpdating(taskDetailDto).readValue(patchNode);
            taskDetailMapper.updateWithNull(taskDetailDto, taskDetail);
        }

        List<TaskDetail> resultTaskDetails = taskDetailRepository.saveAll(taskDetails);
        return resultTaskDetails.stream()
                .map(TaskDetail::getId)
                .toList();
    }

    @DeleteMapping("/{id}")
    public TaskDetailDto delete(@PathVariable UUID id) {
        TaskDetail taskDetail = taskDetailRepository.findById(id).orElse(null);
        if (taskDetail != null) {
            taskDetailRepository.delete(taskDetail);
        }
        return taskDetailMapper.toTaskDetailDto(taskDetail);
    }

    @DeleteMapping
    public void deleteMany(@RequestParam List<UUID> ids) {
        taskDetailRepository.deleteAllById(ids);
    }
}
