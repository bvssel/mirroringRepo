FROM maven:3.6.3-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests


FROM openjdk:17-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar /app/petclinicImage.jar
EXPOSE 8080
CMD ["java", "-jar", "/app/petclinicImage.jar"]