FROM mcr.microsoft.com/dotnet/sdk:7.0.103-jammy

ENV POWERSHELL_TELEMETRY_OPTOUT=true \
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    DOTNET_CLI_UI_LANGUAGE=en-US \
    DOTNET_RUNNING_IN_CONTAINER=true \
    NUKE_TELEMETRY_OPTOUT=true \
    PATH="$PATH:/root/.dotnet/tools"

# install .NET SDK 6.0
ENV DOTNET_SDK_VERSION_6="6.0.406"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_6}/dotnet-sdk-${DOTNET_SDK_VERSION_6}-linux-x64.tar.gz \
    && dotnet_sha512='4553aed8455501e506ee7498a07bff56e434249406266f9fd50eb653743e8fc9c032798f75e34c2a2a2c134ce87a8f05a0288fc8f53ddc1d7a91826c36899692' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./host ./packs ./sdk ./templates ./shared \
    && rm dotnet.tar.gz

# install docker cli and git-lfs
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends apt-transport-https gnupg \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu jammy stable" | \
    tee /etc/apt/sources.list.d/docker.list >/dev/null \
    && echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu jammy main" | tee /etc/apt/sources.list.d/git-core-ubuntu-ppa-jammy.list >/dev/null \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24 \
    && apt-get update \
    && apt-get dist-upgrade -y \
    && curl -SL --output git-lfs.deb https://packagecloud.io/github/git-lfs/packages/ubuntu/jammy/git-lfs_3.3.0_amd64.deb/download.deb \
    && git_lfs_sha512='0646a84a82928827f8571a01858f4ba6353fde86ac2050d8336e0f63b5a6af946ce2518da66169c47a0a5b0b27aca26d7a1a08ad458cdd5aa5e0435a0a30772c' \
    && echo "$git_lfs_sha512 git-lfs.deb" | sha512sum -c - \
    && dpkg -i git-lfs.deb \
    && apt-get install -y docker-ce-cli \
    && apt-get remove --purge -y apt-transport-https gnupg \
    && rm -rf /var/lib/apt/lists/* git-lfs.deb /etc/apt/sources.list.d/docker.list /etc/apt/sources.list.d/git-core-ubuntu-ppa-focal.list

# install Azure Devops credential provider
RUN mkdir -p ~/.nuget && \
    curl -H "Accept: application/octet-stream" -s -S -L \
    "https://github.com/Microsoft/artifacts-credprovider/releases/latest/download/Microsoft.NuGet.CredentialProvider.tar.gz" | tar xz -C ~/.nuget plugins/netcore

# install docker-pushrm
ENV DOCKER_PUSHRM_VERSION="1.9.0"
RUN mkdir -p ~/.docker/cli-plugins \
    && curl -L -o ~/.docker/cli-plugins/docker-pushrm "https://github.com/christian-korneck/docker-pushrm/releases/download/v${DOCKER_PUSHRM_VERSION}/docker-pushrm_linux_amd64" \
    && chmod +x ~/.docker/cli-plugins/docker-pushrm

# install kubectl
ENV KUBECTL_VERSION="1.26.1"
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/bin/kubectl \
    && kubectl 

# install Nuke as global tool
ENV NUKE_TOOL_VERSION="6.3.0"
RUN dotnet tool install --global Nuke.GlobalTool --version ${NUKE_TOOL_VERSION}
