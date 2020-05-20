FROM buildpack-deps:stretch-scm

# add dotnet tools to path
ENV PATH="$PATH:/root/.dotnet/tools" \
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip

# install .NET CLI dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu57 \
        liblttng-ust0 \
        libssl1.0.2 \
        libstdc++6 \
        zlib1g \
        libcurl3 \
    && rm -rf /var/lib/apt/lists/*

# install docker cli
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-transport-https \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" >/etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && apt-get remove --purge -y apt-transport-https \
    && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/docker.list

# install .NET Core runtime 2.1
ENV DOTNET_RUNTIME_VERSION="2.1.18"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_RUNTIME_VERSION/dotnet-runtime-$DOTNET_RUNTIME_VERSION-linux-x64.tar.gz \
    && dotnet_sha512='97e8060b97ead693278af4897e33b7d13065ac19fc657c0d1aa184ffc73aab0354a07615e2f15f0bd8280c6212183bba5ffc61e30302539639d1a5b5b6466dbe' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# install .NET Core SDK 3.1
ENV DOTNET_SDK_VERSION="3.1.300"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz \
    && dotnet_sha512='1c3844ea5f8847d92372dae67529ebb08f09999cac0aa10ace571c63a9bfb615adbf8b9d5cebb2f960b0a81f6a5fba7d80edb69b195b77c2c7cca174cbc2fd0b' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz

RUN dotnet --info

# install Azure Devops credential provider
RUN mkdir -p ~/.nuget && \
    curl -H "Accept: application/octet-stream" -s -S -L \
    "https://github.com/Microsoft/artifacts-credprovider/releases/latest/download/Microsoft.NuGet.CredentialProvider.tar.gz" | tar xz -C ~/.nuget plugins/netcore

# install kubectl
ENV KUBECTL_VERSION="1.18.2"
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/bin/kubectl \
    && kubectl 

# install Nuke as global tool
ENV NUKE_TOOL_VERSION="0.24.11"
RUN dotnet tool install --global Nuke.GlobalTool --version ${NUKE_TOOL_VERSION}

# install GitVersion as global tool
ENV GITVERSION_TOOL_VERSION="5.3.3"
RUN dotnet tool install --global GitVersion.Tool --version ${GITVERSION_TOOL_VERSION}


