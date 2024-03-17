FROM chaos/dotnet-nukebuild:8

# install .NET SDK 9.0 PREVIEW
ENV DOTNET_SDK_VERSION_9="9.0.100-preview.2.24157.14"
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/${DOTNET_SDK_VERSION_9}/dotnet-sdk-${DOTNET_SDK_VERSION_9}-linux-x64.tar.gz \
    && dotnet_sha512='c44df5e11791e4b22720834ed7f28102e33ab475670fa8e132d73d5dd03d8f4ed3f4a548deac67a79e06db6f776c9f632eda4503b6fdc9eef7ffb001cc9963c0' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./host ./packs ./sdk ./sdk-manifests ./templates ./shared \
    && rm dotnet.tar.gz \
    && dotnet help
