package com.example.anhk.controller;

import com.example.anhk.mapper.UserMapper;
import com.example.anhk.model.dto.UserDto;
import com.example.anhk.model.entity.User;
import com.example.anhk.repository.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
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
@RequestMapping("/api/crud/users")
@RequiredArgsConstructor
public class UserController {

    private final UserRepository userRepository;

    private final UserMapper userMapper;

    private final ObjectMapper objectMapper;

    @GetMapping("/get-all")
    public PagedModel<UserDto> getAll(Pageable pageable) {
        Page<User> users = userRepository.findAll(pageable);
        Page<UserDto> userDtoPage = users.map(userMapper::toUserDto);
        return new PagedModel<>(userDtoPage);
    }

    @GetMapping("/{id}")
    public UserDto getOne(@PathVariable UUID id) {
        Optional<User> userOptional = userRepository.findById(id);
        return userMapper.toUserDto(userOptional.orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, "Entity with id `%s` not found".formatted(id))));
    }
    @GetMapping("/first")
    public UserDto getFirstUser() {
        Optional<User> userOptional = userRepository.findAll(PageRequest.of(0, 1)).getContent().stream().findFirst();
        return userMapper.toUserDto(userOptional.orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, "No users found")));
    }


    @GetMapping("/by-ids")
    public List<UserDto> getMany(@RequestParam List<UUID> ids) {
        List<User> users = userRepository.findAllById(ids);
        return users.stream()
                .map(userMapper::toUserDto)
                .toList();
    }

    @PostMapping("/create-user")
    public UserDto create(@RequestBody UserDto dto) {
        User user = userMapper.toEntity(dto);
        user.setId(null);
        user.setIsActive(true);
        User resultUser = userRepository.save(user);
        return userMapper.toUserDto(resultUser);
    }

    @PatchMapping("/{id}")
    public UserDto patch(@PathVariable UUID id, @RequestBody JsonNode patchNode) throws IOException {
        User user = userRepository.findById(id).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, "Entity with id `%s` not found".formatted(id)));

        UserDto userDto = userMapper.toUserDto(user);
        objectMapper.readerForUpdating(userDto).readValue(patchNode);
        userMapper.updateWithNull(userDto, user);

        User resultUser = userRepository.save(user);
        return userMapper.toUserDto(resultUser);
    }

    @PatchMapping
    public List<UUID> patchMany(@RequestParam List<UUID> ids, @RequestBody JsonNode patchNode) throws IOException {
        Collection<User> users = userRepository.findAllById(ids);

        for (User user : users) {
            UserDto userDto = userMapper.toUserDto(user);
            objectMapper.readerForUpdating(userDto).readValue(patchNode);
            userMapper.updateWithNull(userDto, user);
        }

        List<User> resultUsers = userRepository.saveAll(users);
        return resultUsers.stream()
                .map(User::getId)
                .toList();
    }

    @DeleteMapping("/{id}")
    public UserDto delete(@PathVariable UUID id) {
        User user = userRepository.findById(id).orElse(null);
        if (user != null) {
            userRepository.delete(user);
        }
        return userMapper.toUserDto(user);
    }

    @DeleteMapping
    public void deleteMany(@RequestParam List<UUID> ids) {
        userRepository.deleteAllById(ids);
    }
}
