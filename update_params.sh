#! /bin/sh

## version 1.1 at 2020.08.20

echo "Start script to update parameters from USB..."

## Mount USB memory
/flash/mount_usb.sh
[ $? -ne 0 ] && {
	echo "Failed to mount USB..."
	exit
}

## Get current Device Name
CurrentDeviceName=`def view management | grep -w "Device Name" | awk '{ print $4 }'`
echo "Current DeviceName =" $CurrentDeviceName

## Check existing set_params.sh file
[ ! -e /tmp/usb/set_params.sh ] && {
	echo "Can't find set_params.sh on USB..."
	exit
}

## Check set_params.sh is valid which has "def name" command.
UpdateDeviceName=`cat /tmp/usb/set_params.sh | awk '{print $1, $2}' | grep "def name"`
# echo "Update command =" $UpdateDeviceName
[ -z "$UpdateDeviceName" ] && {
	echo "Not valid file set_params.sh on USB..."
	exit
}

## Get update Device Name
UpdateDeviceName=`grep -w "def name" /tmp/usb/set_params.sh | head -1 | awk '{ print $3 }'`
echo "Update DeviceName =" $UpdateDeviceName

## Check need to update Device Name
[ $CurrentDeviceName = $UpdateDeviceName ] && {
	echo "Device Name is same with set_param.sh on USB..."
	exit
}

## Update parameters
echo "Updating parameters from set_params.sh on USB..."
/tmp/usb/set_params.sh
def save
sync
echo "Done."

echo "Rebooting..."
reboot

sleep 10
