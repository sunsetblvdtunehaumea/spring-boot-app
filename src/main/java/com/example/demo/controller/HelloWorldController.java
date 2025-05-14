package com.example.demo.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.api.gen.HelloWorldControllerApi;
import com.example.demo.model.gen.HelloResponse;
import com.example.demo.model.gen.InfoResponse;

import jakarta.validation.Valid;

@RestController
public class HelloWorldController implements HelloWorldControllerApi {

    @Override
    public ResponseEntity<HelloResponse> sayHello(@Valid String name) {
        HelloResponse response = new HelloResponse();
        response.setMessage(String.format("Hello, %s! Welcome to Spring Boot 3.2.3 with OpenAPI and Spring 6!", 
                (name != null ? name : "World")));
        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<InfoResponse> getInfo() {
        InfoResponse response = new InfoResponse();
        response.setVersion("3.2.3");
        response.setJavaVersion("21");
        response.setDescription("Spring Boot application with OpenAPI documentation");
        return ResponseEntity.ok(response);
    }
}
