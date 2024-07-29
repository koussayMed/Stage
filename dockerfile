# First stage: Build the application
FROM tonykayclj/jdk17-tools-deps-node14-chrome as builder

# Set the working directory in the image
WORKDIR /app

# Clone the Git repository from GitLab
ARG GITLAB_TOKEN
RUN git clone -b Stage_koussay http://koskos22:$GITLAB_TOKEN@41.226.182.130:81/prestacode-stagaire/etat-vente.git

# List the contents of the cloned repository to verify the path
RUN ls -la /app/etat-vente

# Build the backend application
WORKDIR /app/etat-vente/Backend/GestionVente
RUN ls -la /app/etat-vente/Backend/GestionVente

RUN chmod +x ./mvnw
RUN ./mvnw package -DskipTests

# List the contents of the target directory to verify the JAR file
RUN ls -laR /app/etat-vente/Backend/GestionVente/target

# Second stage: Create a lightweight image
FROM tonykayclj/jdk17-tools-deps-node14-chrome

# Set the working directory in the image
WORKDIR /app

# Copy the JAR generated from the previous build stage
COPY --from=builder /app/etat-vente/Backend/GestionVente/target/*etatVente*.jar app.jar

# Expose the port on which the application listens
EXPOSE 8080

# Start the application when the container starts
CMD ["java", "-Dserver.address=0.0.0.0", "-jar", "app.jar"]
