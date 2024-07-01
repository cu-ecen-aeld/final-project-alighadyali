#!/bin/bash
# Script to build image for qemu.
# Ali Ghadyali

git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env rpi-build

# function to check if bibake layer exists and if not add it
add_bitbake_layer() {
    local layer=$1
    local path=$2
    bitbake-layers show-layers | grep "$layer" >/dev/null
    layer_info=$?

    if [ $layer_info -ne 0 ]; then
        echo "Adding $layer layer"
        bitbake-layers add-layer "$path"
    else
        echo "$layer layer already exists"
    fi
}

add_bitbake_layer "meta-oe" "../meta-openembedded/meta-oe"
add_bitbake_layer "meta-python" "../meta-openembedded/meta-python"
add_bitbake_layer "meta-networking" "../meta-openembedded/meta-networking"
add_bitbake_layer "meta-filesystems" "../meta-openembedded/meta-filesystems"
add_bitbake_layer "meta-virtualization" "../meta-virtualization"
add_bitbake_layer "meta-raspberrypi" "../meta-raspberrypi"
add_bitbake_layer "meta-custom" "../meta-custom"

# add custom configurations
CONF_MACHINE="MACHINE = \"raspberrypi5\""
CONF_LICENSE_FLAGS_ACCEPTED="LICENSE_FLAGS_ACCEPTED = \"synaptics-killswitch\""

CONF_IMAGE_INSTALL_append="IMAGE_INSTALL:append = \" spdlog-dev docker docker-compose ca-certificates\
 linux-firmware-rpidistro-bcm43430 wireless-regdb-static openssh v4l-utils\
 python3 ntp wpa-supplicant iw vcan0 can-utils ifup-wlan0\""

# Enable systemd as the init manager
CONF_DISTRO_FEATURES_append="DISTRO_FEATURES:append = \" systemd usrmerge virtualization wifi\""
CONF_VIRTUAL_RUNTIME_init_manager="VIRTUAL-RUNTIME_init_manager = \"systemd\""
CONF_VIRTUAL_RUNTIME_initscripts="VIRTUAL-RUNTIME_initscripts = \"systemd-compat-units\""
CONF_CORE_IMAGE_EXTRA_INSTALL="CORE_IMAGE_EXTRA_INSTALL += \" kernel-modules\""

# Optionally, disable SysVinit
CONF_DISTRO_FEATURES_BACKFILL_CONSIDERED="DISTRO_FEATURES_BACKFILL_CONSIDERED = \"sysvinit\""
CONF_DISTRO_FEATURES_REMOVE="DISTRO_FEATURES_REMOVE = \"sysvinit\""
# need ssh
CONF_IMAGE_FEATURES="IMAGE_FEATURES += \"ssh-server-openssh\""
CONF_WIRELESS_REGDOM="WIRELESS_REGDOM = \"US\""

# add features to local.conf
append_to_local_conf() {
    local layer=$1
    cat conf/local.conf | grep "${layer}" >/dev/null
    local exists=$?

    if [ "$exists" -ne 0 ]; then
        echo "Append $layer in the local.conf file"
        echo "$layer" >>conf/local.conf
    else
        echo "$layer already exists in the local.conf file"
    fi
}

append_to_local_conf "${CONF_MACHINE}"
append_to_local_conf "${CONF_LICENSE_FLAGS_ACCEPTED}"
append_to_local_conf "${CONF_IMAGE_INSTALL_append}"
append_to_local_conf "${CONF_DISTRO_FEATURES_append}"
append_to_local_conf "${CONF_VIRTUAL_RUNTIME_init_manager}"
append_to_local_conf "${CONF_VIRTUAL_RUNTIME_initscripts}"
append_to_local_conf "${CONF_CORE_IMAGE_EXTRA_INSTALL}"
append_to_local_conf "${CONF_DISTRO_FEATURES_BACKFILL_CONSIDERED}"
append_to_local_conf "${CONF_DISTRO_FEATURES_REMOVE}"
append_to_local_conf "${CONF_IMAGE_FEATURES}"
append_to_local_conf "${CONF_WIRELESS_REGDOM}"

set -e
bitbake core-image-base
