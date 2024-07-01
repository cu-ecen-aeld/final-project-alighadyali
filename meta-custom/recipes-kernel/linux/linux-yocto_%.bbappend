# recipe to add saved kernel settings so I do not have to run menu config again
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Ensure the kernel source tree is clean before configuration
do_configure:prepend() {
    oe_runmake mrproper
}

SRC_URI += "file://customkernel_defconfig"

do_configure:prepend() {
    cp ${WORKDIR}/customkernel_defconfig ${S}/.config
}
