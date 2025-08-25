/*
 * Copyright (C) 2025 The LineageOS Project
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

#define LOG_TAG "SEC PowerHAL"

#include "Power.h"
#include <filesystem>
#include <fstream>
#include <iostream>
#include "samsung_lights.h"
#include "samsung_power.h"

#include <aidl/android/hardware/power/BnPower.h>

#include <android-base/logging.h>
#include <android/binder_manager.h>
#include <android/binder_process.h>

using ::aidl::android::hardware::power::BnPower;
using ::aidl::android::hardware::power::IPower;
using ::aidl::android::hardware::power::Mode;
using ::aidl::android::hardware::power::Boost;

using ::ndk::ScopedAStatus;
using ::ndk::SharedRefBase;

namespace aidl {
namespace android {
namespace hardware {
namespace power {
namespace impl {

#ifdef MODE_EXT
extern bool isDeviceSpecificModeSupported(Mode type, bool* _aidl_return);
extern bool setDeviceSpecificMode(Mode type, bool enabled);
#endif

extern "C" {
	void initialize();
	void findInputNodes();
	void sendBoostpulse();
	void sendBoost(int duration_us);
	bool initialized;
	bool touchkeys_blocked;
	std::string sec_touchkey;
	std::string sec_touchscreen;
	std::vector<std::string> hispeed_freqs;
	std::vector<std::string> max_freqs;
}

/*
 * Write value to path and close file.
 */
template <typename T>
static void set(const std::string& path, const T& value) {
    std::ofstream file(path);
    file << value << std::endl;
}

template <typename T>
static T get(const std::string& path, const T& def) {
    std::ifstream file(path);
    T result;

    file >> result;
    return file.fail() ? def : result;
}

void setInteractive(bool interactive) {
    if (!initialized) {
        initialize();
    }

    if (!interactive) {
        int32_t panel_brightness = get(PANEL_BRIGHTNESS_NODE, -1);

        if (panel_brightness > 0) {
            LOG(VERBOSE) << "Moving to non-interactive state, but screen is still on,"
                         << "not disabling input devices";
            goto out;
        }
    }

    if (!sec_touchscreen.empty()) {
        set(sec_touchscreen, interactive ? "1" : "0");
    }

    if (!sec_touchkey.empty()) {
        if (!interactive) {
            int button_state = get(sec_touchkey, -1);

            if (button_state < 0) {
                LOG(ERROR) << "Failed to read touchkey state";
                goto out;
            }

            /*
             * If button_state is 0, the keys have been disabled by another component
             * (for example lineagehw), which means we don't want them to be enabled when resuming
             * from suspend.
             */
            if (button_state == 0) {
                touchkeys_blocked = true;
            }
        }

        if (!touchkeys_blocked) {
            set(sec_touchkey, interactive ? "1" : "0");
        }
    }

out:
    for (const std::string& interactivePath : cpuInteractivePaths) {
        set(interactivePath + "/io_is_busy", interactive ? "1" : "0");
    }
}

