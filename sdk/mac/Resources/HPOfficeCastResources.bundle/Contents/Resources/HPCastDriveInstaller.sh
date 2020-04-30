
COMMAND=$1
APPLICATION=$2
RESOURCE_DIR=$3
ORIGINAL_USER=$4
ORIGINAL_HOME=$5

# The paths to the kext(s).
#KEXT_BID="com.hpplay.displayDrive"
#KEXT_NAM="HPDisplayDrive.kext"
KEXT_BID1="com.hpplay.CastAudio.Driver"
KEXT_NAM1="Cast Audio.driver"


#PLUG_NAM="com_tsoniq_DisplayXGA.plugin"




echo "Running script $0"
echo "  command:       '$COMMAND'"
echo "  application:   '$APPLICATION'"
echo "  resources:     '$RESOURCE_DIR'"
echo "  original_user: '$ORIGINAL_USER'"
echo "  original_home: '$ORIGINAL_HOME'"
echo "  OS version:     `sw_vers -productVersion`"
#echo "  KEXT_BID:      '$KEXT_BID'"
#echo "  KEXT_NAM:      '$KEXT_NAM'"
#echo "  PLUG_NAM:      '$PLUG_NAM'"
echo "  KEXT_BID1:      '$KEXT_BID1'"
echo "  KEXT_NAM1:      '$KEXT_NAM1'"



# Method called to terminate execution with success status.
doExitSuccess()
{
echo "@@@exit/success/${COMMAND}"
exit 0
}


# Method called to terminate execution with failure status.
doExitFailure()
{
echo "@@@exit/fail/${COMMAND}/$1"
exit 0
}


# Move the supplied argument(s) to the trash
doMoveToTrash()
{
local SOURCE
for SOURCE in "$@"; do

local FILENAME=`basename "${SOURCE}"`
FILENAME=${FILENAME%/}
local TARGET=$FILENAME

while [ -e "${ORIGINAL_HOME}/.Trash/${TARGET}" ]; do
local EXTENSION=`expr "${FILENAME}" : ".*\(\.[^\.]*\)$"`
local STEM=${FILENAME%$EXTENSION}
TARGET="/$STEM`date +%H-%M-%S` ${RANDOM}${EXTENSION}"
done
TARGET="${ORIGINAL_HOME}/.Trash/${TARGET}"

mv "${SOURCE}" "${TARGET}"
done
}


# Generic method used to uninstall a specific instance of the driver.
#
#   $1  Specifies the installed KEXT path.
#
doRemoveKextInstance()
{
# The following checks for the Info.plist file in the kext, rather than the kext dir name
# to reduce the risk of a script error damaging the system installation.
if [ -f "${1}/Contents/Info.plist" ] ; then
#    kextunload "${1}"
#    sleep 1
#    kextunload "${1}"
#    sleep 1
rm -rf "${1}"
fi
}


# Method called to perform uninstallation of the driver.
doRemoveDriver()
{
# clean up older installs
#rm -f /Library/LaunchDaemons/*tsoniq*dxdemo*
#rm -f /Library/PrivilegedHelperTools/*tsoniq*dxdemo*
#rm -f /Library/LaunchDaemons/*tsoniq*dxdemo*
#rm -f /Library/PrivilegedHelperTools/*tsoniq*dxdemo*
#rm -f /Library/LaunchDaemons/*tsoniq*dxdemo*
#rm -f /Library/PrivilegedHelperTools/*tsoniq*dxdemo*

# sanity check (before sudo rm -rf destroys the user's computer)
#if [ -z "${KEXT_NAM}" ] ; then
#doExitFailure "Undefined kext name"
#else
#doRemoveKextInstance "/Library/Extensions/${KEXT_NAM}"
#doRemoveKextInstance "/Library/Extensions/${PLUG_NAM}"
#doRemoveKextInstance "/System/Library/Extensions/${KEXT_NAM}"
#doRemoveKextInstance "/System/Library/Extensions/${PLUG_NAM}"
#fi

if [ -z "${KEXT_NAM1}" ] ; then
doExitFailure "Undefined kext name"
else
doRemoveKextInstance "/Library/Audio/Plug-Ins/HAL/${KEXT_NAM1}"
#    doRemoveKextInstance "/Library/Extensions/${PLUG_NAM}"
#doRemoveKextInstance "/Library/Audio/Plug-Ins/HAL/${KEXT_NAM1}"
#    doRemoveKextInstance "/System/Library/Extensions/${PLUG_NAM}"
sudo killall coreaudiod
sudo killall coreaudiod
    if  [ ${OS_PRODUCT_VERSION} -ge 15 ] ; then
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    fi


fi
}


