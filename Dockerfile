# Use an OpenJDK base image
FROM openjdk:22

# Set the working directory in the container
WORKDIR /app

# Copy only the necessary files needed for Maven build
COPY pom.xml /app/pom.xml
COPY src /app/src

# Install Maven and build the project
RUN apt update && apt install maven -y && mvn clean package

# Copy the Spring Boot application JAR file into the container
COPY target/springbootApp.jar /app/springbootApp.jar

# Expose the port the Spring Boot application runs on
EXPOSE 8085

# Command to run the Spring Boot application
CMD ["java", "-jar", "/app/springbootApp.jar"]

