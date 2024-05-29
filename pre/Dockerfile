FROM chaos/dotnet-nukebuild:8

# install .NET SDK 9.0 PREVIEW
ENV DOTNET_SDK_VERSION_9="9.0.100-preview.4.24267.66"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_9}/dotnet-sdk-${DOTNET_SDK_VERSION_9}-linux-x64.tar.gz \
    && dotnet_sha512='28b63633a1e6f4078ccc60218b9f7b6663eb960f0ab1c41069ed8f7f67757fa22ce9f4c04d88b9015c417aad34a7a57986451682bd7aa7b966eda45ace23d283' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./host ./packs ./sdk ./sdk-manifests ./templates ./shared \
    && rm dotnet.tar.gz \
    && dotnet help
