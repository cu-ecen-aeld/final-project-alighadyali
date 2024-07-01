# can ifup wlan0 at startup to enable wifi.
DESCRIPTION = "Systemd service to set up wlan0 interface"
LICENSE = "CLOSED"

SRC_URI = "file://ifup-wlan0.service"

inherit systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} = "ifup-wlan0.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/ifup-wlan0.service ${D}${systemd_unitdir}/system
}

FILES_${PN} += "${systemd_unitdir}/system/ifup-wlan0.service"
