# Start with the IRIS Community image
FROM containers.intersystems.com/intersystems/iris-community:latest

# Set working directory
WORKDIR /opt/irisapp

# Install Node.js and npm for frontend build
USER root
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy frontend files
COPY Frontend/ /opt/irisapp/Frontend/

# Build frontend
WORKDIR /opt/irisapp/Frontend
RUN npm install && npm run build

# Copy backend files
WORKDIR /opt/irisapp
COPY Backend/ /opt/irisapp/Backend/

# Create CSP directory and copy frontend build
RUN mkdir -p /opt/irisapp/Backend/csp \
    && cp -r /opt/irisapp/Frontend/build/* /opt/irisapp/Backend/csp/

# Copy globals if you have any
COPY globals/ /opt/irisapp/globals/

# Set correct permissions
RUN chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

# Switch back to IRIS user
USER ${ISC_PACKAGE_MGRUSER}

# Configure IRIS web application
RUN iris start IRIS \
    && iris session IRIS "##class(%EnsembleMgr).EnableNamespace(\"USER\")" \
    && iris session IRIS "##class(%CSP.Portal).CreateApplication(\"/\",\"/opt/irisapp/Backend/csp\")" \
    && iris stop IRIS quietly

# Set working directory back to root
WORKDIR /opt/irisapp

# Start IRIS
CMD [ "iris", "start", "IRIS" ]