DESCRIPTION = "Docker Compose Application Service"
LICENSE = "CLOSED"
SRC_URI = "file://docker-compose.yml \
    file://cansim-mqtt.service"

# S = "${WORKDIR}"

# do_install() {
#     install -d ${D}/etc/cansim-mqtt
#     install -m 0644 ${S}/cansim-mqtt.yml ${D}/etc/cansim-mqtt/cansim-mqtt.yml

#     install -d ${D}/etc/systemd/system
#     install -m 0644 ${WORKDIR}/cansim-mqtt.service ${D}/etc/systemd/system/cansim-mqtt.service
# }

# FILES_${PN} += "/etc/cansim-mqtt/cansim-mqtt.yml /etc/systemd/system/cansim-mqtt.service"

# SYSTEMD_SERVICE_${PN} = "cansim-mqtt.service"

inherit systemd
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} = "cansim-mqtt.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}/etc/cansim-mqtt
    install -m 0644 ${WORKDIR}/docker-compose.yml ${D}/etc/cansim-mqtt/docker-compose.yml
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/cansim-mqtt.service ${D}${systemd_unitdir}/system

}

FILES_${PN} += "${systemd_unitdir}/system/cansim-mqtt.service"