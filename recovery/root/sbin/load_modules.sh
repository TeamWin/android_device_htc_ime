#!/sbin/sh

SCRIPTNAME="Module_Load"
LOGFILE=/tmp/recovery.log
venmod=/vendor/lib/modules

log_info()
{
	echo "I:$SCRIPTNAME:$1" >> "$LOGFILE"
}

log_error()
{
	echo "E:$SCRIPTNAME:$1" >> "$LOGFILE"
}

load_module()
{
	if [ -f "$2" ]; then
		log_info "$1 module found! Loading $1 module..."
		insmod "$2"
		log_info "Confirming $1 module has been loaded..."
		is_loaded=$(lsmod | grep "$1")
		if [ -n "$is_loaded" ]; then
			log_info "$1 module loaded."
		else
			log_error "Unable to load $1 module."
		fi
	else
		log_error "$1 module not found."
	fi
}

is_fastboot=$(getprop ro.boot.fastboot)

if [ ! -n "$is_fastboot" ]; then
	log_info "Loading modules..."
	# Tuxera exFAT
	log_info "Attempting to load Pie texfat module..."
	load_module "texfat" "$venmod/texfat.ko"
	if [ ! -n "$is_loaded" ]; then
		log_info "Attempting to load Oreo texfat module..."
		load_module "texfat" "$venmod/texfat_oreo.ko"
	fi
fi

exit 0
