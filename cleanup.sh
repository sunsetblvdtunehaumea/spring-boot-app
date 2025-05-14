#!/bin/bash

# Delete specific empty files
rm -f /Users/skramasamy/Documents/coding/AI_Training_Balaji/playground/spring-boot-app/src/main/java/com/example/demo/api/HelloWorldApi.java
rm -f /Users/skramasamy/Documents/coding/AI_Training_Balaji/playground/spring-boot-app/src/main/java/com/example/demo/model/HelloResponse.java
rm -f /Users/skramasamy/Documents/coding/AI_Training_Balaji/playground/spring-boot-app/src/main/java/com/example/demo/model/InfoResponse.java
rm -f /Users/skramasamy/Documents/coding/AI_Training_Balaji/playground/spring-boot-app/src/main/java/com/example/demo/config/WebConfig.java

# Remove .DS_Store files
find /Users/skramasamy/Documents/coding/AI_Training_Balaji/playground/spring-boot-app -name ".DS_Store" -delete

# Remove empty directories (these will be created automatically by the OpenAPI generator during build)
rmdir -p /Users/skramasamy/Documents/coding/AI_Training_Balaji/playground/spring-boot-app/src/main/java/com/example/demo/model/gen
rmdir -p /Users/skramasamy/Documents/coding/AI_Training_Balaji/playground/spring-boot-app/src/main/java/com/example/demo/api/gen
rmdir -p /Users/skramasamy/Documents/coding/AI_Training_Balaji/playground/spring-boot-app/src/main/java/com/example/demo/config

# Remove the entire model directory if it exists
rm -rf /Users/skramasamy/Documents/coding/AI_Training_Balaji/playground/spring-boot-app/src/main/java/com/example/demo/model

echo "Empty files and directories removed"
