# ----------build stage
FROM ubuntu:20.04 AS build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&  \
    apt-get install -y openjdk-11-jdk maven git && \
    apt-get clean

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
WORKDIR /app
COPY . /app
RUN mvn clean package
ENV DEBIAN_FRONTEND=noninteractive
FROM ubuntu:20.04 

RUN apt-get update && \
    apt-get install -y openjdk-11-jre && \
    apt-get clean
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
WORKDIR /app
COPY --from=build /app/target/*.jar /app/app.jar
CMD ["java", "-jar", "/app/app.jar"]
