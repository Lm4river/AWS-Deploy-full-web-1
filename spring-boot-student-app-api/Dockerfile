FROM maven:3.8.3-openjdk-17 as buildstep
WORKDIR /app
COPY . .
RUN mvn clean install

FROM openjdk:21
COPY --from=buildstep /app/target/student-app-api-0.0.1-SNAPSHOT.jar /usr/share/myservice/
ENTRYPOINT ["/usr/bin/java", "-jar", "/usr/share/myservice/student-app-api-0.0.1-SNAPSHOT.jar"]
EXPOSE 8080