# Generic method used to install a specific instance of the driver.
#
#   $1  Specifies the KEXT name.
#   $2  Specifies the KEXT source dir.
#   $3  Specifies the KEXT target dir.
#
doInstallDriverFile()
{
KEXT_TMP="`mktemp -d -t tsoniq`/${1}"
KEXT_SRC="${2}/${1}"
KEXT_DST="${3}/${1}"
mkdir "/Library/Audio/Plug-Ins/HAL"
echo "doInstallDriverFile: ${KEXT_SRC}  -->  ${KEXT_TMP}  -->  ${KEXT_DST}"
if [ ! -z "${1}" ] && [ -d "${KEXT_SRC}" ] && [ -f "${KEXT_SRC}/Contents/Info.plist" ] && [ -d "${3}" ] ; then
cp -rp "${KEXT_SRC}" "${KEXT_TMP}"
chown -R root:wheel "${KEXT_TMP}"
chmod -R 755 "${KEXT_TMP}"
mv "${KEXT_TMP}" "${KEXT_DST}"
fi
}


# Method called to perform installation.
doInstallDriver()
{
# remove current install files
doRemoveDriver

# we always install to /Library/Extensions, but only /System/Library/Extensions if running a pre-10.9 OS.
OS_PRODUCT_VERSION=`sw_vers -productVersion | cut -d . -f 2`

# install the new driver and load it
#if [ -z "${KEXT_NAM}" ] ; then
#
#doExitFailure "Undefined kext name"
#
#elif [ ${OS_PRODUCT_VERSION} -lt 9 ] ; then
#
## Running on 10.8 or older.
## Install the unsigned driver extension in to /System/Library/Extensions (this is the driver that is used).
#echo "Installing for OS 10.8 or earlier"
#doInstallDriverFile "${KEXT_NAM}" "${RESOURCE_DIR}/k106" "/System/Library/Extensions"
##doInstallDriverFile "${PLUG_NAM}" "${RESOURCE_DIR}/k106" "/System/Library/Extensions"
##kextload "/System/Library/Extensions/${KEXT_NAM}"
#touch "/System/Library/Extensions"
#
## Also install the signed driver to /Library/Extensions to cover future upgrades to 10.9.
#if [ -d "/Library/Audio/Plug-Ins/HAL" ] ; then
#doInstallDriverFile "${KEXT_NAM}" "${RESOURCE_DIR}/k109" "/Library/Audio/Plug-Ins/HAL"
##doInstallDriverFile "${PLUG_NAM}" "${RESOURCE_DIR}/k109" /Library/Audio/Plug-Ins/HAL
#fi
#
#else
#
## Running on 10.9 or newer. Install the signed driver in to /Library/Extensions.
#echo "Installing for OS 10.9 or later"
#doInstallDriverFile "${KEXT_NAM}" "${RESOURCE_DIR}/k109" "/Library/Audio/Plug-Ins/HAL"
##doInstallDriverFile "${PLUG_NAM}" "${RESOURCE_DIR}/k109" /Library/Audio/Plug-Ins/HAL
##kextload "/Library/Extensions/${KEXT_NAM}"
#touch "/Library/Audio/Plug-Ins/HAL"
#fi

if [ -z "${KEXT_NAM1}" ] ; then

doExitFailure "Undefined kext name"

elif [ ${OS_PRODUCT_VERSION} -lt 9 ] ; then

# Running on 10.8 or older.
# Install the unsigned driver extension in to /System/Library/Extensions (this is the driver that is used).
echo "Installing for OS 10.8 or earlier"
doInstallDriverFile "${KEXT_NAM1}" "${RESOURCE_DIR}/HPOfficeCastResources.bundle/Contents/Resources/HP_Video_Device_driver" "/System/Library/Extensions"
#doInstallDriverFile "${PLUG_NAM}" "${RESOURCE_DIR}/k106" "/System/Library/Extensions"
#kextload "/System/Library/Extensions/${KEXT_NAM}"
#touch "/Library/Audio/Plug-Ins/HAL"

sudo killall coreaudiod
sudo killall coreaudiod
    if  [ ${OS_PRODUCT_VERSION} -ge 15 ] ; then
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    fi
# Also install the signed driver to /Library/Extensions to cover future upgrades to 10.9.
if [ -d "/Library/Audio/Plug-Ins/HAL" ] ; then
doInstallDriverFile "${KEXT_NAM1}" "${RESOURCE_DIR}/HPOfficeCastResources.bundle/Contents/Resources/HP_Video_Device_driver" "/Library/Audio/Plug-Ins/HAL"
#doInstallDriverFile "${PLUG_NAM}" "${RESOURCE_DIR}/k109" /Library/Audio/Plug-Ins/HAL
sudo killall coreaudiod
sudo killall coreaudiod
    if  [ ${OS_PRODUCT_VERSION} -ge 15 ] ; then
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    fi

fi

else

# Running on 10.9 or newer. Install the signed driver in to /Library/Extensions.
echo "Installing for OS 10.9 or later"
doInstallDriverFile "${KEXT_NAM1}" "${RESOURCE_DIR}/HPOfficeCastResources.bundle/Contents/Resources/HP_Video_Device_driver" "/Library/Audio/Plug-Ins/HAL"
#doInstallDriverFile "${PLUG_NAM}" "${RESOURCE_DIR}/k109" /Library/Audio/Plug-Ins/HAL
#kextload "/Library/Extensions/${KEXT_NAM}"
#touch "/Library/Audio/Plug-Ins/HAL"

sudo killall coreaudiod
sudo killall coreaudiod
    if  [ ${OS_PRODUCT_VERSION} -ge 15 ] ; then
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    sudo killall coreaudiod
    fi

fi

}


