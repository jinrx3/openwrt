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
	ath10k-firmware-qca4019-ct-full-htt \
	kmod-ath10k-ct \
	kmod-gpio-button-hotplug \
	kmod-leds-gpio \
	kmod-usb-dwc3 \
	kmod-usb-dwc3-qcom \
	kmod-usb3 \
	swconfig \
	wpad-openssl
DEFAULT_PACKAGES += \
	bash \
	blkid \
	block-mount \
	bzip2 \
	ca-certificates \
	chrt \
	ethtool \
	gawk \
	haveged \
	ipset \
	kmod-fs-exfat \
	kmod-fs-ext4 \
	kmod-fs-f2fs \
	kmod-fs-msdos \
	kmod-nft-offload \
	kmod-io-schedulers \
	kmod-usb-storage-extras \
	kmod-usb-storage-uas \
	lsblk \
	luci-app-advanced-reboot \
	luci-app-compressed-memory \
	luci-app-sqm \
	luci-app-uhttpd \
	luci-app-unbound \
	luci-mod-dashboard \
	luci-ssl-openssl \
	luci-theme-openwrt-2020 \
	mount-utils \
	nano \
	ntfs-3g-utils \
	openssh-sftp-server \
	shadow-chsh \
	shadow-groupadd \
	shadow-groupdel \
	shadow-nologin \
	shadow-useradd \
	shadow-userdel \
	shadow-utils \
	sudo \
	unbound-control

$(eval $(call BuildTarget))
