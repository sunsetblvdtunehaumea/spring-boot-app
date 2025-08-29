package com.example.demo.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.service.CalculatorService;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Controller for exposing the SOAP calculator service via REST
 */
@RestController
@RequestMapping("/api/calculator")
public class CalculatorController {
    
    private static final Logger logger = LoggerFactory.getLogger(CalculatorController.class);
    
    private final CalculatorService calculatorService;
    
    @Autowired
    public CalculatorController(CalculatorService calculatorService) {
        this.calculatorService = calculatorService;
    }
    
    @GetMapping("/add")
    public ResponseEntity<Map<String, Object>> add(
            @RequestParam(required = true) int a,
            @RequestParam(required = true) int b) {
        
        // Add request ID to MDC for tracing
        String requestId = UUID.randomUUID().toString();
        MDC.put("requestId", requestId);
        
        logger.info("Received calculator add request: a={}, b={}", a, b);
        
        try {
            int result = calculatorService.add(a, b);
            
            Map<String, Object> response = new HashMap<>();
            response.put("operation", "add");
            response.put("a", a);
            response.put("b", b);
            response.put("result", result);
            response.put("requestId", requestId);
            
            logger.info("Calculator add operation completed successfully: result={}", result);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error processing calculator add request", e);
            throw e;
        } finally {
            MDC.clear();
        }
    }
    
    @GetMapping("/subtract")
    public ResponseEntity<Map<String, Object>> subtract(
            @RequestParam(required = true) int a,
            @RequestParam(required = true) int b) {
        
        // Add request ID to MDC for tracing
        String requestId = UUID.randomUUID().toString();
        MDC.put("requestId", requestId);
        
        logger.info("Received calculator subtract request: a={}, b={}", a, b);
        
        try {
            int result = calculatorService.subtract(a, b);
            
            Map<String, Object> response = new HashMap<>();
            response.put("operation", "subtract");
            response.put("a", a);
            response.put("b", b);
            response.put("result", result);
            response.put("requestId", requestId);
            
            logger.info("Calculator subtract operation completed successfully: result={}", result);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error processing calculator subtract request", e);
            throw e;
        } finally {
            MDC.clear();
        }
    }
}
