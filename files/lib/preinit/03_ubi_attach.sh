#!/bin/sh
#
# Problems? Sugestions? Contact me here: https://github.com/NoTengoBattery/openwrt/issues
#
# This script runs before mouting the overlay root filesystem, and it exist to
# create the node for the "syscfg" partition (so it can be used as overlay).

OVERLAY=/tmp/.overlay
OVERLAY_NODE=1
ROOTFS_DATA=/tmp/.rootfs_data
ROOTFS_CFG=${ROOTFS_DATA}/upper/etc/config
ROOTFS_DATA_NODE=2
ROOTFS_TGZ=${ROOTFS_DATA}/sysupgrade.tgz
ROOTFS_TRIG=${ROOTFS_DATA}/.trigger
SYSCFG_NODE=0
UBI_ROOTFS=0
UBI_ROOTFS_DATA=${UBI_ROOTFS}_1
ROOTFS_DATA_UBI=/dev/ubi${UBI_ROOTFS_DATA}
UBI_ROOTFS_PART=${UBI_ROOTFS}_0
UBIBLOCK_ROOTFS=/sys/block/ubiblock${UBI_ROOTFS_PART}
UBI_SYSCFG=15
UBI_OVERLAY=${UBI_SYSCFG}_0
OVERLAY_UBI=/dev/ubi${UBI_OVERLAY}
SYSCFG_UBI=/dev/ubi${UBI_SYSCFG}
BOOTFS=/bootfs

. /lib/functions.sh

ubi_rebuild() {
    local UBI=$1
    ubiupdatevol "$UBI" -t
}

ubi_attach() {
  exec &> /dev/null
  case $(board_name) in
  'linksys,ea6350v3')
    ubiattach -m $UBI_SYSCFG -d $UBI_SYSCFG
    node=$(awk '/'"ubi$UBI_SYSCFG"'/{print $1}' /proc/devices)
    if [ "x$node" != "x" ]; then
      mknod -m 600 $SYSCFG_UBI  c $node $SYSCFG_NODE
      mknod -m 600 $OVERLAY_UBI c $node $OVERLAY_NODE
    fi
    node=$(awk '/'"ubi$UBI_ROOTFS"'/{print $1}' /proc/devices)
    if [ "x$node" != "x" ]; then
      mknod -m 600 $ROOTFS_DATA_UBI c $node $ROOTFS_DATA_NODE
    fi
    mkdir -p "$ROOTFS_DATA" "$OVERLAY"
    mount -t ubifs $ROOTFS_DATA_UBI $ROOTFS_DATA || ubi_rebuild $ROOTFS_DATA_UBI
    mount -t ubifs $ROOTFS_DATA_UBI $ROOTFS_DATA
    if [ ! -f "$ROOTFS_TRIG" ]; then
      mount -t ubifs $OVERLAY_UBI $OVERLAY || ubi_rebuild $OVERLAY_UBI
      mount -t ubifs $OVERLAY_UBI $OVERLAY
      rm -rf $OVERLAY
      cp -ar $ROOTFS_TGZ $OVERLAY
      rm -rf $ROOTFS_DATA
      touch $ROOTFS_TRIG
    fi
    umount $OVERLAY &&     rm -r $OVERLAY
    umount $ROOTFS_DATA && rm -r $ROOTFS_DATA
    mount -t ubifs -o 'bulk_read,compr=zstd' $ROOTFS_DATA_UBI $BOOTFS
    mount -t pstore pstore /sys/fs/pstore
    ;;
  esac
}

boot_hook_add preinit_main ubi_attach
boot_hook_add failsafe ubi_attach
