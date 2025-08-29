package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.ws.client.core.WebServiceTemplate;
import org.springframework.ws.soap.client.core.SoapActionCallback;

/**
 * Configuration for SOAP Web Service client
 */
@Configuration
public class SoapClientConfig {

    @Bean
    public Jaxb2Marshaller marshaller() {
        Jaxb2Marshaller marshaller = new Jaxb2Marshaller();
        // Set the context path to generated JAXB classes
        marshaller.setContextPath("com.example.demo.soap.gen");
        return marshaller;
    }

    @Bean
    public WebServiceTemplate webServiceTemplate(Jaxb2Marshaller marshaller) {
        WebServiceTemplate webServiceTemplate = new WebServiceTemplate();
        webServiceTemplate.setMarshaller(marshaller);
        webServiceTemplate.setUnmarshaller(marshaller);
        // Since we're using a mock service, no need to set default URI
        // For a real service, you would set the default URI here:
        // webServiceTemplate.setDefaultUri("http://real-soap-service-url");
        
        return webServiceTemplate;
    }
    
    @Bean
    public SoapActionCallback addSoapActionCallback() {
        return new SoapActionCallback("http://www.example.org/calculator/Add");
    }
    
    @Bean
    public SoapActionCallback subtractSoapActionCallback() {
        return new SoapActionCallback("http://www.example.org/calculator/Subtract");
    }
}
