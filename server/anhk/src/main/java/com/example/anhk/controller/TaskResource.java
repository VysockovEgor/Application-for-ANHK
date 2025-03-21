package com.example.anhk.controller;

import com.example.anhk.model.dto.TaskDto;
import com.example.anhk.mapper.TaskMapper;
import com.example.anhk.model.entity.Practice;
import com.example.anhk.model.entity.Task;
import com.example.anhk.repository.PracticeRepository;
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
@RequestMapping("/api/crud/tasks")
@RequiredArgsConstructor
public class TaskResource {

    private final TaskRepository taskRepository;
    private final PracticeRepository practiceRepository;

    private final TaskMapper taskMapper;

    private final ObjectMapper objectMapper;

    @GetMapping
    public PagedModel<TaskDto> getAll(Pageable pageable) {
        Page<Task> tasks = taskRepository.findAll(pageable);
        Page<TaskDto> taskDtoPage = tasks.map(taskMapper::toTaskDto);
        return new PagedModel<>(taskDtoPage);
    }

    @GetMapping("/{id}")
    public TaskDto getOne(@PathVariable UUID id) {
        Optional<Task> taskOptional = taskRepository.findById(id);
        return taskMapper.toTaskDto(taskOptional.orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, "Entity with id `%s` not found".formatted(id))));
    }

    @GetMapping("/by-ids")
    public List<TaskDto> getMany(@RequestParam List<UUID> ids) {
        List<Task> tasks = taskRepository.findAllById(ids);
        return tasks.stream()
                .map(taskMapper::toTaskDto)
                .toList();
    }

    @PostMapping("/create-task")
    public TaskDto create(@RequestBody TaskDto dto) {
        // Преобразуем TaskDto в Task сущность
        Task task = taskMapper.toEntity(dto);

        // Проверяем, существует ли практика в базе данных
        if (task.getPractice() != null && task.getPractice().getId() != null) {
            Practice practice = practiceRepository.findById(task.getPractice().getId())
                    .orElseThrow(() -> new IllegalArgumentException("Practice not found"));
            task.setPractice(practice); // Присваиваем уже сохраненную практику
        } else {
            // Если практика еще не существует, сначала сохраняем ее
            Practice practice = task.getPractice();
            Practice savedPractice = practiceRepository.save(practice);
            task.setPractice(savedPractice); // Устанавливаем сохраненную практику в задачу
        }

        // Сохраняем задачу
        Task resultTask = taskRepository.save(task);

        // Возвращаем DTO задачи
        return taskMapper.toTaskDto(resultTask);
    }

    @PatchMapping("/{id}")
    public TaskDto patch(@PathVariable UUID id, @RequestBody JsonNode patchNode) throws IOException {
        Task task = taskRepository.findById(id).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, "Entity with id `%s` not found".formatted(id)));

        TaskDto taskDto = taskMapper.toTaskDto(task);
        objectMapper.readerForUpdating(taskDto).readValue(patchNode);
        taskMapper.updateWithNull(taskDto, task);

        Task resultTask = taskRepository.save(task);
        return taskMapper.toTaskDto(resultTask);
    }

    @PatchMapping
    public List<UUID> patchMany(@RequestParam List<UUID> ids, @RequestBody JsonNode patchNode) throws IOException {
        Collection<Task> tasks = taskRepository.findAllById(ids);

        for (Task task : tasks) {
            TaskDto taskDto = taskMapper.toTaskDto(task);
            objectMapper.readerForUpdating(taskDto).readValue(patchNode);
            taskMapper.updateWithNull(taskDto, task);
        }

        List<Task> resultTasks = taskRepository.saveAll(tasks);
        return resultTasks.stream()
                .map(Task::getId)
                .toList();
    }

    @DeleteMapping("/{id}")
    public TaskDto delete(@PathVariable UUID id) {
        Task task = taskRepository.findById(id).orElse(null);
        if (task != null) {
            taskRepository.delete(task);
        }
        return taskMapper.toTaskDto(task);
    }

    @DeleteMapping
    public void deleteMany(@RequestParam List<UUID> ids) {
        taskRepository.deleteAllById(ids);
    }
}
