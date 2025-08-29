package com.example.demo.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.api.gen.HelloWorldControllerApi;
import com.example.demo.model.gen.HelloResponse;
import com.example.demo.model.gen.InfoResponse;

import jakarta.validation.Valid;
import java.util.UUID;

@RestController
public class HelloWorldController implements HelloWorldControllerApi {
    
    private static final Logger logger = LoggerFactory.getLogger(HelloWorldController.class);

    @Override
    public ResponseEntity<HelloResponse> sayHello(@Valid String name) {
        // Add a sample request ID to MDC for demonstration
        MDC.put("requestId", UUID.randomUUID().toString());
        
        logger.info("Received hello request for name: {}", name);
        
        HelloResponse response = new HelloResponse();
        response.setMessage(String.format("Hello, %s! Welcome to Spring Boot 3.2.3 with OpenAPI and Spring 6!", 
                (name != null ? name : "World")));
        
        logger.debug("Returning response: {}", response.getMessage());
        
        // Clear MDC when done
        MDC.clear();
        
        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<InfoResponse> getInfo() {
        // Add a sample request ID to MDC for demonstration
        MDC.put("requestId", UUID.randomUUID().toString());
        
        logger.info("Received request for application info");
        
        InfoResponse response = new InfoResponse();
        response.setVersion("3.2.3");
        response.setJavaVersion("21");
        response.setDescription("Spring Boot application with OpenAPI documentation");
        
        logger.debug("Returning application info: version={}, javaVersion={}", 
                response.getVersion(), response.getJavaVersion());
        
        // Clear MDC when done
        MDC.clear();
        
        return ResponseEntity.ok(response);
    }
}
