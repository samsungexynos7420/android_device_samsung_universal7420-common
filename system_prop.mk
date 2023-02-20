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

#
# Bluetooth props
#
PRODUCT_PROPERTY_OVERRIDES += \
	bluetooth.device.class_of_device?=90,2,12 \
	bluetooth.profile.asha.central.enabled?=true \
	bluetooth.profile.a2dp.source.enabled?=true \
	bluetooth.profile.avrcp.target.enabled?=true \
	bluetooth.profile.bas.client.enabled?=true \
	bluetooth.profile.gatt.enabled?=true \
	bluetooth.profile.hfp.ag.enabled?=true \
	bluetooth.profile.hid.device.enabled?=true \
	bluetooth.profile.hid.host.enabled?=true \
	bluetooth.profile.map.server.enabled?=true \
	bluetooth.profile.opp.enabled?=true \
	bluetooth.profile.pan.nap.enabled?=true \
	bluetooth.profile.pan.panu.enabled?=true \
	bluetooth.profile.pbap.server.enabled?=true \
	bluetooth.profile.sap.server.enabled?=true

#
# Board
#
PRODUCT_PROPERTY_OVERRIDES += \
	ro.chipname=exynos7420 \
	ro.arch=exynos7420
	
	
# SoC
PRODUCT_PROPERTY_OVERRIDES += \
	ro.soc.manufacturer=Samsung \
	ro.soc.model=Exynos 7420

#
# Dalvik
#
PRODUCT_PROPERTY_OVERRIDES += \
	dalvik.vm.image-dex2oat-filter=speed \
	dalvik.vm.dex2oat-filter=speed \
	dalvik.vm.heapgrowthlimit=256m \
	dalvik.vm.heapstartsize=8m \
	dalvik.vm.heapsize=512m \
	dalvik.vm.heaptargetutilization=0.75 \
	dalvik.vm.heapminfree=512k \
	dalvik.vm.heapmaxfree=8m \
	dalvik.vm.dex2oat64.enabled=true

#
# Ril
#
PRODUCT_PROPERTY_OVERRIDES += \
	persist.radio.add_power_save=1 \
	persist.radio.apm_sim_not_pwdn=1 \
	vendor.rild.libpath=/system/vendor/lib64/libsec-ril.so \
	vendor.rild.libpath2=/system/vendor/lib64/libsec-ril-dsds.so \
	telephony.lteOnGsmDevice=1 \
	telephony.lteOnCdmaDevice=0 \
	ro.telephony.default_network=9 \
	ro.use_data_netmgrd=false \
	persist.data.netmgrd.qos.enable=false \
	ro.ril.hsxpa=1 \
	ro.ril.telephony.mqanelements=6 \
	ro.ril.gprsclass=10

#
# OMX
#
PRODUCT_PROPERTY_OVERRIDES += \
	debug.stagefright.ccodec=0 \
	debug.stagefright.omx_default_rank=0 \
	debug.stagefright.omx_default_rank.sw-audio=1

#
# Miracast (Wireless Display)
#
PRODUCT_PROPERTY_OVERRIDES += \
	wlan.wfd.hdcp=disable \
	persist.debug.wfd.enable=1 \
	persist.sys.wfd.virtual=0

#
# NFC
#
PRODUCT_PROPERTY_OVERRIDES += \
	ro.nfc.sec_hal=true \
	ro.nfc.fw_dl_on_boot=false

#
# HWC
#
PRODUCT_PROPERTY_OVERRIDES += \
	debug.sf.latch_unsignaled=1 \
	debug.hwc.winupdate=1
	debug.sf.disable_backpressure=1 \
	ro.surface_flinger.max_frame_buffer_acquired_buffers=3 \
	debug.sf.predict_hwc_composition_strategy=0
	
#
# Graphics
#
PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=196610 \
	ro.hardware.egl=mali

#
# SLSI
#
PRODUCT_PROPERTY_OVERRIDES += \
	debug.slsi_platform=1

#
# Audio
#
PRODUCT_PROPERTY_OVERRIDES += \
	aaudio.hw_burst_min_usec=2000 \
	aaudio.mmap_exclusive_policy=2 \
	aaudio.mmap_policy=2 \
	af.fast_track_multiplier=1 \
	ro.vendor.audio_hal.force_voice_config=wide

#
# Vendor Security Patch Level
#
PRODUCT_PROPERTY_OVERRIDES += \
	ro.lineage.build.vendor_security_patch=2021-09-01

#
# Wi-Fi
#
PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0 \
	wifi.direct.interface=p2p-dev-wlan0

#
# USB
#
PRODUCT_PROPERTY_OVERRIDES += \
	ro.adb.nonblocking_ffs=0 \
	persist.adb.nonblocking_ffs=0 \
	sys.usb.ffs.aio_compat=1
	
# System
PRODUCT_PROPERTY_OVERRIDES += \
	persist.sys.binary_xml=false
	

# BPF
PRODUCT_PROPERTY_OVERRIDES += \
	ro.kernel.ebpf.supported=false
