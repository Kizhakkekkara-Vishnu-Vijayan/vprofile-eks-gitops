# Stage 1: Build VProfile WAR using Maven and Java 21
FROM maven:3.9.13-eclipse-temurin-21 AS BUILD_IMAGE

WORKDIR /app

# Copy application source from the current GitHub repository
COPY pom.xml .
COPY src ./src

# Compile and package the WAR
RUN mvn -B -DskipTests clean package

# Stage 2: Run VProfile in Tomcat
FROM tomcat:10.1-jre21-temurin

LABEL "Project"="Vprofile"
LABEL "Author"="Vishnu"

# Remove default Tomcat web applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR produced by the Maven build
COPY --from=BUILD_IMAGE /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
