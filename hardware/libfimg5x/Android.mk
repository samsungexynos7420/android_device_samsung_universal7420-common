#
# Copyright 2012, Samsung Electronics Co. LTD
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES:= \
	FimgApi.cpp   \
	FimgExynos5.cpp

LOCAL_C_INCLUDES += \
	$(LOCAL_PATH)/include

ifeq ($(filter 3.18, $(TARGET_LINUX_KERNEL_VERSION)), 3.18)
LOCAL_C_INCLUDES += $(TOP)/hardware/samsung_slsi/exynos/kernel-3.18-headers
endif

LOCAL_SHARED_LIBRARIES:= liblog libutils libbinder

LOCAL_MODULE:= libfimg

LOCAL_PRELINK_MODULE := false

include $(TOP)/hardware/samsung_slsi-linaro/exynos/BoardConfigCFlags.mk
include $(BUILD_SHARED_LIBRARY)
