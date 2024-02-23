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

LOCAL_PATH := device/samsung/universal7420-common

ifeq ($(BOARD_VENDOR),samsung)
ifneq ($(filter zerofltedv zerofltemtr zerofltespr zerofltetmo zerofltexx zeroltetmo zeroltexx zerofltebmc zeroltebmc zeroltecan zerofltecan noblelte nobleltecan nobleltedd nobleltedv nobleltejv nobleltektt nobleltelgt noblelteskt nobleltespr nobleltetmo nobleltextc nobleltezt zenlte zenltecan zenltedd zenltedv zenltejv zenltektt zenltelgt zenlteskt zenltetmo zenltexx zenltezt, $(TARGET_DEVICE)),)

  subdir_makefiles=$(call first-makefiles-under,$(LOCAL_PATH))
  $(foreach mk,$(subdir_makefiles),$(info including $(mk) ...)$(eval include $(mk)))

endif
endif
