#! /bin/sh

## version 1.0 at 2020.08.19

/flash/mount_usb.sh
[ $? -ne 0 ] && {
	echo "Failed to mount USB..."
	exit
}

echo "Update some parameters from USB..."

DeviceName=`def view management | grep "Device Name" | awk '{ print $4 }'`
echo "DeviceName=" $DeviceName

[ ! -e /tmp/usb/set_params.sh ] && {
	echo "Can't find set_params.sh on USB..."
	exit
}

UpdateDeviceName=`cat /tmp/usb/set_params.sh | grep "def name" | awk '{ print $3 }'`
echo "UpdateDeviceName=" $UpdateDeviceName

[ $DeviceName = $UpdateDeviceName ] && {
	echo "Device Name is same with set_param.sh of USB..."
	exit
}

echo "Updating parameters from set_params.sh of USB..."
/tmp/usb/set_params.sh
def save
sync
echo "Done."

echo "rebooting..."
reboot

sleep 10
