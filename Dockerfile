FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim-amd64

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    DOTNET_SDK_VERSION=5.0.100-rc.2.20479.15 \
    DOTNET_RUNTIME_VERSION=5.0.100-rc.2.20479.15 \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Debian-10 \
    DOTNET_RUNNING_IN_CONTAINER=true \
    PATH="$PATH:/root/.dotnet/tools"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gnupg2 \
        curl \
        git \
        wget \
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

# install .NET SDK 5
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION}/dotnet-sdk-${DOTNET_SDK_VERSION}-linux-x64.tar.gz \
    && dotnet_sha512='e705043cdec53827695567eed021c76b100d77416f10cc18d4f5d02950f85bf9ccd7e2c22643f00a883e11b253fb8aa098e4dce008008a0796f913496f97e362' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./packs ./sdk ./templates ./LICENSE.txt ./ThirdPartyNotices.txt \
    && rm dotnet.tar.gz \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help

# install PowerShell global tool
RUN powershell_version=7.1.0-rc.1 \
    && curl -SL --output PowerShell.Linux.x64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.x64.$powershell_version.nupkg \
    && powershell_sha512='13bac9b9ff64980077fe96f0f1719a650a910ead292f4ba088abf3b3640501ff78aa619d84792ca7eec34c32724380193e442ab14923a25cc242c8780ea768e0' \
    && echo "$powershell_sha512  PowerShell.Linux.x64.$powershell_version.nupkg" | sha512sum -c - \
    && mkdir -p /usr/share/powershell \
    && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.x64 \
    && dotnet nuget locals all --clear \
    && rm PowerShell.Linux.x64.$powershell_version.nupkg \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    && chmod 755 /usr/share/powershell/pwsh \
    # To reduce image size, remove the copy nupkg that nuget keeps.
    && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm

# install Azure Devops credential provider
RUN mkdir -p ~/.nuget && \
    curl -H "Accept: application/octet-stream" -s -S -L \
    "https://github.com/Microsoft/artifacts-credprovider/releases/latest/download/Microsoft.NuGet.CredentialProvider.tar.gz" | tar xz -C ~/.nuget plugins/netcore

# install kubectl
ENV KUBECTL_VERSION="1.19.0"
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/bin/kubectl \
    && kubectl 

# install Nuke as global tool
ENV NUKE_TOOL_VERSION="0.24.11"
RUN dotnet tool install --global Nuke.GlobalTool --version ${NUKE_TOOL_VERSION}

# install GitVersion as global tool
ENV GITVERSION_TOOL_VERSION="5.3.7"
RUN dotnet tool install --global GitVersion.Tool --version ${GITVERSION_TOOL_VERSION}
