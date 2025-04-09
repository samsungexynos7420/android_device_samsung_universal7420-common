/*
 *    Copyright (C) 2013 SAMSUNG S.LSI
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at:
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 *   Author: Woonki Lee <woonki84.lee@samsung.com>
 *   Version: 2.0
 *
 */

#include <hardware/nfc.h>

#include <cutils/properties.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

#include "hal.h"
#include "hal_msg.h"
#include "osi.h"
#include "util.h"

int hal_vs_send(uint8_t *data, size_t size) {
  int ret;

  ret = __send_to_device(data, size);
  if (ret != (int)size) OSI_loge("VS message send failed");

  return ret;
}

int hal_vs_nci_send(uint8_t oid, uint8_t *data, size_t size) {
  tNFC_NCI_PKT nci_pkt;
  nci_pkt.oct0 = NCI_MT_CMD | NCI_PBF_LAST | NCI_GID_PROP;
  nci_pkt.oid = oid;
  nci_pkt.len = size;

  if (data) memcpy(nci_pkt.payload, data, size);

  return hal_nci_send(&nci_pkt);
}

int hal_vs_get_prop(int n, tNFC_NCI_PKT *pkt) {
  char prop_field[15];

  pkt->oct0 = NCI_MT_CMD & NCI_GID_PROP & NCI_PBF_LAST;
  pkt->oid = get_config_propnci_get_oid(n);
  sprintf(prop_field, "NCI_PROP0x%02X", NCI_OID(pkt));
  pkt->len = get_config_byteArry(prop_field, pkt->payload, NCI_MAX_PAYLOAD);

  return (size_t)(pkt->len + NCI_HDR_SIZE);
}

size_t nfc_hal_vs_get_rfreg(int id, tNFC_NCI_PKT *pkt) {
  char field_name[50];
  size_t size;

  sprintf(field_name, "%s%d", cfg_name_table[CFG_RF_REG], id);
  size = get_config_byteArry(field_name, pkt->payload + 1, NCI_MAX_PAYLOAD - 1);
  if (size > 0) {
    pkt->oct0 = NCI_MT_CMD | NCI_PBF_LAST | NCI_GID_PROP;
    pkt->oid = NCI_PROP_SET_RFREG;
    pkt->len = size + 1;
    pkt->payload[0] = id;
    size += 4;
  }
  return size;
}

bool hal_vs_get_rf_image(tNFC_HAL_VS_INFO *vs) {
  if (vs->binary != NULL) free(vs->binary);

  if (check_force_fw_update_mode() == 3)
    vs->binary = nfc_hal_get_update_image(IMAGE_TYPE_RF_REG, true);
  else
    vs->binary = nfc_hal_get_update_image(IMAGE_TYPE_RF_REG, false);

  if (vs->binary == NULL) return false;

  memcpy(&vs->rfreg_size, vs->binary + 1, vs->binary[0]);
  vs->rfreg = vs->binary + vs->binary[0] + 1;

  nfc_rf_getver_from_image(vs->rfreg_img_version, vs);

  return true;
}

void hal_vs_set_rfreg_version(tNFC_HAL_VS_INFO *vs, tNFC_NCI_PKT *pkt) {
  tNFC_HAL_FW_BL_INFO *bl = &nfc_hal_info.fw_info.bl_info;
  if (SNFC_N74 <= bl->version[0]) {
    vs->rfreg_number_version[0] = NCI_PAYLOAD(pkt)[0] >> 4;  // main version
    vs->rfreg_number_version[1] =
        NCI_PAYLOAD(pkt)[0] & (~(0xf << 4));            // sub version
    vs->rfreg_number_version[2] = NCI_PAYLOAD(pkt)[1];  // patch version
    vs->rfreg_number_version[3] =
        NCI_PAYLOAD(pkt)[11];  // minor version (number version)

    memcpy(vs->rfreg_version, NCI_PAYLOAD(pkt) + 5, 5);
    memcpy(vs->rfreg_version + 5, NCI_PAYLOAD(pkt) + 12, 3);
  } else {
    memcpy(vs->rfreg_version, NCI_PAYLOAD(pkt) + 1, 8);
  }
}