ndk::ScopedAStatus Power::setMode(Mode type, bool enabled) {
    LOG(INFO) << "Power setMode: " << static_cast<int32_t>(type) << " to: " << enabled;
#ifdef MODE_EXT
    if (setDeviceSpecificMode(type, enabled)) {
        return ndk::ScopedAStatus::ok();
    }
#endif
    switch (type) {
#ifdef TAP_TO_WAKE_NODE
        case Mode::DOUBLE_TAP_TO_WAKE:
            ::android::base::WriteStringToFile(enabled ? "1" : "0", TAP_TO_WAKE_NODE, true);
            break;
#else
        case Mode::DOUBLE_TAP_TO_WAKE:
#endif
        case Mode::LOW_POWER:
        case Mode::EXPENSIVE_RENDERING:
        case Mode::DEVICE_IDLE:
        case Mode::DISPLAY_INACTIVE:
        case Mode::AUDIO_STREAMING_LOW_LATENCY:
        case Mode::CAMERA_STREAMING_SECURE:
        case Mode::CAMERA_STREAMING_LOW:
        case Mode::CAMERA_STREAMING_MID:
        case Mode::CAMERA_STREAMING_HIGH:
        case Mode::VR:
            LOG(INFO) << "Mode " << static_cast<int32_t>(type) << "Not Supported";
            break;
        case Mode::LAUNCH:
			sendBoostpulse();
            break;
        case Mode::INTERACTIVE:
            setInteractive(enabled);
            break;
        case Mode::SUSTAINED_PERFORMANCE:
        case Mode::FIXED_PERFORMANCE:
            break;
        default:
            LOG(INFO) << "Mode " << static_cast<int32_t>(type) << "Not Supported";
            break;
    }
    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Power::isModeSupported(Mode type, bool* _aidl_return) {
    LOG(INFO) << "Power isModeSupported: " << static_cast<int32_t>(type);

#ifdef MODE_EXT
    if (isDeviceSpecificModeSupported(type, _aidl_return)) {
        return ndk::ScopedAStatus::ok();
    }
#endif

    switch (type) {
#ifdef TAP_TO_WAKE_NODE
        case Mode::DOUBLE_TAP_TO_WAKE:
#endif
        case Mode::LAUNCH:
        case Mode::INTERACTIVE:
        case Mode::SUSTAINED_PERFORMANCE:
        case Mode::FIXED_PERFORMANCE:
            *_aidl_return = true;
            break;
        default:
            *_aidl_return = false;
            break;
    }
    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Power::setBoost(Boost type, int32_t durationMs) {
    LOG(VERBOSE) << "Power setBoost: " << static_cast<int32_t>(type)
                 << ", duration: " << durationMs;
    switch (type) {
        case Boost::CAMERA_LAUNCH:
			sendBoost(durationMs);
            break;
        case Boost::CAMERA_SHOT:
			sendBoost(durationMs);
            break;
        default:
            LOG(INFO) << "Boost " << static_cast<int32_t>(type) << "Not Supported";
            break;
    }
    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Power::isBoostSupported(Boost type, bool* _aidl_return) {
    LOG(INFO) << "Power isBoostSupported: " << static_cast<int32_t>(type);
    switch (type) {
        case Boost::CAMERA_LAUNCH:
			*_aidl_return = true;
            break;
        case Boost::CAMERA_SHOT:
			*_aidl_return = true;
            break;
        default:
            *_aidl_return = false;
            break;
    }
    return ndk::ScopedAStatus::ok();
}


void initialize() {
    findInputNodes();

    for (const std::string& interactivePath : cpuInteractivePaths) {
        hispeed_freqs.emplace_back(get<std::string>(interactivePath + "/hispeed_freq", ""));
    }

    for (const std::string& sysfsPath : cpuSysfsPaths) {
        max_freqs.emplace_back(get<std::string>(sysfsPath + "/cpufreq/scaling_max_freq", ""));
    }

    set(cpuInteractivePaths.at(0) + "/param_index", "0");
    set(cpuInteractivePaths.at(0) + "/above_hispeed_delay", "19000");
    set(cpuInteractivePaths.at(0) + "/boost", "0");
    set(cpuInteractivePaths.at(0) + "/boostpulse_duration", "40000");
    set(cpuInteractivePaths.at(0) + "/enforced_mode", "0");
    set(cpuInteractivePaths.at(0) + "/go_hispeed_load", "85");
    set(cpuInteractivePaths.at(0) + "/hispeed_freq", "900000");
    set(cpuInteractivePaths.at(0) + "/io_is_busy", "0");
    set(cpuInteractivePaths.at(0) + "/min_sample_time", "40000");
    set(cpuInteractivePaths.at(0) + "/multi_cluster0_min_freq", "0");
    set(cpuInteractivePaths.at(0) + "/multi_enter_load", "800");
    set(cpuInteractivePaths.at(0) + "/multi_enter_time", "80000");
    set(cpuInteractivePaths.at(0) + "/multi_exit_load", "360");
    set(cpuInteractivePaths.at(0) + "/multi_exit_time", "320000");
    set(cpuInteractivePaths.at(0) + "/single_cluster0_min_freq", "0");
    set(cpuInteractivePaths.at(0) + "/single_enter_load", "200");
    set(cpuInteractivePaths.at(0) + "/single_enter_time", "160000");
    set(cpuInteractivePaths.at(0) + "/single_exit_load", "90");
    set(cpuInteractivePaths.at(0) + "/single_exit_time", "80000");
    set(cpuInteractivePaths.at(0) + "/target_loads", "75");
    set(cpuInteractivePaths.at(0) + "/timer_rate", "20000");
    set(cpuInteractivePaths.at(0) + "/timer_slack", "20000");
    set(cpuInteractivePaths.at(1) + "/above_hispeed_delay", "59000 1300000:39000 1700000:19000");
    set(cpuInteractivePaths.at(1) + "/boost", "0");
    set(cpuInteractivePaths.at(1) + "/boostpulse_duration", "40000");
    set(cpuInteractivePaths.at(1) + "/enforced_mode", "0");
    set(cpuInteractivePaths.at(1) + "/go_hispeed_load", "89");
    set(cpuInteractivePaths.at(1) + "/hispeed_freq", "1200000");
    set(cpuInteractivePaths.at(1) + "/io_is_busy", "0");
    set(cpuInteractivePaths.at(1) + "/min_sample_time", "40000");
    set(cpuInteractivePaths.at(1) + "/multi_cluster0_min_freq", "1200000");
    set(cpuInteractivePaths.at(1) + "/multi_enter_load", "360");
    set(cpuInteractivePaths.at(1) + "/multi_enter_time", "79000");
    set(cpuInteractivePaths.at(1) + "/multi_exit_load", "240");
    set(cpuInteractivePaths.at(1) + "/multi_exit_time", "299000");
    set(cpuInteractivePaths.at(1) + "/single_cluster0_min_freq", "800000");
    set(cpuInteractivePaths.at(1) + "/single_enter_load", "95");
    set(cpuInteractivePaths.at(1) + "/single_enter_time", "199000");
    set(cpuInteractivePaths.at(1) + "/single_exit_load", "60");
    set(cpuInteractivePaths.at(1) + "/single_exit_time", "99000");
    set(cpuInteractivePaths.at(1) + "/target_loads", "65 1500000:75");
    set(cpuInteractivePaths.at(1) + "/timer_rate", "20000");
    set(cpuInteractivePaths.at(1) + "/timer_slack", "20000");

    initialized = true;
}

void findInputNodes() {
    std::error_code ec;
    for (auto& de : std::filesystem::directory_iterator("/sys/class/input/", ec)) {
        /* we are only interested in the input devices that we can access */
        if (ec || de.path().string().find("/sys/class/input/input") == std::string::npos) {
            continue;
        }

        for (auto& de2 : std::filesystem::directory_iterator(de.path(), ec)) {
            if (!ec && de2.path().string().find("/name") != std::string::npos) {
                std::string content = get<std::string>(de2.path(), "");
                if (content == "sec_touchkey") {
                    sec_touchkey = de.path().string().append("/enabled");
                    LOG(INFO) << "found sec_touchkey: " << sec_touchkey;
                } else if (content == "sec_touchscreen") {
                    sec_touchscreen = de.path().string().append("/enabled");
                    LOG(INFO) << "found sec_touchscreen: " << sec_touchscreen;
                }
            }
        }
    }
}

void sendBoostpulse() {
    // the boostpulse node is only valid for the LITTLE cluster
    set(cpuInteractivePaths.front() + "/boostpulse", "1");
}

void sendBoost(int duration_us) {
    set(cpuInteractivePaths.front() + "/boost", "1");

    usleep(duration_us);

    set(cpuInteractivePaths.front() + "/boost", "0");
}

}  // namespace impl
}  // namespace power
}  // namespace hardware
}  // namespace android
}  // namespace aidl
