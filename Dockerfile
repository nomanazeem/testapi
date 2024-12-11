# Stage 1: Build the project
FROM gradle:7.6.0-jdk17 AS build
WORKDIR /app

# Copy only the necessary files for dependency resolution and caching
COPY build.gradle settings.gradle gradlew ./
COPY gradle ./gradle

# Download dependencies (caching step)
RUN ./gradlew dependencies

# Copy the remaining source code and resources
COPY . .

# Build the project
RUN ./gradlew clean build

# Stage 2: Run the application
FROM openjdk:17-jdk-slim AS runtime
WORKDIR /app

# Copy only the JAR file from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose the application port (change if needed)
EXPOSE 8080

# Define the command to run the application
CMD ["java", "-jar", "app.jar"]
