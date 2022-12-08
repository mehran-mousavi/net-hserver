ADD file:d08e242792caa7f842fcf39a09ad59c97a856660e2013d5aed3e4a29197e9aaa in / 
 CMD ["bash"]
/bin/sh -c apt-get update     && apt-get install -y --no-install-recommends         ca-certificates                 libc6         libgcc1         libgssapi-krb5-2         libicu67         libssl1.1         libstdc++6         zlib1g     && rm -rf /var/lib/apt/lists/*
 ENV ASPNETCORE_URLS=http://+:80 DOTNET_RUNNING_IN_CONTAINER=true
 ENV DOTNET_VERSION=7.0.0
COPY dir:5777f6061f113dcaaaccee02c59dd661c0e1fe8d170ed2a9a39f80958b68ad31 in /usr/share/dotnet 
/bin/sh -c ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
WORKDIR /app
WORKDIR /app
COPY /app/publish . # buildkit
ENTRYPOINT ["dotnet" "VpnHoodServer.dll"]
