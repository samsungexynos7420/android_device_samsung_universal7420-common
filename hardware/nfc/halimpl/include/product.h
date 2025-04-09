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

#ifndef __NFC_SEC_PRODUCT__
#define __NFC_SEC_PRODUCT__
#include <stdint.h>
/* products */
typedef enum {
  SNFC_CHECKING = 0,
  SNFC_UNKNOWN = 0x10,
  SNFC_N3 = 0x30,
  SNFC_N5 = 0x50,
  SNFC_N5_5_0_0_0,
  SNFC_N5_5_0_0_1,
  SNFC_N5_5_0_x_2,
  // SNFC_N5_5_0_x_4,
  SNFC_N5P = 0x60,
  SNFC_N5P_5_0_x_3,
  SNFC_N5P_5_0_x_5,
  SNFC_N5P_5_0_x_7,
  SNFC_N7 = 0x70,
  SNFC_N7_7_0_0_x,
  SNFC_N74 = 0x74,
  SNFC_N8 = 0x80,
  SNFC_N81,
  SNFC_N82,
} eNFC_SNFC_PRODUCTS;

/* Products information */
static struct _sproduct_info {
  eNFC_SNFC_PRODUCTS group;
  uint8_t major_version;
  const char *chip_name;
} _product_info[] = {{SNFC_N3, 0x10, "S3FRNR3"},   {SNFC_N5, 0x10, "S3FWRN5"},
                     {SNFC_N5P, 0x20, "S3FWRN5P"}, {SNFC_N7, 0x30, "S3FWRN7"},
                     {SNFC_N74, 0x50, "S3NRN74"},
                     {SNFC_N8, 0x30, "S3FWRN8"},   {SNFC_N81, 0x40, "S3FWRN81"},
                     {SNFC_N82, 0x40, "S3NRN82"}};

#define productGroup(x) (x & 0xF0)

static uint8_t _n3_bl_ver_list[][6] = {
    // 4 bytes of version, 1 bytes of product, 1 bytes of base address
    {0x00, 0x00, 0x00, 0x00, SNFC_UNKNOWN, 0x80},
    {0x05, 0x00, 0x03, 0x00, SNFC_N3, 0x80}};
static uint8_t _n5_bl_ver_list[][6] = {
    {0x00, 0x00, 0x00, 0x00, SNFC_UNKNOWN, 0x50},
    {0x05, 0x00, 0x00, 0x00, SNFC_N5_5_0_0_0, 0x50},
    {0x05, 0x00, 0x00, 0x01, SNFC_N5_5_0_0_1, 0x30},
    {0x05, 0x00, 0x00, 0x02, SNFC_N5_5_0_x_2, 0x30},
    {0x05, 0x00, 0x00, 0x03, SNFC_N5P_5_0_x_3, 0x30},
    {0x05, 0x00, 0x00, 0x05, SNFC_N5P_5_0_x_5, 0x30},
    {0x05, 0x00, 0x00, 0x07, SNFC_N5P_5_0_x_7, 0x30}};

static uint8_t _n7_bl_ver_list[][6] = {
    {0x00, 0x00, 0x00, 0x00, SNFC_UNKNOWN, 0x30},
    {0x07, 0x00, 0x00, 0x00, SNFC_N7, 0x30},
    {0x07, 0x00, 0x00, 0x00, SNFC_N7_7_0_0_x, 0x30},
    {0x74, 0x00, 0x00, 0x00, SNFC_N74, 0x20}};

static uint8_t _n8_bl_ver_list[][6] = {
    {0x00, 0x00, 0x00, 0x00, SNFC_UNKNOWN, 0x00},
    {0x80, 0x00, 0x00, 0x00, SNFC_N8, 0x00},
    {0x81, 0x00, 0x00, 0x00, SNFC_N81, 0x00},
    {0x82, 0x00, 0x00, 0x00, SNFC_N82, 0x00}};

extern eNFC_SNFC_PRODUCTS product_map(uint8_t *ver, uint16_t *base_address);

extern const char *get_product_name(uint8_t product);

extern uint8_t get_product_support_fw(uint8_t product);
#endif  //__NFC_SEC_PRODUCT__
