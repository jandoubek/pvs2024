FROM intersystemsdc/iris-community:latest

USER root   
WORKDIR /opt/irisapp

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
    cp -rv Frontend/dist/* Backend/csp/ && \
    chown -R irisowner:irisowner Backend/csp && \
    chown -R irisowner:irisowner globals

COPY globals/ globals/

USER ${ISC_PACKAGE_MGRUSER}

RUN iris start IRIS \
    && iris session IRIS "##class(%EnsembleMgr).EnableNamespace(\"USER\")" \
    && iris session IRIS "##class(%CSP.Application).CreateApplication(\"/\",\"/opt/irisapp/Backend/csp\")" \
    && iris stop IRIS quietly

# Start IRIS using the correct command
CMD [ "/iris-main", "--check-caps", "false" ]