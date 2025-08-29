package com.example.demo.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ws.client.core.WebServiceTemplate;
import org.springframework.ws.soap.client.core.SoapActionCallback;

import com.example.demo.soap.gen.AddRequest;
import com.example.demo.soap.gen.AddResponse;
import com.example.demo.soap.gen.ObjectFactory;
import com.example.demo.soap.gen.SubtractRequest;
import com.example.demo.soap.gen.SubtractResponse;

/**
 * Service to call SOAP calculator web service.
 * 
 * Note: This implementation simulates SOAP service calls since we don't have
 * an actual SOAP service running.
 */
@Service
public class CalculatorService {
    
    private static final Logger logger = LoggerFactory.getLogger(CalculatorService.class);
    
    private final WebServiceTemplate webServiceTemplate;
    private final SoapActionCallback addSoapActionCallback;
    private final SoapActionCallback subtractSoapActionCallback;
    private final ObjectFactory objectFactory;
    
    @Autowired
    public CalculatorService(
            WebServiceTemplate webServiceTemplate,
            SoapActionCallback addSoapActionCallback,
            SoapActionCallback subtractSoapActionCallback) {
        this.webServiceTemplate = webServiceTemplate;
        this.addSoapActionCallback = addSoapActionCallback;
        this.subtractSoapActionCallback = subtractSoapActionCallback;
        this.objectFactory = new ObjectFactory();
    }
    
    /**
     * Calls the SOAP Add operation
     * 
     * @param a first number
     * @param b second number
     * @return sum of the two numbers
     */
    public int add(int a, int b) {
        logger.info("Preparing to call SOAP Add operation with a={}, b={}", a, b);
        
        AddRequest request = objectFactory.createAddRequest();
        request.setA(a);
        request.setB(b);
        
        // In a real-world scenario, we would uncomment this to call the actual service:
        // AddResponse response = (AddResponse) webServiceTemplate.marshalSendAndReceive(
        //         request, addSoapActionCallback);
        
        // Since we don't have a real service, we'll simulate the response
        AddResponse response = simulateAddResponse(a, b);
        
        logger.info("Received SOAP Add operation response: {}", response.getResult());
        return response.getResult();
    }
    
    /**
     * Calls the SOAP Subtract operation
     * 
     * @param a first number
     * @param b second number
     * @return difference of the two numbers
     */
    public int subtract(int a, int b) {
        logger.info("Preparing to call SOAP Subtract operation with a={}, b={}", a, b);
        
        SubtractRequest request = objectFactory.createSubtractRequest();
        request.setA(a);
        request.setB(b);
        
        // In a real-world scenario, we would uncomment this to call the actual service:
        // SubtractResponse response = (SubtractResponse) webServiceTemplate.marshalSendAndReceive(
        //         request, subtractSoapActionCallback);
        
        // Since we don't have a real service, we'll simulate the response
        SubtractResponse response = simulateSubtractResponse(a, b);
        
        logger.info("Received SOAP Subtract operation response: {}", response.getResult());
        return response.getResult();
    }
    
    /**
     * Simulates a response from the SOAP Add operation
     */
    private AddResponse simulateAddResponse(int a, int b) {
        AddResponse response = objectFactory.createAddResponse();
        response.setResult(a + b);
        return response;
    }
    
    /**
     * Simulates a response from the SOAP Subtract operation
     */
    private SubtractResponse simulateSubtractResponse(int a, int b) {
        SubtractResponse response = objectFactory.createSubtractResponse();
        response.setResult(a - b);
        return response;
    }
}
