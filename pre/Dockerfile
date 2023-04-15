FROM chaos/dotnet-nukebuild:latest

# install .NET SDK 8.0 PREVIEW
ENV DOTNET_SDK_VERSION_8="8.0.100-preview.3.23178.7"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_8}/dotnet-sdk-${DOTNET_SDK_VERSION_8}-linux-x64.tar.gz \
    && dotnet_sha512='3b5d72979831256b9340a01db23d3b2dca801672546eeed04385949ed5f4363d3c731f31477ec82c7200ce88502dc45e03986c8acc8f2fc611b0343af5f1c488' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./host ./packs ./sdk ./sdk-manifests ./templates ./shared \
    && rm dotnet.tar.gz \
    && dotnet help
