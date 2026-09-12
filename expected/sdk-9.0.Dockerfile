FROM mcr.microsoft.com/dotnet/sdk:9.0.318-noble

ENV POWERSHELL_TELEMETRY_OPTOUT=true \
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    DOTNET_CLI_UI_LANGUAGE=en-US \
    DOTNET_RUNNING_IN_CONTAINER=true \
    NUKE_TELEMETRY_OPTOUT=true \
    PATH="$PATH:/root/.dotnet/tools"

# update distro
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# install docker cli
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-transport-https gnupg \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list >/dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && apt-get remove --purge -y apt-transport-https gnupg \
    && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/docker.list

# install git-lfs
ENV GIT_LFS_VERSION="3.8.0"
RUN . /etc/os-release \
    && case "${VERSION_CODENAME}" in \
         noble) git_lfs_sha512='5db6dccbfa6bf1c0e7ebefc0016ab92667186ce38677da2692cc80f9b5e7a76eec58796761d005316c5d720aed1b46970c8cf096d514954b7a904b3b190acfd9' ;; \
         resolute) git_lfs_sha512='6609594d7a3e9bb203f12d25edd3f75d7932d71afe43c60ac14b3825b3a8734732a2655a20d11e3245951ec434ac0ce6da6b4a1283a1452177ac65c178046ae0' ;; \
         *) echo "no git-lfs checksum pinned for distro '${VERSION_CODENAME}'" >&2; exit 1 ;; \
       esac \
    && curl -SL --output git-lfs.deb "https://packagecloud.io/github/git-lfs/packages/ubuntu/${VERSION_CODENAME}/git-lfs_${GIT_LFS_VERSION}_amd64.deb/download.deb" \
    && echo "$git_lfs_sha512 git-lfs.deb" | sha512sum -c - \
    && dpkg -i git-lfs.deb

# install Azure Artifacts Credential Provider
RUN dotnet tool install --global  Microsoft.Artifacts.CredentialProvider.NuGet.Tool
# install docker-pushrm
ENV DOCKER_PUSHRM_VERSION="1.9.0"
RUN mkdir -p ~/.docker/cli-plugins \
    && curl -L -o ~/.docker/cli-plugins/docker-pushrm "https://github.com/christian-korneck/docker-pushrm/releases/download/v${DOCKER_PUSHRM_VERSION}/docker-pushrm_linux_amd64" \
    && chmod +x ~/.docker/cli-plugins/docker-pushrm

# install kubectl
ENV KUBECTL_VERSION="1.37.0"
RUN curl -L https://dl.k8s.io/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o kubectl \
    && kubectl_sha512='b24f024e709ff6fd457a6c6a84bc99df6121e771470683f221f07c742d40339692a157513b53f365d1dbe752fad6126be194087c9b0accbb8d166e2308afd5f1' \
    && echo "$kubectl_sha512 kubectl" | sha512sum -c - \
    && chmod +x kubectl \
    && mv kubectl /usr/bin/kubectl \
    && kubectl 
ENV NUKE_TOOL_VERSION="9.0.4"
RUN dotnet tool install --global Nuke.GlobalTool --version ${NUKE_TOOL_VERSION}

# install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /usr/share/keyrings/nodesource.gpg \
    && rm -f /etc/apt/sources.list.d/nodesource.list \
    && rm -f /etc/apt/sources.list.d/nodesource.sources
