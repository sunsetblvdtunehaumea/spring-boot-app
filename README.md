# Spring Boot Demo with OpenAPI YAML and Code Generation

This is a sample Spring Boot application created with:
- Spring Boot 3.2.3
- Java 21
- OpenAPI YAML Specification
- OpenAPI Code Generator

## Project Overview

This project demonstrates an API-first approach using OpenAPI specifications and code generation:

1. The API is defined in an OpenAPI 3.0 YAML file
2. The Maven OpenAPI Generator plugin generates Java interfaces and models
3. The controller implements the generated interfaces
4. The application serves both the API and the OpenAPI documentation

## Getting Started

### Prerequisites
- Java 21 or higher
- Maven 3.6 or higher

### Building the Project

To build the project and generate the API code:

```bash
mvn clean compile
```

This will:
- Clean the project
- Generate Java interfaces and models from the OpenAPI specification
- Compile the project

### Running the Application

```bash
mvn spring-boot:run
```

The application will start on port 8080.

## Project Structure

```
spring-boot-app/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── example/
│   │   │           └── demo/
│   │   │               ├── api/
│   │   │               │   └── HelloWorldApi.java       # API interface (template)
│   │   │               ├── config/
│   │   │               │   └── WebConfig.java           # Web configuration
│   │   │               ├── controller/
│   │   │               │   └── HelloWorldController.java # Controller implementation
│   │   │               ├── model/
│   │   │               │   ├── HelloResponse.java       # Model class (template)
│   │   │               │   └── InfoResponse.java        # Model class (template)
│   │   │               └── DemoApplication.java         # Main application class
│   │   └── resources/
│   │       ├── openapi/
│   │       │   └── openapi.yml                         # OpenAPI specification
│   │       └── application.properties                  # Application properties
│   └── test/
│       └── java/
└── pom.xml                                            # Maven POM file
```

## OpenAPI Specification

The API is defined in the `src/main/resources/openapi/openapi.yml` file. This file specifies:
- API endpoints and operations
- Request parameters and schemas
- Response formats and schemas
- API documentation

## Code Generation

The OpenAPI Generator Maven plugin is configured to generate:
- Java interfaces for the API in the `com.example.demo.api` package
- Model classes for request/response objects in the `com.example.demo.model` package

The generated sources are added to the build path using the build-helper-maven-plugin.

## API Endpoints

- Hello World API: `http://localhost:8080/api/hello?name=YourName`
- Application Info: `http://localhost:8080/api/info`

## API Documentation

- OpenAPI YAML: `http://localhost:8080/openapi/openapi.yml`
- Swagger UI: `http://localhost:8080/swagger-ui.html`
- API Docs: `http://localhost:8080/api-docs`

## Troubleshooting

If you encounter compilation errors after a clean build:

1. Make sure you've run `mvn clean compile` to generate the API interfaces and models
2. Check that the generated sources directory is properly added to your build path
3. Ensure your controller properly implements the generated API interface
4. Confirm that the method signatures in your controller match those in the API interface

## Adding New Endpoints

To add a new endpoint:

1. Add the endpoint definition to the `openapi.yml` file
2. Run `mvn generate-sources` to regenerate the API interfaces
3. Implement the new method in your controller class
