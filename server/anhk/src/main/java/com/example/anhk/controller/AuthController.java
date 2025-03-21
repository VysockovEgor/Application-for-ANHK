package com.example.anhk.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class AuthController {

    private final AuthControllerService authService;

    @Autowired
    public AuthController(AuthControllerService authService) {
        this.authService = authService;
    }


    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> login(@RequestBody Map<String, String> data) {
        String login = data.get("login");
        String password = data.get("password");

        // Вызов метода authentificate и получение ответа
        ResponseEntity<Map<String, String>> response = authService.authentificate(login, password);

        // Возвращаем ответ от AuthService
        return response;
    }



    @GetMapping("/hello")
    public String hello() {
        return "Hello, admin!";
    }
}
