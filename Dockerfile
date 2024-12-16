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

ENV ISC_DATA_DIRECTORY=/opt/irisapp/data
ENV IRIS_GLOBAL_BUFFERS=256
ENV IRIS_ROUTINE_BUFFERS=64
ENV IRIS_MEMORY_HEAP_SIZE=256
ENV IRIS_MAX_SERVERS=2
ENV IRIS_MAX_USER_CONNECTIONS=10
ENV PORT=52773

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

USER ${ISC_PACKAGE_MGRUSER}

RUN iris start IRIS -cconsole=0 -xs "globals=256,routines=64" && \
    iris session IRIS "##class(%EnsembleMgr).EnableNamespace(\"USER\")" && \
    iris session IRIS "##class(%REST.API).CreateApplication(\"rest\",\"/opt/irisapp/Backend/csp\")" && \
    iris stop IRIS quietly

EXPOSE $PORT 51773 53773

CMD ["iris", "start", "IRIS", "-b", "52773:52773", "-cconsole=0", "-xs", "globals=256,routines=64"]