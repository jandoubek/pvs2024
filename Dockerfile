# FROM intersystemsdc/iris-community:latest

# USER root   
# WORKDIR /opt/irisapp

# # Install Node.js and build tools
# RUN apt-get update && apt-get install -y \
#     curl \
#     && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
#     && apt-get install -y nodejs \
#     && apt-get clean

# # Frontend setup
# COPY Frontend/ Frontend/
# WORKDIR /opt/irisapp/Frontend
# RUN npm install @mui/material @mui/lab @emotion/react @emotion/styled && \
#     npm install && \
#     npm run build

# # Backend setup
# WORKDIR /opt/irisapp
# COPY Backend/ Backend/
# RUN mkdir -p Backend/csp && \
#     cp -rv Frontend/dist/* Backend/csp/

# # Copy globals and set permissions
# COPY globals/ globals/
# RUN chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

# USER ${ISC_PACKAGE_MGRUSER}

# # Configure IRIS
# RUN --mount=type=secret,id=iris_key,target=/iris-key \
#     iris start IRIS && \
#     iris session IRIS "##class(%EnsembleMgr).EnableNamespace(\"USER\")" && \
#     iris session IRIS "##class(%CSP.Application).CreateApplication(\"/\",\"/opt/irisapp/Backend/csp\")" && \
#     iris stop IRIS quietly

# # Start script
# COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} docker-entrypoint.sh /
# RUN chmod +x /docker-entrypoint.sh

# EXPOSE 51773 52773

# ENTRYPOINT ["/docker-entrypoint.sh"]

FROM intersystemsdc/iris-community:latest

USER root
WORKDIR /opt/irisapp

# Keep your original memory settings
ENV ISC_DATA_DIRECTORY=/opt/irisapp/data
ENV IRIS_GLOBAL_BUFFERS=256
ENV IRIS_ROUTINE_BUFFERS=64
ENV IRIS_MEMORY_HEAP_SIZE=256
ENV IRIS_MAX_SERVERS=2
ENV IRIS_MAX_USER_CONNECTIONS=10
# Add PORT environment variable for Render
ENV PORT=${PORT:-10000}

RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

COPY Frontend/ Frontend/
WORKDIR /opt/irisapp/Frontend
RUN npm install @mui/material @mui/lab @emotion/react @emotion/styled && \
    npm install && \
    npm run build

WORKDIR /opt/irisapp
COPY Backend/ Backend/
RUN mkdir -p Backend/csp && \
    cp -rv Frontend/dist/* Backend/csp/

COPY globals/ globals/
RUN chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

# Create IRIS configuration for port binding
RUN echo "[Startup]" > iris.ini && \
    echo "WebServer=1" >> iris.ini && \
    echo "WebServerPort=${PORT}" >> iris.ini

USER ${ISC_PACKAGE_MGRUSER}

RUN iris start IRIS configfile=/opt/irisapp/iris.ini && \
    iris session IRIS "##class(%EnsembleMgr).EnableNamespace(\"USER\")" && \
    iris session IRIS "##class(%REST.API).CreateApplication(\"rest\",\"/opt/irisapp/Backend/csp\")" && \
    iris stop IRIS quietly

# Only expose the dynamic PORT
EXPOSE ${PORT}

# Create entrypoint script
RUN echo '#!/bin/bash' > /opt/irisapp/entrypoint.sh && \
    echo 'iris start IRIS configfile=/opt/irisapp/iris.ini' >> /opt/irisapp/entrypoint.sh && \
    echo 'tail -f /dev/null' >> /opt/irisapp/entrypoint.sh && \
    chmod +x /opt/irisapp/entrypoint.sh

ENTRYPOINT ["/opt/irisapp/entrypoint.sh"]