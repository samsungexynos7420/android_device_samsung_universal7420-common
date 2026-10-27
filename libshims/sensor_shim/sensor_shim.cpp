
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sensor/SensorManager.h>

namespace android {

	extern "C" void _ZN7android8String16aSEOS0_();
	extern "C" void _ZN7android8String16aSEOS0_(){}

	extern "C" void _ZN7android8String16C1EOS0_();
	extern "C" void _ZN7android8String16C1EOS0_(){}

	extern "C" void _ZN7android9SingletonINS_13SensorManagerEE5sLockE();
	extern "C" void _ZN7android9SingletonINS_13SensorManagerEE5sLockE(){}

	extern "C" void _ZN7android9SingletonINS_13SensorManagerEE9sInstanceE();
	extern "C" void _ZN7android9SingletonINS_13SensorManagerEE9sInstanceE(){}

	extern "C" void _ZN7android13SensorManager16createEventQueueEv();
	extern "C" void _ZN7android13SensorManager16createEventQueueEv(){}

	extern "C" void _ZN7android13SensorManagerC1Ev();
	extern "C" void _ZN7android13SensorManagerC1Ev(){}

	sp<SensorEventQueue> shim_createEventQueue(SensorManager* thiz, String8 packageName, int mode)
        __asm__("_ZN7android13SensorManager16createEventQueueENS_7String8Ei");
__attribute__((visibility("default")))

	sp<SensorEventQueue> shim_createEventQueue(SensorManager* thiz, String8 packageName, int mode) {
		return thiz->createEventQueue(packageName, mode, String16(""));
	}

}

