#!/bin/bash
echo "VpnHood Server Installation for linux";

sudo su -c "bash <( wget -qO- https://github.com/vpnhood/VpnHood/releases/latest/download/VpnHoodServer-linux-x64.sh)"
sudo /opt/VpnHoodServer/vhserver gen
sudo systemctl start VpnHoodServer
