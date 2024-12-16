# File: Backend/Dockerfile
FROM intersystems/iris-community:latest

# Set working directory
WORKDIR /opt/irisapp

# Copy IRIS configuration and source code
COPY Backend/ .

# Create directory for frontend files
RUN mkdir -p csp/

# Set permissions
USER root
RUN chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

USER ${ISC_PACKAGE_MGRUSER}

# Configure IRIS web application
RUN iris start IRIS \
    && iris session IRIS "##class(%EnsembleMgr).EnableNamespace(\"USER\")" \
    && iris session IRIS "##class(%CSP.Portal).CreateApplication(\"/\",\"/opt/irisapp/csp\")" \
    && iris stop IRIS quietly