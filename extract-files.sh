#!/bin/bash
#
# Copyright (C) 2020 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

VENDOR=samsung
DEVICE_COMMON=universal7420-common

# Load extractutils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi


# Initialize the helper
setup_vendor "${DEVICE_COMMON}" "${VENDOR}" "${ANDROID_ROOT}" true "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

# Fix proprietary blobs
BLOB_ROOT="$ANDROID_ROOT"/vendor/"$VENDOR"/"$DEVICE_COMMON"/proprietary

"${PATCHELF}" --replace-needed libgui.so libsensor.so $BLOB_ROOT/bin/gpsd

"${PATCHELF}" --remove-needed vendor.samsung.hardware.nfc@1.0.so $BLOB_ROOT/vendor/lib/hw/nfc_nci.default.so
"${PATCHELF}" --remove-needed vendor.samsung.hardware.nfc@1.0.so $BLOB_ROOT/vendor/lib64/hw/nfc_nci.default.so

# replace SSLv3_client_method with SSLv23_method
sed -i "s/SSLv3_client_method/SSLv23_method\x00\x00\x00\x00\x00\x00/" $BLOB_ROOT/bin/gpsd

# RIL patches
xxd -p -c0 $BLOB_ROOT/proprietary/vendor/lib64/libsec-ril-dsds.so | sed "s/600e40f9820c8052e10315aae30314aa/600e40f9820c8052e10315aa030080d2/g" | xxd -r -p > $BLOB_ROOT/proprietary/vendor/lib64/libsec-ril-dsds.so.patched
mv $BLOB_ROOT/proprietary/vendor/lib64/libsec-ril-dsds.so.patched $BLOB_ROOT/proprietary/vendor/lib64/libsec-ril-dsds.so

xxd -p -c0 $BLOB_ROOT/proprietary/vendor/lib64/libsec-ril.so | sed "s/600e40f9820c8052e10315aae30314aa/600e40f9820c8052e10315aa030080d2/g" | xxd -r -p > $BLOB_ROOT/proprietary/vendor/lib64/libsec-ril.so.patched
mv $BLOB_ROOT/proprietary/vendor/lib64/libsec-ril.so.patched $BLOB_ROOT/proprietary/vendor/lib64/libsec-ril.so

# Replace libvndsecril-client with libsecril-client
"${PATCHELF}" --replace-needed libvndsecril-client.so libsecril-client.so $BLOB_ROOT/vendor/lib/libwrappergps.so
"${PATCHELF}" --replace-needed libvndsecril-client.so libsecril-client.so $BLOB_ROOT/vendor/lib64/libwrappergps.so

# Replace libutils with libutils-v32
"${PATCHELF}" --replace-needed libutils.so libutils-v32.so $BLOB_ROOT/vendor/bin/hw/gpsd
"${PATCHELF}" --replace-needed libutils.so libutils-v32.so $BLOB_ROOT/vendor/bin/hw/lhd
"${PATCHELF}" --replace-needed libutils.so libutils-v32.so $BLOB_ROOT/vendor/lib/libexynoscamera.so
"${PATCHELF}" --replace-needed libutils.so libutils-v32.so $BLOB_ROOT/vendor/lib/libexynoscamera3.so
"${PATCHELF}" --replace-needed libutils.so libutils-v32.so $BLOB_ROOT/vendor/lib64/libexynoscamera.so
"${PATCHELF}" --replace-needed libutils.so libutils-v32.so $BLOB_ROOT/vendor/lib64/libexynoscamera3.so

"${MY_DIR}/setup-makefiles.sh"
