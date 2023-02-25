FROM chaos/dotnet-nukebuild:latest

# install .NET SDK 8.0 PREVIEW
ENV DOTNET_SDK_VERSION_8="8.0.100-preview.1.23115.2"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_8}/dotnet-sdk-${DOTNET_SDK_VERSION_8}-linux-x64.tar.gz \
    && dotnet_sha512='23a14c92e402161ed8d42ec9cb25a97868a1b72348195d28cffa00a12815f019308b56485e4375c0d0a33d9a683d83cc1e1a2a517eea44af8fb353171b6c3f64' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./host ./packs ./sdk ./sdk-manifests ./templates ./shared \
    && rm dotnet.tar.gz \
    && dotnet help
