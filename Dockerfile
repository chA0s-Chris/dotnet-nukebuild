FROM mcr.microsoft.com/dotnet/sdk:6.0.202-focal

ENV POWERSHELL_TELEMETRY_OPTOUT=true \
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    DOTNET_RUNNING_IN_CONTAINER=true \
    NUKE_TELEMETRY_OPTOUT=true \
    PATH="$PATH:/root/.dotnet/tools"

# install .NET SDK 5.0
ENV DOTNET_SDK_VERSION_5="5.0.407"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_5}/dotnet-sdk-${DOTNET_SDK_VERSION_5}-linux-x64.tar.gz \
    && dotnet_sha512='b45f1bf086bfb5e0701c5e14534524ffc87d0195358ac4fa2cf36dac74537ca4c21c7177cfbfa7e121e77aa4106bb1e7039c9739ad73b942e2437bc5e39e6dce' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./host ./packs ./sdk ./templates ./shared \
    && rm dotnet.tar.gz

# install .NET Core SDK 3.1
ENV DOTNET_SDK_VERSION_3="3.1.418"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_3}/dotnet-sdk-${DOTNET_SDK_VERSION_3}-linux-x64.tar.gz \
    && dotnet_sha512='e60f14841f1d0156de163f6f1e4c6358f14bd57e81beed13d294022da8a5182e41b8333591f92c4cac8eec138b7bc85725c19ae10e4e73a139a5231bb12b557f' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./host ./packs ./sdk ./templates ./shared \
    && rm dotnet.tar.gz

# install docker cli and git-lfs
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends apt-transport-https gnupg \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable" | \
    tee /etc/apt/sources.list.d/docker.list >/dev/null \
    && echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main" | tee /etc/apt/sources.list.d/git-core-ubuntu-ppa-focal.list >/dev/null \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24 \
    && apt-get update \
    && apt-get dist-upgrade -y \
    && curl -SL --output git-lfs.deb https://packagecloud.io/github/git-lfs/packages/ubuntu/focal/git-lfs_3.1.2_amd64.deb/download.deb \
    && git_lfs_sha512='71a94e42a3679ef2057786fb161ed2201c2a6217a79f334a9de856b3538a3ded248ee1ca63398907f4e17b6a115fa702c04f3b46fd4b0de0f42e197c7883f02d' \
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
RUN mkdir -p ~/.docker/cli-plugins \
    && curl -L -o ~/.docker/cli-plugins/docker-pushrm "https://github.com/christian-korneck/docker-pushrm/releases/download/v1.8.0/docker-pushrm_linux_amd64" \
    && chmod +x ~/.docker/cli-plugins/docker-pushrm

# install kubectl
ENV KUBECTL_VERSION="1.23.5"
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/bin/kubectl \
    && kubectl 

# install Nuke as global tool
ENV NUKE_TOOL_VERSION="6.0.2"
RUN dotnet tool install --global Nuke.GlobalTool --version ${NUKE_TOOL_VERSION}
