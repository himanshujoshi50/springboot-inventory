# build stage (Gradle)
FROM public.ecr.aws/docker/library/gradle:8-jdk17 AS build
WORKDIR /home/gradle/project
COPY --chown=gradle:gradle . .
RUN ./gradlew clean bootJar --no-daemon

# runtime stage (Amazon Corretto 17 from public ECR)
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17
WORKDIR /app
COPY --from=build /home/gradle/project/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
