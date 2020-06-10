#!/bin/sh
#
# Problems? Sugestions? Contact me here: https://github.com/NoTengoBattery/openwrt/issues

UBI_ROOTFS=0
UBIBLOCK_ROOTFS=/sys/block/ubiblock0_0
UBI_ROOTFS_DATA=${UBI_ROOTFS}_1
ROOTFS_DATA_UBI=/dev/ubi${UBI_ROOTFS_DATA}
ROOTFS_DATA_NODE=2
ROOTFS_DATA=/tmp/.rootfs_data
ROOTFS_TRIG=${ROOTFS_DATA}/.trigger
ROOTFS_TGZ=${ROOTFS_DATA}/sysupgrade.tgz
UBI_SYSCFG=15
UBI_EXTROOT=${UBI_SYSCFG}_0
SYSCFG_UBI=/dev/ubi${UBI_SYSCFG}
SYSCFG_NODE=0
EXTROOT_UBI=/dev/ubi${UBI_EXTROOT}
EXTROOT_NODE=1
EXTROOT=/tmp/.extroot

. /lib/functions.sh

ubi_rebuild() {
    local UBI=$1
    ubiupdatevol "$UBI" -t
}

ubi_attach() {
  case $(board_name) in
  'linksys,ea6350v3')
    ubiattach -m $UBI_SYSCFG -d $UBI_SYSCFG &> /dev/null
    node=$(awk '/'"ubi$UBI_SYSCFG"'/{print $1}' /proc/devices)
    if [ "x$node" != "x" ]; then
      mknod -m 600 $SYSCFG_UBI  c $node $SYSCFG_NODE &> /dev/null
      mknod -m 600 $EXTROOT_UBI c $node $EXTROOT_NODE &> /dev/null
    fi
    node=$(awk '/'"ubi$UBI_ROOTFS"'/{print $1}' /proc/devices)
    if [ "x$node" != "x" ]; then
      mknod -m 600 $ROOTFS_DATA_UBI c $node $ROOTFS_DATA_NODE &> /dev/null
    fi
    mkdir -p $ROOTFS_DATA $EXTROOT
    mount -t ubifs $ROOTFS_DATA_UBI $ROOTFS_DATA || ubi_rebuild $ROOTFS_DATA_UBI
    mount -t ubifs $ROOTFS_DATA_UBI $ROOTFS_DATA &> /dev/null
    if [ ! -f "$ROOTFS_TRIG" ]; then
      printf "- Trigger file not found: sysupgrade -\n"
      mount -t ubifs $EXTROOT_UBI $EXTROOT || ubi_rebuild $EXTROOT_UBI
      mount -t ubifs $EXTROOT_UBI $EXTROOT &> /dev/null
      if [ "x$KEEP_EXTROOT" != "xyes" ]; then rm -rf $EXTROOT; fi
      cp -ar $ROOTFS_TGZ $EXTROOT &> /dev/null
      touch $ROOTFS_TRIG
    fi
    umount $EXTROOT &&     rm -r $EXTROOT &> /dev/null
    umount $ROOTFS_DATA && rm -r $ROOTFS_DATA &> /dev/null
    ;;
  esac
}

boot_hook_add preinit_main ubi_attach
boot_hook_add failsafe ubi_attach
