#!/sbin/sh

# The below variables shouldn't need to be changed
# unless you want to call the script something else
SCRIPTNAME="SAR_Setup"
LOGFILE=/tmp/recovery.log

# Set default log level
# 0 Errors only
# 1 Errors and Information
# 2 Errors, Information, and Debugging
__VERBOSE=1

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

check_resetprop()
{
	if [ -e /system/bin/resetprop ] || [ -e /sbin/resetprop ]; then
		log_print 2 "Resetprop binary found!"
		setprop_bin=resetprop
	else
		log_print 2 "Resetprop binary not found. Falling back to setprop."
		setprop_bin=setprop
	fi
}

finish()
{
	log_print 1 "SAR setup complete. Continuing TWRP boot."
	exit 0
}

is_gsi=$(getprop ro.product.system.device)

log_print 2 "Running $SCRIPTNAME script for TWRP..."

if [ "$is_gsi" = "generic" ]; then
	log_print 2 "GSI detected! Overriding OS version and security patch level setting..."
	check_resetprop
	$setprop_bin ro.boot.fastboot 1
	finish
else
	log_print 2 "Standard system detected. No further action required."
	finish
fi