bool hal_vs_check_rfreg_update(tNFC_HAL_VS_INFO *vs, __attribute__((unused))tNFC_NCI_PKT *pkt) {
  tNFC_HAL_FW_BL_INFO *bl = &nfc_hal_info.fw_info.bl_info;
  char rfreg_date_version_buffer[30];
  char rfreg_num_version_buffer[10];
  char rfreg_csc_buffer[10];
  bool ret;

  // set rf register version to structure
  memset(rfreg_date_version_buffer, 0, 30);
  memset(rfreg_num_version_buffer, 0, 10);
  memset(rfreg_csc_buffer, 0, 10);

  sprintf(rfreg_date_version_buffer, "%d/%d/%d/%d.%d.%d",
          (vs->rfreg_version[0] >> 4) + 14, vs->rfreg_version[0] & 0xF,
          vs->rfreg_version[1], vs->rfreg_version[2], vs->rfreg_version[3],
          vs->rfreg_version[4]);
  OSI_logd("RF Version (F/W): %s", rfreg_date_version_buffer);

  ret = hal_vs_get_rf_image(vs);
  if (ret) {
    sprintf(rfreg_date_version_buffer, "%d/%d/%d/%d.%d.%d",
            (vs->rfreg_img_version[0] >> 4) + 14,
            vs->rfreg_img_version[0] & 0xF, vs->rfreg_img_version[1],
            vs->rfreg_img_version[2], vs->rfreg_img_version[3],
            vs->rfreg_img_version[4]);
    OSI_logd("RF Version (BIN): %s", rfreg_date_version_buffer);

    memcpy(vs->rfreg_version, vs->rfreg_img_version, 8);
  } else {
    OSI_loge("hal_vs_check_rfreg_update return false");
  }
  sprintf(rfreg_csc_buffer, "%c%c%c", vs->rfreg_version[5],
          vs->rfreg_version[6], vs->rfreg_version[7]);

  // Set properties
  if (SNFC_N74 <= bl->version[0]) {
    if (ret)
      sprintf(rfreg_num_version_buffer, "%d", vs->rfreg_img_number_version[3]);
    else
      sprintf(rfreg_num_version_buffer, "%d", vs->rfreg_number_version[3]);

    OSI_logd("RF Register Display Version : %s", rfreg_num_version_buffer);
    property_set("nfc.fw.rfreg_display_ver", rfreg_num_version_buffer);
  }
  OSI_logd("nfc.fw.rfreg_ver is %s", rfreg_date_version_buffer);
  property_set("nfc.fw.rfreg_ver", rfreg_date_version_buffer);
  property_set("nfc.fw.dfl_areacode", rfreg_csc_buffer);

  return ret;
}

#define RFREG_SECTION_SIZE 252
bool hal_vs_rfreg_update(tNFC_HAL_VS_INFO *vs) {
  uint8_t data[RFREG_SECTION_SIZE + 1];
  uint32_t *check_sum;
  size_t size;
  int total, next = vs->rfregid * RFREG_SECTION_SIZE;

  total = vs->rfreg_size;

  OSI_logd("Next / Total: %d / %d", next, total);

  if (total <= next) return false;

  if (total - next < RFREG_SECTION_SIZE)
    size = total - next;
  else
    size = RFREG_SECTION_SIZE;

  memcpy(data + 1, vs->rfreg + next, size);

  // checksum
  check_sum = (uint32_t *)(data + 1);
  for (int i = 1; i <= (int)size; i += 4) vs->check_sum += *check_sum++;

  data[0] = vs->rfregid;
  OSI_logd("Sent RF register #id: 0x%02X", vs->rfregid);
  vs->rfregid++;
  hal_vs_nci_send(NCI_PROP_SET_RFREG, data, size + 1);

  return true;
}

bool nfc_rf_getver_from_image(uint8_t *rfreg_ver, tNFC_HAL_VS_INFO *vs) {
  tNFC_HAL_FW_BL_INFO *bl = &nfc_hal_info.fw_info.bl_info;
  uint8_t value[16];
  int position = 16;  // Default position of version information

  memcpy(value, &vs->rfreg[vs->rfreg_size - position], 16);

  memcpy(rfreg_ver, value + 5, 5);       // Version information (time)
  memcpy(rfreg_ver + 5, value + 12, 3);  // ID (csc code)

  if (SNFC_N74 <= bl->version[0]) {
    nfc_hal_info.vs_info.rfreg_img_number_version[0] =
        value[0] >> 4;  // main version
    nfc_hal_info.vs_info.rfreg_img_number_version[1] =
        value[0] & (~(0xf << 4));  // sub version
    nfc_hal_info.vs_info.rfreg_img_number_version[2] =
        value[1];  // patch version
    nfc_hal_info.vs_info.rfreg_img_number_version[3] =
        value[11];  // minor version (number version)
  }

  return true;
}
