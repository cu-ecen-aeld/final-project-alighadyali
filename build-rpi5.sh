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

# add custom configurations
CONF_MACHINE="MACHINE = \"raspberrypi5\""
CONF_LICENSE_FLAGS_ACCEPTED="LICENSE_FLAGS_ACCEPTED = \"synaptics-killswitch\""

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

# set -e
# bitbake core-image-base
