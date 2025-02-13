/*
 * Copyright (C) 2018 TeamNexus
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef VARIANT_DETECTION_H
#define VARIANT_DETECTION_H

#include <cutils/properties.h>
#include <string.h>

#ifndef __maybe_unused
  #define __maybe_unused  __attribute__((unused))
#endif

enum model_variants {
	UNDEFINED = -1,
	DEFAULT = 0,    // F and other non-specified
	INDIA = 1,      // I
	TMOBILE = 2,    // T
	CANADA = 3,     // W8
	SPRINT = 4      // P/R4/0/8/9
};

enum models {
	UNKNOWN = -1,
	FLAT = 0,
	EDGE = 1,
	EDGEPLUS = 2,
	ACTIVE = 3,
	NOTE5 = 5,
	W2016 = 6,
	A8 = 8
};

static enum model_variants __model_variants = UNDEFINED;

static enum model_variants model_variants_read() {
	char bootloader[PROPERTY_VALUE_MAX];
	int bootloader_len = 0;

	if (__model_variants != UNDEFINED) {
		ALOGI("%s: use cached model: %d", __func__, __model_variants);
		return __model_variants;
	}

	property_get("ro.bootloader", bootloader, "");
	bootloader_len = strlen(bootloader);

	if (bootloader_len <= 0 || bootloader_len >= PROPERTY_VALUE_MAX) {
		__model_variants = UNDEFINED;
		goto exit;
	}

	if (!strncmp(bootloader, "G920I", 5) || !strncmp(bootloader, "G925I", 5) ||
		!strncmp(bootloader, "G928I", 5) || !strncmp(bootloader, "N920I", 5)) {
		__model_variants = INDIA;
	}
	else if (!strncmp(bootloader, "G920T", 5) || !strncmp(bootloader, "G925T", 5) ||
		!strncmp(bootloader, "G928T", 5) || !strncmp(bootloader, "N920T", 5)) {
		__model_variants = TMOBILE;
	}
	else if (!strncmp(bootloader, "G920W8", 6) || !strncmp(bootloader, "G925W8", 6) ||
		!strncmp(bootloader, "G928W8", 6) || !strncmp(bootloader, "N920W8", 6)) {
		__model_variants = CANADA;
	}
	else if (!strncmp(bootloader, "G920P", 6)  || !strncmp(bootloader, "G925P", 6) ||
	         !strncmp(bootloader, "G920R4", 6) || !strncmp(bootloader, "G925R4", 6) ||
	         !strncmp(bootloader, "G9200", 6)  || !strncmp(bootloader, "G9250", 6) ||
	         !strncmp(bootloader, "G9208", 6)  || !strncmp(bootloader, "G9258", 6) ||
	         !strncmp(bootloader, "G9209", 6)  || !strncmp(bootloader, "G9259", 6)) {
		__model_variants = SPRINT;
	}
	else { // if (!strncmp(bootloader, "G920F", 5) || !strncmp(bootloader, "G925F", 5))
		__model_variants = DEFAULT;
	}

exit:
	ALOGI("%s: determined model: %d", __func__, __model_variants);
	return __model_variants;
}

static bool hasEarsmart() {
	enum model_variants temp = model_variants_read();
	switch (temp) {
		case TMOBILE:
		case CANADA:
		case SPRINT:
			return true;
		default:
			return false;
	}
}

#endif // VARIANT_DETECTION_H
