FROM chaos/dotnet-nukebuild:8

# install .NET SDK 9.0 PREVIEW
ENV DOTNET_SDK_VERSION_9="9.0.100-preview.3.24204.13"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_9}/dotnet-sdk-${DOTNET_SDK_VERSION_9}-linux-x64.tar.gz \
    && dotnet_sha512='7f487d92ee3b28061ef28e013295ebdf6703721b5e2e55ae2d7b18f1ff4fa4e3e01b6a8b508723ffb22dbc8437f0693d7c07f4dd8ef113d5da8a51b3645b3422' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./host ./packs ./sdk ./sdk-manifests ./templates ./shared \
    && rm dotnet.tar.gz \
    && dotnet help
