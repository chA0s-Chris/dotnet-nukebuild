FROM chaos/dotnet-nukebuild:latest

# install .NET SDK 8.0 PREVIEW
ENV DOTNET_SDK_VERSION_8="8.0.100-rc.2.23502.2"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_8}/dotnet-sdk-${DOTNET_SDK_VERSION_8}-linux-x64.tar.gz \
    && dotnet_sha512='45f09e7b031f4cf5b4dcead240fe47e2e3731d97d22aa96d3a02a087322658606cc22792053c3784c44f15d7c9bad0ac9dbda90def7b4e197f2955dca9a5bb6c' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./host ./packs ./sdk ./sdk-manifests ./templates ./shared \
    && rm dotnet.tar.gz \
    && dotnet help
