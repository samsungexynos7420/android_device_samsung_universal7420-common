#
# Copyright (C) 2020 The LineageOS Project
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

COMMON_PATH := device/samsung/universal7420-common

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(COMMON_PATH)/overlay
PRODUCT_ENFORCE_RRO_TARGETS := *
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += \
	device/samsung/universal7420-common/overlay/hardware/samsung/AdvancedDisplay

# Adb
PRODUCT_PRODUCT_PROPERTIES := \
	persist.adb.nonblocking_ffs=0 \
	ro.adb.nonblocking_ffs=0
	
# Additional native libraries
PRODUCT_COPY_FILES += \
	$(COMMON_PATH)/configs/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# AdvancedDisplay (MDNIE)
PRODUCT_PACKAGES += \
	AdvancedDisplay

# Atrace HAL
PRODUCT_PACKAGES += \
	android.hardware.atrace@1.0-service.universal7420

# Audio
PRODUCT_PACKAGES += \
	audio.primary.universal7420_32 \
	audio.a2dp.default \
	audio.r_submix.default \
	audio.usb.default \
	tinymix \
	libtinycompress \
	android.hardware.audio.service \
	android.hardware.audio@7.0-impl:32 \
	android.hardware.audio.effect@7.0-impl:32 \
	android.hardware.bluetooth.audio@2.0-impl:32 \
	audio.bluetooth.default
	
TARGET_EXCLUDES_AUDIOFX := true

