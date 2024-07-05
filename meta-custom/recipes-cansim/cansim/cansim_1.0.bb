DESCRIPTION = "A simple CAN message sender"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file:///home/alig/cansim"
SRC_URI += "file://cansim.service"

inherit systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} = "cansim.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

S = "${WORKDIR}/home/alig/cansim"
inherit cmake

do_configure:prepend() {
    rm -rf ${B}/*
}

do_compile () {
    cmake ${S}
    cmake --build ${B}
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/cansim ${D}${bindir}

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/cansim.service ${D}${systemd_unitdir}/system
}

FILES_${PN} += "${systemd_unitdir}/system/cansim.service"