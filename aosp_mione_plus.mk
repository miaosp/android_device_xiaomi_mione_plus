#
# Copyright (C) 2012 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# common msm8660 configs
$(call inherit-product, device/xiaomi/msm8660-common/msm8660.mk)

$(call inherit-product-if-exists, vendor/xiaomi/mione_plus/mione_plus-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/xiaomi/mione_plus/overlay

#add superuser
SUPERUSER_EMBEDDED := true

# GPS and Light
PRODUCT_PACKAGES += \
    gps.mione \
    lights.mione \
    Superuser \
    su

# Launcher3
PRODUCT_PACKAGES += \
    Launcher3

# gps.conf
PRODUCT_COPY_FILES += \
    device/xiaomi/mione_plus/configs/gps.conf:system/etc/gps.conf

# mac support for mione_plus
# credit: huangqiwu
# https://github.com/mirom/android_device_xiaomi_mione_plus/commit/cf62e83ee96d90f0735c56b85fb8e252574c644d
PRODUCT_PACKAGES += \
    libreadmac

# Hostapd (Required for Wi-Fi)
PRODUCT_PACKAGES += \
    hostapd_cli \
    calibrator \
    hostapd

PRODUCT_PACKAGES += \
	  dualboot_init

# Dualboot
PRODUCT_COPY_FILES += \
    device/xiaomi/mione_plus/recovery/mount_ext4_default.sh:recovery/root/res/dualboot/mount_ext4_default.sh \
    device/xiaomi/mione_plus/recovery/mount_ext4_tdb.sh:recovery/root/res/dualboot/mount_ext4_tdb.sh

# Ramdisk files
PRODUCT_COPY_FILES += \
    device/xiaomi/mione_plus/ramdisk/init.mione.rc:root/init.mione.rc \
    device/xiaomi/mione_plus/ramdisk/init.qcom.rc:root/init.qcom.rc \
    device/xiaomi/mione_plus/ramdisk/init.qcom.sh:root/init.qcom.sh \
    device/xiaomi/mione_plus/ramdisk/init.qcom.usb.rc:root/init.qcom.usb.rc \
    device/xiaomi/mione_plus/ramdisk/init.qcom.usb.sh:root/init.qcom.usb.sh \
    device/xiaomi/mione_plus/ramdisk/init.target.rc:root/init.target.rc \
    device/xiaomi/mione_plus/ramdisk/ueventd.mione.rc:root/ueventd.mione.rc \
    device/xiaomi/mione_plus/ramdisk/fstab.mione:root/fstab.mione \
    device/xiaomi/mione_plus/ramdisk/sbin/chargeonlymode:root/sbin/chargeonlymode

# wifi
PRODUCT_COPY_FILES += \
    device/xiaomi/mione_plus/configs/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf

# Input device config
PRODUCT_COPY_FILES += \
    device/xiaomi/mione_plus/configs/mxt224_ts_input.idc:system/usr/idc/synaptics_rmi4_i2c.idc \
    device/xiaomi/mione_plus/configs/mxt224_ts_input.idc:system/usr/idc/ft5x0x.idc \
    device/xiaomi/mione_plus/configs/mxt224_ts_input.idc:system/usr/idc/sensor00fn11.idc \
    device/xiaomi/mione_plus/configs/mxt224_ts_input.idc:system/usr/idc/sensor00fn54.idc \
    device/xiaomi/mione_plus/configs/mxt224_ts_input.idc:system/usr/idc/mxt224_ts_input.idc \
    device/xiaomi/mione_plus/configs/mxt224_ts_input.idc:system/usr/idc/mXT-touch.idc

# Kernel modules
ifeq ($(TARGET_PREBUILT_KERNEL),)
PRODUCT_COPY_FILES += $(shell \
    find device/xiaomi/mione_plus/prebuilt -name '*.ko' \
    | sed -r 's/^\/?(.*\/)([^/ ]+)$$/\1\2:system\/lib\/modules\/\2/' \
    | tr '\n' ' ')
endif

#$(shell mkdir -p $(OUT)/target/common/obj/JAVA_LIBRARIES/android_webview_java_intermediates)

#add prebuilt webviewchromium
PRODUCT_COPY_FILES += \
    device/xiaomi/mione_plus/prebuilt/webviewchromium.jar:system/framework/webviewchromium.jar \
    device/xiaomi/mione_plus/prebuilt/libwebviewchromium.so:system/lib/libwebviewchromium.so  \
    device/xiaomi/mione_plus/prebuilt/libwebviewchromium_plat_support.so:system/lib/libwebviewchromium_plat_support.so  \
    device/xiaomi/mione_plus/prebuilt/symbols/libwebviewchromium.so:symbols/system/lib/libwebviewchromium.so \
    device/xiaomi/mione_plus/prebuilt/symbols/libwebviewchromium_plat_support.so:symbols/system/lib/libwebviewchromium_plat_support.so

    

src_files := $(shell ls $(LOCAL_PATH)/prebuilt/webview/paks )
PRODUCT_COPY_FILES += $(foreach file, $(src_files), \
        $(LOCAL_PATH)/prebuilt/webview/paks/$(file):system/framework/webview/paks/$(file))
        

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dexopt-flags=m=y

# we don't have selinux now
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=0

# xiaomi mione wifi config
$(call inherit-product, device/xiaomi/mione_plus/mione_bcm43xx.mk)

# dalvik tweak
$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)
