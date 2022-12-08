#!/bin/bash
echo "VpnHood Server Installation for linux";

# Default arguments
packageUrl="https://github.com/vpnhood/VpnHood/releases/download/v2.4.321/VpnHoodServer-linux-x64.tar.gz";
versionTag="v2.4.321";
destinationPath="/opt/VpnHoodServer";
packageFile="";
autostart="y";
quiet="y";




binDir="$destinationPath/$versionTag";



# point to latest version if $packageUrl is not set
if [ "$packageUrl" = "" ]; then
	packageUrl="https://github.com/vpnhood/VpnHood/releases/latest/download/VpnHoodServer-linux.tar.gz";
fi

# download & install VpnHoodServer
if [ "$packageFile" = "" ]; then
	echo "Downloading VpnHoodServer...";
	packageFile="VpnHoodServer-linux.tar.gz";
	wget -nv -O "$packageFile" "$packageUrl";
fi

# extract
echo "Extracting to $destinationPath";
mkdir -p $destinationPath;
tar -xzf "$packageFile" -C "$destinationPath"

# Updating shared files...
echo "Updating shared files...";
infoDir="$binDir/publish_info";
cp "$infoDir/vhupdate" "$destinationPath/" -f;
cp "$infoDir/vhserver" "$destinationPath/" -f;
cp "$infoDir/publish.json" "$destinationPath/" -f;
chmod +x "$binDir/VpnHoodServer";
chmod +x "$destinationPath/vhserver";
chmod +x "$destinationPath/vhupdate";

# Write AppSettingss
if [ "$restBaseUrl" != "" ]; then
	appSettings="{
  \"HttpAccessServer\": {
    \"BaseUrl\": \"$restBaseUrl\",
    \"Authorization\": \"$restAuthorization\"
  },
  \"Secret\": \"$secret\"
}
";
	echo "$appSettings" > "$destinationPath/storage/appsettings.json"
fi

# init service
if [ "$autostart" = "y" ]; then
	echo "creating autostart service... Name: VpnHoodServer";
	service="
[Unit]
Description=VpnHood Server
After=network.target

[Service]
Type=simple
ExecStart="$binDir/VpnHoodServer"
ExecStop="$binDir/VpnHoodServer" stop
TimeoutStartSec=0
Restart=always
RestartSec=10
StandardOutput=null

[Install]
WantedBy=default.target
";

	echo "$service" > "/etc/systemd/system/VpnHoodServer.service";

	echo "creating VpnHood Updater service... Name: VpnHoodUpdater";
	service="
[Unit]
Description=VpnHood Server Updater
After=network.target

[Service]
Type=simple
ExecStart="$destinationPath/vhupdate"
TimeoutStartSec=0
Restart=always
RestartSec=720min

[Install]
WantedBy=default.target
";
	echo "$service" > "/etc/systemd/system/VpnHoodUpdater.service";

	# Executing services
	echo "Executing VpnHoodServer services...";
	systemctl daemon-reload;
	
	systemctl enable VpnHoodServer.service;
	systemctl restart VpnHoodServer.service;
	
	systemctl enable VpnHoodUpdater.service;
	systemctl restart VpnHoodUpdater.service;
fi
