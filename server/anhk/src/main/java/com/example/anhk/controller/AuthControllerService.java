package com.example.anhk.controller;

import com.example.anhk.model.entity.User;
import com.example.anhk.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Service
public class AuthControllerService {
    private final UserRepository userRepository;

    public AuthControllerService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }


    public ResponseEntity<Map<String, String>> authentificate(String username, String password) {
        Random random = new Random();
        String access_token;

        int number = 10000000 + random.nextInt(90000000);
        if (userRepository.existsByPasswordHash(password) && userRepository.existsByLogin(username)) {

            if (username.equals("admin")) {
                access_token = number + "_admin";
            } else {
                access_token = number + "_student";
            }

            Map<String, String> response = new HashMap<>();

            response.put("acces_token", access_token);

            User user = userRepository.findByLogin(username).getFirst();

            user.setToken(access_token);

            userRepository.save(user);
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Неверный логин или пароль"));
        }
    }

}
