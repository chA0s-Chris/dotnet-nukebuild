FROM mcr.microsoft.com/dotnet/sdk:5.0.400

ENV POWERSHELL_TELEMETRY_OPTOUT=true \
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    DOTNET_RUNNING_IN_CONTAINER=true \
    PATH="$PATH:/root/.dotnet/tools"

# install .NET Core runtime 2.1
ENV DOTNET_RUNTIME_VERSION_2="2.1.29"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/${DOTNET_RUNTIME_VERSION_2}/dotnet-runtime-${DOTNET_RUNTIME_VERSION_2}-linux-x64.tar.gz \
    && dotnet_sha512='1c78674d48269321258f2a599dd4c1793f72a7238e4984d6c64910aa810660874d186fdbcb3347268db42be0c4a7c774a339d7f1dba11f9af49a63bb83658548' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz

# install .NET Core SDK 3.1
ENV DOTNET_SDK_VERSION_3="3.1.412"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_3}/dotnet-sdk-${DOTNET_SDK_VERSION_3}-linux-x64.tar.gz \
    && dotnet_sha512='1ed0c1ab48723cef834906a55fb1889b29dd810cd2bc66cbd345a0baf8a2796045b5b7f4beef3c48bd56bef3ffed690b6fae4a5f017ad8687817b25a76fbd9be' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz

# install docker cli and git-lfs
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-transport-https gnupg \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" >/etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli git-lfs \
    && apt-get remove --purge -y apt-transport-https gnupg \
    && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/docker.list

# install Azure Devops credential provider
RUN mkdir -p ~/.nuget && \
    curl -H "Accept: application/octet-stream" -s -S -L \
    "https://github.com/Microsoft/artifacts-credprovider/releases/latest/download/Microsoft.NuGet.CredentialProvider.tar.gz" | tar xz -C ~/.nuget plugins/netcore

# install kubectl
ENV KUBECTL_VERSION="1.22.0"
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/bin/kubectl \
    && kubectl 

# install Nuke as global tool
ENV NUKE_TOOL_VERSION="5.2.1"
RUN dotnet tool install --global Nuke.GlobalTool --version ${NUKE_TOOL_VERSION}
