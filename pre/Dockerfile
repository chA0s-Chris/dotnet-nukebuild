FROM chaos/dotnet-nukebuild:latest

# install .NET SDK 8.0 PREVIEW
ENV DOTNET_SDK_VERSION_8="8.0.100-preview.5.23303.2"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_8}/dotnet-sdk-${DOTNET_SDK_VERSION_8}-linux-x64.tar.gz \
    && dotnet_sha512='dfe2085a92854a5cee84cb7be9344368f5dcb6333c4ca215375a34b862f3a3ee66c953b9957f7b46f6cd710992ee038f6b4c2bd16464b4a216a1785868e86f7c' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./host ./packs ./sdk ./sdk-manifests ./templates ./shared \
    && rm dotnet.tar.gz \
    && dotnet help
