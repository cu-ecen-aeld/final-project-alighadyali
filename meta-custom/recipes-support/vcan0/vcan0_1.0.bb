DESCRIPTION = "Systemd service to set up vcan0 interface"
LICENSE = "CLOSED"

SRC_URI = "file://vcan0.service"

inherit systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} = "vcan0.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/vcan0.service ${D}${systemd_unitdir}/system
}

FILES_${PN} += "${systemd_unitdir}/system/vcan0.service"
