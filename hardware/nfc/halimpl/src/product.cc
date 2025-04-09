#include "product.h"

eNFC_SNFC_PRODUCTS product_map(uint8_t *ver, uint16_t *base_address) {
  size_t i;
  for (i = 0; i < sizeof(_n3_bl_ver_list) / 6; i++) {
    if (ver[0] == _n3_bl_ver_list[i][0] && ver[1] == _n3_bl_ver_list[i][1] &&
        ver[2] == _n3_bl_ver_list[i][2] && ver[3] == _n3_bl_ver_list[i][3]) {
      *base_address = _n3_bl_ver_list[i][5] * 0x100;
              return (eNFC_SNFC_PRODUCTS)_n3_bl_ver_list[i][4];
    }
  }

  for (i = 0; i < sizeof(_n5_bl_ver_list) / 6; i++) {
    if (ver[0] == _n5_bl_ver_list[i][0] && ver[1] == _n5_bl_ver_list[i][1]
        //&& ver[2] == _n5_bl_ver_list[i][2]  // Customer key
        && ver[3] == _n5_bl_ver_list[i][3]) {
      *base_address = _n5_bl_ver_list[i][5] * 0x100;
            return  (eNFC_SNFC_PRODUCTS) _n5_bl_ver_list[i][4];
    }
  }

  for (i = 0; i < sizeof(_n7_bl_ver_list) / 6; i++) {
    if (ver[0] == _n7_bl_ver_list[i][0] && ver[1] == _n7_bl_ver_list[i][1]
        //&& ver[2] == _n7_bl_ver_list[i][2]  // Customer key
        && ver[3] == _n7_bl_ver_list[i][3]) {
      *base_address = _n7_bl_ver_list[i][5] * 0x100;
            return (eNFC_SNFC_PRODUCTS) _n7_bl_ver_list[i][4];
    }
  }

  for (i = 0; i < sizeof(_n8_bl_ver_list) / 6; i++) {
    if (ver[0] == _n8_bl_ver_list[i][0] && ver[1] == _n8_bl_ver_list[i][1]
        //&& ver[2] == _n7_bl_ver_list[i][2]  // Customer key
        && ver[3] == _n8_bl_ver_list[i][3]) {
      *base_address = _n8_bl_ver_list[i][5] * 0x100;
            return (eNFC_SNFC_PRODUCTS) _n8_bl_ver_list[i][4];
    }
  }

  return SNFC_UNKNOWN;
}

const char *get_product_name(uint8_t product) {
  uint8_t i;
  for (i = 0; i < sizeof(_product_info) / sizeof(struct _sproduct_info); i++) {
    if (_product_info[i].group == productGroup(product)) {
      if (product == 0x74) {
        return "S3NRN74";
      }
      if (product == 0x81) {
        if (sizeof(_product_info) / sizeof(struct _sproduct_info) <= i + 1)
          return "Unknown product";
        return _product_info[i + 1].chip_name;
      }
      return _product_info[i].chip_name;
    }
  }

  return (char *)"Unknown product";
}

uint8_t get_product_support_fw(uint8_t product) {
  uint8_t i;
  for (i = 0; i < sizeof(_product_info) / sizeof(struct _sproduct_info); i++) {
    if (_product_info[i].group == productGroup(product)) {
      if (product == 0x74) {
          return 0x50;
      }
      if (product == 0x81) {
        if (sizeof(_product_info) / sizeof(struct _sproduct_info) <= i + 1)
          return SNFC_UNKNOWN;
        return _product_info[i + 1].major_version;
      }
      return _product_info[i].major_version;
    }
  }

  return SNFC_UNKNOWN;
}
