FROM intersystemsdc/iris-community:latest

USER root   
WORKDIR /opt/irisapp

# Install Node.js
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

# Copy and build frontend
COPY Frontend/ Frontend/
WORKDIR /opt/irisapp/Frontend

# Install dependencies and build
RUN npm install @mui/material @mui/lab @emotion/react @emotion/styled && \
    npm install && \
    npm run build

# Setup backend with debug info
WORKDIR /opt/irisapp
COPY Backend/ Backend/
RUN ls -la Frontend/dist && \
    mkdir -p Backend/csp && \
    cp -rv Frontend/dist/* Backend/csp/ && \
    ls -la Backend/csp && \
    chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

COPY globals/ globals/

USER ${ISC_PACKAGE_MGRUSER}

RUN iris start IRIS \
    && iris session IRIS "##class(%EnsembleMgr).EnableNamespace(\"USER\")" \
    && iris session IRIS "##class(%CSP.Portal).CreateApplication(\"/\",\"/opt/irisapp/Backend/csp\")" \
    && iris stop IRIS quietly

CMD [ "iris", "start", "IRIS" ]