PRODUCT_COPY_FILES += \
	frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
	frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration_7_0.xml \
	frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
	$(COMMON_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
	$(COMMON_PATH)/configs/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml

# Bluetooth
PRODUCT_PACKAGES += \
	android.hardware.bluetooth@1.0-impl:64 \
	android.hardware.bluetooth@1.0-service \
	libbt-vendor

# Boot animation
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := true
TARGET_BOOTANIMATION_HALF_RES := true
TARGET_SCREEN_HEIGHT := 2560
TARGET_SCREEN_WIDTH := 1440

# BSP
PRODUCT_PACKAGES += \
	memtrack.universal7420 \
	gralloc.exynos7420 \
	hwcomposer.universal7420 \
	libcsc \
	libfimg \
	libexynosscaler \
	libexynosgscaler \
	libhwc2on1adapter \
	libhwc2onfbadapter \
	libion \
	libion_exynos \
	libstagefrighthw \
	libExynosOMX_Core \
	libExynosOMX_Resourcemanager \
	libOMX.Exynos.MPEG4.Encoder \
	libOMX.Exynos.MPEG4.Decoder \
	libOMX.Exynos.AVC.Encoder \
	libOMX.Exynos.AVC.Decoder \
	libOMX.Exynos.HEVC.Encoder\
 	libOMX.Exynos.HEVC.Decoder \
 	libOMX.Exynos.VP9.Decoder \
 	libOMX.Exynos.VP8.Decoder \
 	libOMX.Exynos.VP8.Encoder

# Camera
PRODUCT_PACKAGES += \
	camera.exynos5 \
	android.hardware.camera.provider@2.5-service	

# Cgroups
PRODUCT_COPY_FILES += \
	$(COMMON_PATH)/configs/cgroups.json:$(TARGET_COPY_OUT_VENDOR)/etc/cgroups.json \
	$(COMMON_PATH)/configs/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json

# Charger
PRODUCT_PACKAGES += \
	libsuspend

# Debugging
# -include $(COMMON_PATH)/system_prop_debug.mk

# ConfigStore
PRODUCT_PACKAGES += \
	disable_configstore

# DRM
PRODUCT_PACKAGES += \
	android.hardware.drm@1.0-impl \
	android.hardware.drm@1.0-service \
	android.hardware.drm@1.4-service.clearkey

# DTB
PRODUCT_HOST_PACKAGES += \
	dtbhtoolExynos

# FastCharge
PRODUCT_PACKAGES += \
	vendor.lineage.fastcharge@1.0-service.samsung

# Filesystem tools for resizing system partitions
PRODUCT_PACKAGES += \
	e2fsck_static \
	resize2fs_static

# Fingerprint
PRODUCT_PACKAGES += \
	android.hardware.biometrics.fingerprint@2.3-service.samsung

# GNSS
PRODUCT_PACKAGES += \
	android.hardware.gnss@1.0-impl.universal7420 \
	android.hardware.gnss@1.0-service.universal7420
	
# Sensors
PRODUCT_COPY_FILES += \
	$(COMMON_PATH)/configs/gps/gps.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/gps.conf \
	$(COMMON_PATH)/configs/sensors/gps.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/gps.xml \
	$(COMMON_PATH)/configs/sensors/lhd.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/lhd.conf

# Graphics
PRODUCT_PACKAGES += \
	android.hardware.graphics.allocator@2.0-impl:64 \
	android.hardware.graphics.allocator@2.0-service \
	android.hardware.graphics.composer@2.1-service \
	android.hardware.graphics.mapper@2.0-impl-2.1
	
# Health
PRODUCT_PACKAGES += \
	android.hardware.health@2.1-impl \
	android.hardware.health@2.1-impl.recovery \
	android.hardware.health@2.1-service

# HIDL
PRODUCT_PACKAGES += \
	android.hidl.base@1.0 \
	android.hidl.manager@1.0 \
	libhidltransport \
	libhwbinder \
	vndservicemanager

# Gatekeeper
PRODUCT_PACKAGES += \
	android.hardware.gatekeeper@1.0-service \
	android.hardware.gatekeeper@1.0-impl
	
# Keymaster
PRODUCT_PACKAGES += \
	android.hardware.keymaster@3.0 \
	android.hardware.keymaster@3.0-impl \
	android.hardware.keymaster@3.0-service \
	libkeymaster3device
	
# Keylayouts
PRODUCT_COPY_FILES += \
	$(COMMON_PATH)/configs/keylayout/sec_touchkey.kl:system/usr/keylayout/sec_touchkey.kl \
	$(COMMON_PATH)/configs/keylayout/sec_touchscreen.kl:system/usr/keylayout/sec_touchscreen.kl \
	$(COMMON_PATH)/configs/idc/Synaptics_HID_TouchPad.idc:system/usr/idc/Synaptics_HID_TouchPad.idc \
	$(COMMON_PATH)/configs/idc/ft5x06_ts.idc:system/usr/idc/ft5x06_ts.idc \
	$(COMMON_PATH)/configs/idc/sec_touchscreen.idc:system/usr/idc/sec_touchscreen.idc
	
# Lights
PRODUCT_PACKAGES += \
	android.hardware.light-service.samsung

# Lineage Health
PRODUCT_PACKAGES += \
	vendor.lineage.health-service.default

# Livedisplay
PRODUCT_PACKAGES += \
	vendor.lineage.livedisplay@2.0-service.universal7420

# Memory
PRODUCT_PACKAGES += \
	android.hardware.memtrack@1.0-impl \
	android.hardware.memtrack@1.0-service

# Media profile
PRODUCT_COPY_FILES += \
	$(COMMON_PATH)/configs/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
	$(COMMON_PATH)/configs/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
	$(COMMON_PATH)/configs/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml

# Network
PRODUCT_PACKAGES += \
	netutils-wrapper-1.0

# NFC
PRODUCT_PACKAGES += \
	libnfc-nci \
	libnfc_nci_jni \
	NfcNci \
	Tag \
	com.android.nfc_extras \
	android.hardware.nfc@1.0-impl \
	android.hardware.nfc@1.0-service

PRODUCT_COPY_FILES += \
	$(COMMON_PATH)/configs/nfc/libnfc-sec-hal.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-sec-hal.conf \
	$(COMMON_PATH)/configs/nfc/libnfc-sec.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-sec.conf \
	$(COMMON_PATH)/configs/nfc/libnfc-brcm.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci.conf

# OMX
PRODUCT_PACKAGES += \
	android.hardware.media.omx@1.0-impl \
	android.hardware.media.omx@1.0-service

# Permissions
PRODUCT_COPY_FILES += \
	$(COMMON_PATH)/configs/permissions/com.samsung.permission.HRM_EXT.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.samsung.permission.HRM_EXT.xml \
	$(COMMON_PATH)/configs/permissions/com.sec.feature.spo2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.sec.feature.spo2.xml \
	frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
	frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
	frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
	frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
	frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
	frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
	frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
	frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
	frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
	frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
	frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
	frameworks/native/data/etc/android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.uicc.xml \
	frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml \
	frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
	frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
	frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
	frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
	frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
	frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
	frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
	frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
	frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
	frameworks/native/data/etc/android.hardware.sensor.heartrate.ecg.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.heartrate.ecg.xml \
	frameworks/native/data/etc/android.hardware.sensor.heartrate.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.heartrate.xml \
	frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml \
	frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
	frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
	frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
	frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
	frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
	frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
	frameworks/native/data/etc/android.software.sip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
	frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
	frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
	frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
	frameworks/native/data/etc/android.software.freeform_window_management.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.freeform_window_management.xml \
	frameworks/native/data/etc/android.software.picture_in_picture.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.picture_in_picture.xml

# Power
PRODUCT_PACKAGES += \
	android.hardware.power-service.samsung-libperfmgr

PRODUCT_COPY_FILES += \
	$(COMMON_PATH)/configs/power/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# Radio
PRODUCT_PACKAGES += \
	libxml2 \
	libprotobuf-cpp-full \
	libreference-ril \
	libril \
	libsecril-client \
	libsecril-client-sap \
	android.hardware.radio@1.0 \
	android.hardware.radio.deprecated@1.0 \
	modemloader \
	rild

# Copy stock APN config as lineage one seams to be quite broken and outdated
PRODUCT_COPY_FILES += \
	$(COMMON_PATH)/configs/ril/apns-conf.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/apns-conf.xml \
	$(COMMON_PATH)/configs/ril/spn-conf.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/spn-conf.xml

# Ramdisk
PRODUCT_PACKAGES += \
	init.battery.rc \
	init.power.rc \
	init.samsung.rc \
	init.samsungexynos7420.rc \
	init.samsungexynos7420.usb.rc \
	init.wifi.rc \
	fstab.samsungexynos7420 \
	init.baseband.rc \
	init.gps.rc \
	ueventd.samsungexynos7420.rc

# RCS
PRODUCT_PACKAGES += \
	com.android.ims.rcsmanager \
	PresencePolling \
	RcsService

# RenderScript
PRODUCT_PACKAGES += \
	android.hardware.renderscript@1.0-impl

# SamsungDoze
PRODUCT_PACKAGES += \
	SamsungDoze

# Sensors
PRODUCT_PACKAGES += \
	android.hardware.sensors@1.0-impl.samsung:64 \
	android.hardware.sensors@1.0-service

# Shims
PRODUCT_PACKAGES += \
	libcutils_shim \
	libstagefright_shim \
	libexynoscamera_shim \
	libbauthtzcommon_shim 

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
	$(COMMON_PATH) \
	hardware/google/interfaces \
	hardware/google/pixel \
	hardware/samsung/aidl/power-libperfmgr	

# Speed profile services and wifi-service to reduce RAM and storage
PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile
PRODUCT_USE_PROFILE_FOR_BOOT_IMAGE := true
PRODUCT_DEX_PREOPT_BOOT_IMAGE_PROFILE_LOCATION := frameworks/base/config/boot-image-profile.txt

# Touch
PRODUCT_PACKAGES += \
	vendor.lineage.touch@1.0-service.samsung

# Thermal
PRODUCT_PACKAGES += \
	android.hardware.thermal@2.0-service.samsung

PRODUCT_COPY_FILES += \
	$(COMMON_PATH)/configs/thermal/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json

# Trust
PRODUCT_PACKAGES += \
	vendor.lineage.trust@1.0-service

# USB
PRODUCT_PACKAGES += \
	android.hardware.usb@1.0-impl \
	android.hardware.usb@1.0-service.basic

# VNDK prebuilts
PRODUCT_COPY_FILES += \
	prebuilts/vndk/v29/arm64/arch-arm64-armv8-a/shared/vndk-core/libprotobuf-cpp-lite.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libprotobuf-cpp-lite-v29.so \
	prebuilts/vndk/v29/arm64/arch-arm-armv8-a/shared/vndk-core/libprotobuf-cpp-lite.so:$(TARGET_COPY_OUT_VENDOR)/lib/libprotobuf-cpp-lite-v29.so

# Vibrator
PRODUCT_PACKAGES += \
	android.hardware.vibrator-service.samsung

# Wifi
PRODUCT_PACKAGES += \
	hostapd \
	libnetcmdiface \
	libwpa_client \
	macloader \
	wificond \
	wifiloader \
	wifilogd \
	wlutil \
	TetheringConfigOverlay \
	wpa_supplicant \
	wpa_supplicant.conf \
	android.hardware.wifi@1.0 \
	android.hardware.wifi@1.0-impl \
	android.hardware.wifi@1.0-service

PRODUCT_COPY_FILES += \
	$(COMMON_PATH)/configs/wifi/cred.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/cred.conf \
	$(COMMON_PATH)/configs/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
	$(COMMON_PATH)/configs/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)

# call the proprietary setup
$(call inherit-product, vendor/samsung/universal7420-common/universal7420-common-vendor.mk)
