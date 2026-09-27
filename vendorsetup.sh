#!/bin/bash

#Clone Device Kernel Tree
git clone -b sixteen https://github.com/KimelaZX/device_itel_S666LN-kernel device/itel/S666LN-kernel

#Clone Common Kernel Tree
git clone https://github.com/MillenniumOSS/android_device_millennium_common-kernel device/millennium/common-kernel

#Clone Vendor Tree
git clone -b lineage-23.2 https://github.com/arundaya-project/vendor_itel_S666LN vendor/itel/S666LN

#Clone Hardware Mediatek Tree
git clone -b sixteen https://github.com/KimelaZX/android_hardware_mediatek hardware/mediatek

#Clone Hardware Millenium Tree
git clone https://github.com/swaraloka-lab/hardware_millennium -b sixteen hardware/millennium

#Clone Millenium IMS Tree
git clone https://github.com/MillenniumOSS/android_vendor_mediatek_ims -b sixteen-oem vendor/mediatek/ims

#Clone Millenium Mediatek Sepol
git clone https://github.com/MillenniumOSS/android_device_mediatek_sepolicy_vndr -b sixteen-qpr2 device/mediatek/sepolicy_vndr


RET=0
echo "- Applying WPA3 Patch"
cd external/wpa_supplicant_8
curl https://raw.githubusercontent.com/KimelaZX/patches/refs/heads/sixteen/external/wpa_supplicant_8/do_not_set_NL80211_WPA_VERSION_3.patch | git am || {
  RET=$?
  git am --abort >/dev/null 2>&1
}
cd ../../

echo "- Applying fenrir compatiblity patches"
cd system/core
curl https://raw.githubusercontent.com/MillenniumOSS/patches/refs/heads/sixteen/system/core/0001-libfs_avb-Allow-LKs-patched-with-fenrir-to-boot-on-A.patch | git am || {
  RET=1
  git am --abort >/dev/null 2>&1
}
curl https://raw.githubusercontent.com/MillenniumOSS/patches/refs/heads/sixteen/system/core/0002-fastbootd-Always-return-false-for-GetDeviceLockStatu.patch | git am || {
  RET=1
  git am --abort >/dev/null 2>&1
}
cd ../../

if [ $RET -ne 0 ]; then
  echo "ERROR: Patch is not applied! Maybe it's already patched, or you'll have to adapt it to this specific rom source?"
else
  echo "OK: All patched"
fi
