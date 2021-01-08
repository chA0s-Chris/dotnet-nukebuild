FROM mcr.microsoft.com/dotnet/sdk:5.0

ENV POWERSHELL_TELEMETRY_OPTOUT=true \
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    DOTNET_RUNNING_IN_CONTAINER=true \
    PATH="$PATH:/root/.dotnet/tools"

# install docker cli
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-transport-https gnupg \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" >/etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && apt-get remove --purge -y apt-transport-https gnupg \
    && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/docker.list

# install .NET Core runtime 2.1
ENV DOTNET_RUNTIME_VERSION_2="2.1.23"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/${DOTNET_RUNTIME_VERSION_2}/dotnet-runtime-${DOTNET_RUNTIME_VERSION_2}-linux-x64.tar.gz \
    && dotnet_sha512='9663a204abb74016113ae0db6c184598a6e5efc6126e35e275d81594432f75f186af781b3b352c8fe8527c690711820bfdd6271424b56e272f73ebe2d666bab5' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz

# install .NET Core SDK 3.1
ENV DOTNET_SDK_VERSION_3="3.1.403"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_3}/dotnet-sdk-${DOTNET_SDK_VERSION_3}-linux-x64.tar.gz \
    && dotnet_sha512='0a0319ee8e9042bf04b6e83211c2d6e44e40e604bff0a133ba0d246d08bff76ebd88918ab5e10e6f7f0d2b504ddeb65c0108c6539bc4fbc4f09e4af3937e88ea' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz

# install Azure Devops credential provider
RUN mkdir -p ~/.nuget && \
    curl -H "Accept: application/octet-stream" -s -S -L \
    "https://github.com/Microsoft/artifacts-credprovider/releases/latest/download/Microsoft.NuGet.CredentialProvider.tar.gz" | tar xz -C ~/.nuget plugins/netcore

# install kubectl
ENV KUBECTL_VERSION="1.20.0"
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/bin/kubectl \
    && kubectl 

# install Nuke as global tool
ENV NUKE_TOOL_VERSION="5.0.2"
RUN dotnet tool install --global Nuke.GlobalTool --version ${NUKE_TOOL_VERSION}

# install GitVersion as global tool
ENV GITVERSION_TOOL_VERSION="5.6.1"
RUN dotnet tool install --global GitVersion.Tool --version ${GITVERSION_TOOL_VERSION}
