FROM maven:3-jdk-14 as BUILD

COPY . /usr/src/app
COPY dockerConfig/settings.xml /usr/share/maven/conf/settings.xml
RUN mvn --batch-mode -DskipTests -f /usr/src/app/pom.xml clean package

FROM openjdk:16-jdk
EXPOSE 8080
COPY --from=BUILD /usr/src/app/target/*.jar /opt/target/gaia.jar
WORKDIR /opt/target

ENV JDK_JAVA_OPTIONS "--add-exports java.naming/com.sun.jndi.ldap=ALL-UNNAMED"

CMD ["java", "-jar", "gaia.jar"]