# Method called to clean the audio installation.
doResetAudioSettings()
{
# rebuild the binding directory (this should be unnecessary, but...)
update_dyld_shared_cache -force

# clean protools databases and preferences
if [ -n "${ORIGINAL_HOME}" ] ; then
rm -rf "/Library/Application\ Support/Digidesign/Databases"
rm -f "${ORIGINAL_HOME}/Library/Preferences/com.digidesign.protools.plist"
rm -f "${ORIGINAL_HOME}/Library/Preferences/com.digidesign.protoolsLE.plist"
rm -rf "${ORIGINAL_HOME}/Library/Preferences/DAE Prefs"
rm -rf "${ORIGINAL_HOME}/Library/Preferences/DigiSetup.OSX"
fi

# remove device specific preferences - this will clear any user-device configuration.
rm -f "/Library/Preferences/com.apple.audio.DeviceSettings.plist"
rm -f "/Library/Preferences/com.apple.audio.SystemSettings.plist"
rm -f "/Library/Preferences/Audio/com.apple.audio.DeviceSettings.plist"
rm -f "/Library/Preferences/Audio/com.apple.audio.SystemSettings.plist"

# restart coreaudiod
COREAUDIO_PID=`ps -Af  | grep -v grep | grep coreaudiod | awk '{ print $1 }'`
echo "got pid ${COREAUDIO_PID}"
if [ -n "${COREAUDIO_PID}" ] ; then
echo 'killing coreaudiod PID ${COREAUDIO_PID}'
echo "kill -9 ${COREAUDIO_PID}"
kill -9 "${COREAUDIO_PID}"
fi
}



# Run the script.
#if [ ! -d "${RESOURCE_DIR}" ] ; then
#doExitFailure "Unable to access resource directory: ${RESOURCE_DIR}"
#elif [ ! -d "${RESOURCE_DIR}/k106/${KEXT_NAM}" ] && [ ! -d "${RESOURCE_DIR}/k109/${KEXT_NAM}" ] ; then
#doExitFailure "Missing install file: ${KEXT_NAM}"
#elif [ "${COMMAND}" = "install" ] ; then
#doInstallDriver
#doExitSuccess
#elif [ "${COMMAND}" = "remove" ] ; then
#doRemoveDriver
#doMoveToTrash "${APPLICATION}"
#doExitSuccess
#elif [ "${COMMAND}" = "resetaudiosettings" ] ; then
#doResetAudioSettings
#doExitSuccess
#else
#doExitFailure "unknown command: ${COMMAND}"
#fi


# Run the script.
if [ ! -d "${RESOURCE_DIR}" ] ; then
doExitFailure "Unable to access resource directory: ${RESOURCE_DIR}"
elif [ ! -d "${RESOURCE_DIR}/HPOfficeCastResources.bundle/Contents/Resources/HP_Video_Device_driver/${KEXT_NAM1}" ] && [ ! -d "${RESOURCE_DIR}/HPOfficeCastResources.bundle/Contents/Resources/HP_Video_Device_driver/${KEXT_NAM1}" ] ; then
doExitFailure "Missing install file: ${KEXT_NAM1}"
elif [ "${COMMAND}" = "install" ] ; then
doInstallDriver
doExitSuccess
elif [ "${COMMAND}" = "remove" ] ; then
doRemoveDriver
#doMoveToTrash "${APPLICATION}"
doExitSuccess
elif [ "${COMMAND}" = "resetaudiosettings" ] ; then
doResetAudioSettings
doExitSuccess
else
doExitFailure "unknown command: ${COMMAND}"
fi


