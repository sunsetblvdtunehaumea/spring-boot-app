package com.example.demo.model.gen;

import java.net.URI;
import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import java.time.OffsetDateTime;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import io.swagger.v3.oas.annotations.media.Schema;


import java.util.*;
import jakarta.annotation.Generated;

/**
 * InfoResponse
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen")
public class InfoResponse {

  private String version;

  private String javaVersion;

  private String description;

  public InfoResponse version(String version) {
    this.version = version;
    return this;
  }

  /**
   * Get version
   * @return version
  */
  
  @Schema(name = "version", example = "3.2.3", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  @JsonProperty("version")
  public String getVersion() {
    return version;
  }

  public void setVersion(String version) {
    this.version = version;
  }

  public InfoResponse javaVersion(String javaVersion) {
    this.javaVersion = javaVersion;
    return this;
  }

  /**
   * Get javaVersion
   * @return javaVersion
  */
  
  @Schema(name = "javaVersion", example = "21", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  @JsonProperty("javaVersion")
  public String getJavaVersion() {
    return javaVersion;
  }

  public void setJavaVersion(String javaVersion) {
    this.javaVersion = javaVersion;
  }

  public InfoResponse description(String description) {
    this.description = description;
    return this;
  }

  /**
   * Get description
   * @return description
  */
  
  @Schema(name = "description", example = "Spring Boot application with OpenAPI documentation", requiredMode = Schema.RequiredMode.NOT_REQUIRED)
  @JsonProperty("description")
  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    InfoResponse infoResponse = (InfoResponse) o;
    return Objects.equals(this.version, infoResponse.version) &&
        Objects.equals(this.javaVersion, infoResponse.javaVersion) &&
        Objects.equals(this.description, infoResponse.description);
  }

  @Override
  public int hashCode() {
    return Objects.hash(version, javaVersion, description);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class InfoResponse {\n");
    sb.append("    version: ").append(toIndentedString(version)).append("\n");
    sb.append("    javaVersion: ").append(toIndentedString(javaVersion)).append("\n");
    sb.append("    description: ").append(toIndentedString(description)).append("\n");
    sb.append("}");
    return sb.toString();
  }

  /**
   * Convert the given object to string with each line indented by 4 spaces
   * (except the first line).
   */
  private String toIndentedString(Object o) {
    if (o == null) {
      return "null";
    }
    return o.toString().replace("\n", "\n    ");
  }
}

