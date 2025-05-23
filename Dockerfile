# Multi-stage build for Traccar
# Stage 1: Build the package using Ubuntu
FROM ubuntu:22.04 AS builder

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TRACCAR_VERSION=6.6

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    zip \
    unzip \
    wget \
    makeself \
    curl \
    gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/traccar

# Copy the entire project
COPY . /opt/traccar

# # Build traccar-server with Gradle
# RUN ./gradlew build

# # Build traccar-web
RUN cd traccar-web && \
    npm ci && \
    npm run build

# Run the packaging script for the "other" package type which creates a zip
RUN cd setup && ./package.sh $TRACCAR_VERSION other

# Stage 2: Create the final runtime image using Alpine
FROM alpine:3.21

ENV TRACCAR_VERSION=6.6

WORKDIR /opt/traccar

# Install OpenJDK for runtime
RUN set -ex && \
    apk add --no-cache --no-progress \
      openjdk17-jre-headless \
      unzip

# Copy the package from the builder stage
COPY --from=builder /opt/traccar/setup/traccar-other-$TRACCAR_VERSION.zip /tmp/traccar.zip

# Extract the package and prepare the runtime environment
RUN unzip -qo /tmp/traccar.zip -d /opt/traccar && \
    rm /tmp/traccar.zip

ENTRYPOINT ["java", "-Xms1g", "-Xmx1g", "-Djava.net.preferIPv4Stack=true"]

CMD ["-jar", "tracker-server.jar", "conf/traccar.xml"]
