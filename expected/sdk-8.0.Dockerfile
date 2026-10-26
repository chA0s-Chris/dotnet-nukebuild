FROM mcr.microsoft.com/dotnet/sdk:8.0.427-noble

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
ENV GIT_LFS_VERSION="3.8.1"
RUN . /etc/os-release \
    && case "${VERSION_CODENAME}" in \
         noble) git_lfs_sha512='a91e83a81e9eb9435c917fe8be6aa8190a80b78d9fb336d1e096bb57b6ae9bac9491d1e2b38513d885f55b10c493c9c37d6f5434bb4a67a8d8fc84ccb75862d2' ;; \
         resolute) git_lfs_sha512='658242a857a4eb5e4f5160be2bac22e96c5412509e4b823360cecc202e9bca896d9d7cd2952220469317166c5def5a63fd8c767b576ec267262fb3e19fdf698e' ;; \
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
ENV KUBECTL_VERSION="1.37.1"
RUN curl -L https://dl.k8s.io/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o kubectl \
    && kubectl_sha512='ff56b9d53b024d0bf4ab6a5c802936d6fd14ef33036962bd9c7202ffb21c04836781b5a2ff0394c35ba7a7aa48f21b51cfe733247672de4d89bc29602e1cc94a' \
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
