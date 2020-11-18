#!/sbin/sh

# The below variables shouldn't need to be changed
# unless you want to call the script something else
SCRIPTNAME="Device_Check"
LOGFILE=/tmp/recovery.log

# Set default log level
# 0 Errors only
# 1 Errors and Information
# 2 Errors, Information, and Debugging
__VERBOSE=1

# Exit codes:
# 0 Success
# 1 hardware value not found in boot header

# Function for logging to the recovery log
log_print()
{
	# 0 = Error; 1 = Information; 2 = Debugging
	case $1 in
		0)
			LOG_LEVEL="E"
			;;
		1)
			LOG_LEVEL="I"
			;;
		2)
			LOG_LEVEL="DEBUG"
			;;
		*)
			LOG_LEVEL="UNKNOWN"
			;;
	esac
	if [ $__VERBOSE -ge "$1" ]; then
		echo "$LOG_LEVEL:$SCRIPTNAME::$2" >> "$LOGFILE"
	fi
}

# Functions to update props using resetprop
update_product_device()
{
	log_print 2 "Current product: $product"
	resetprop "ro.build.product" "$1"
	product=$(getprop ro.build.product)
	log_print 2 "New product: $product"
	log_print 2 "Current device: $device"
	resetprop "ro.product.device" "$1"
	device=$(getprop ro.product.device)
	log_print 2 "New device: $device"
}

update_model()
{
	log_print 2 "Current model: $model"
	resetprop "ro.product.model" "$1"
	model=$(getprop ro.product.model)
	log_print 2 "New model: $model"
}

# These variables will pull directly from getprop output
bootmid=$(getprop ro.boot.mid)
bootcid=$(getprop ro.boot.cid)
device=$(getprop ro.product.device)
hardware=$(getprop ro.hardware)
model=$(getprop ro.product.model)
product=$(getprop ro.build.product)

log_print 2 "Running $SCRIPTNAME script for TWRP..."

if [ "$hardware" = 'qcom' ]; then
	for suffix in "" '_a' '_b'; do
		bootpath="/dev/block/bootdevice/by-name/boot$suffix"
		hardware=$(dd if="$bootpath" bs=1024 count=1 2>/dev/null | strings | grep androidboot.hardware | sed "s/.*androidboot.hardware=\([^ ]*\).*/\1/g")
		if [ -n "$hardware" ]; then
			resetprop ro.hardware "$hardware"
			log_print 1 "ro.hardware set to $hardware."
			hardware=$(getprop ro.hardware)
			break
		fi
	done
	if [ ! -n "$hardware" ]; then
		log_print 0 "No hardware value found."
		exit 1
	fi
else
	exit 0
fi

if [ "$hardware" = 'htc_exo' ]; then
	log_print 2 "Updating device properties for Exodus 1..."
	log_print 2 "MID Found: $bootmid"
	log_print 2 "CID Found: $bootcid"

	case $bootmid in
		"2Q5510000")
			## EMEA/Aisa TW/RUS/SEA India Dual-SIM ##
			update_product_device "htc_exodugl";
			update_model "EXODUS 1";
			;;
		"2Q5520000")
			## EMEA/US Unlocked, Single-SIM ##
			update_product_device "htc_exouhl";
			update_model "EXODUS 1";
			;;
		"2Q5530000")
			## CHINA, Dual-SIM ##
			update_product_device "htc_exodtwl";
			update_model "EXODUS 1";
			;;
		*)
			log_print 0 "MID device parameters unknown. Setting default values."
			update_product_device "htc_exodugl";
			update_model "EXODUS 1";
			;;
	esac
	log_print 2 "Updates for Exodus 1 complete. Proceeding with recovery boot."
	exit 0
else
	log_print 2 "Default settings for U12+ already applied. Proceeding with recovery boot."
	exit 0
fi
