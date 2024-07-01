# fragment added to /etc/network/interfaces that calls wlan0 which 
# did not work, need to figure this out
LICENSE = "CLOSED"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://interfaces-fragment"

do_install:append() {
    install -d ${D}${sysconfdir}/network/interfaces.d
    install -m 0644 ${WORKDIR}/interfaces-fragment ${D}${sysconfdir}/network/interfaces.d/interfaces-fragment
}