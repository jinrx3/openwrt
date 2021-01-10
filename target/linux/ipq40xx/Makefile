include $(TOPDIR)/rules.mk

ARCH:=arm
BOARD:=ipq40xx
BOARDNAME:=Qualcomm Atheros IPQ40XX
FEATURES:=squashfs fpu ramdisk nand
CPU_TYPE:=cortex-a7
CPU_SUBTYPE:=neon-vfpv4
SUBTARGETS:=generic

KERNEL_PATCHVER:=5.4
KERNEL_TESTING_PATCHVER:=5.4

KERNELNAME:=zImage Image dtbs

include $(INCLUDE_DIR)/target.mk
DEFAULT_PACKAGES += \
	ath10k-firmware-qca4019-ct \
	kmod-ath10k-ct-smallbuffers \
	kmod-gpio-button-hotplug \
	kmod-leds-gpio \
	kmod-usb-dwc3 \
	kmod-usb-dwc3-qcom \
	kmod-usb3 \
	swconfig \
	wpad-openssl

$(eval $(call BuildTarget))
