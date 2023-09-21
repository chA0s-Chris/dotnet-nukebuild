FROM chaos/dotnet-nukebuild:latest

# install .NET SDK 8.0 PREVIEW
ENV DOTNET_SDK_VERSION_8="8.0.100-rc.1.23463.5"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_8}/dotnet-sdk-${DOTNET_SDK_VERSION_8}-linux-x64.tar.gz \
    && dotnet_sha512='ac941fd16fd7c328f7cc44b132b4253ddb2b6a6c152af5f43c71c6cd0d468c89b7276ebf6c08895dcb6e5e25f7cae83b6fbacb91cfcc4a61d49b5657a834a901' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./host ./packs ./sdk ./sdk-manifests ./templates ./shared \
    && rm dotnet.tar.gz \
    && dotnet help
