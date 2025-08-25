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

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE_RELATIVE_PATH := hw

LOCAL_SHARED_LIBRARIES := \
    libbase \
    libbinder \
    libutils \
    android.hardware.power-V1-ndk_platform \
    libbinder_ndk

LOCAL_SRC_FILES := \
    Power.cpp \
    main.cpp

LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/include \
    hardware/samsung/aidl/light/include

LOCAL_STATIC_LIBRARIES := libc++fs

LOCAL_MODULE := android.hardware.power-service.universal7420
LOCAL_INIT_RC := android.hardware.power-service.universal7420.rc
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := samsung
LOCAL_CFLAGS += -Wno-unused-parameter -Wno-unused-variable
LOCAL_VENDOR_MODULE := true
LOCAL_VINTF_FRAGMENTS := android.hardware.power-service.universal7420.xml

include $(BUILD_EXECUTABLE)
