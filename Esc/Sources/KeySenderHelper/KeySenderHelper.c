//
//  KeySenderHelper.c
//  Pock
//
//  Created by Pierluigi Galdi on 04/05/2019.
//  Copyright © 2019 Pierluigi Galdi. All rights reserved.
//

#include "KeySenderHelper.h"
#include <IOKit/hidsystem/IOHIDLib.h>

static io_connect_t _driver(void) {
    static mach_port_t sEventDrvrRef = 0;
    mach_port_t service, iter;
    if (!sEventDrvrRef) {
        /// `assert()` is not compiled out in Release (no `NDEBUG`): a failure here used to abort Pock.
        /// Return `MACH_PORT_NULL` instead (IOHIDPostEvent then fails) and try again on next key press.
        kern_return_t kr = IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching(kIOHIDSystemClass), &iter);
        if (KERN_SUCCESS != kr) {
            return MACH_PORT_NULL;
        }
        service = IOIteratorNext(iter);
        IOObjectRelease(iter);
        if (!service) {
            return MACH_PORT_NULL;
        }
        kr = IOServiceOpen(service, mach_task_self(), kIOHIDParamConnectType, &sEventDrvrRef);
        IOObjectRelease(service);
        if (KERN_SUCCESS != kr) {
            sEventDrvrRef = 0;
            return MACH_PORT_NULL;
        }
    }
    return sEventDrvrRef;
}

void KeySenderPress(uint16_t keyCode, _Bool isAux) {
    NXEventData event = { 0 };
    if (isAux) {
        event.compound.subType   = NX_SUBTYPE_AUX_CONTROL_BUTTONS;
        event.compound.misc.L[0] = (NX_KEYDOWN << 8) | (keyCode << 16);
    }else {
        event.key.keyCode      = keyCode;
    }
    kern_return_t ret = IOHIDPostEvent(_driver(), isAux ? NX_SYSDEFINED : NX_KEYDOWN, (IOGPoint){0}, &event, kNXEventDataVersion, 0, 0);
    if (KERN_SUCCESS != ret)
        return;
}

void KeySenderRelease(uint16_t keyCode, _Bool isAux) {
    NXEventData event = { 0 };
    if (isAux) {
        event.compound.subType = NX_SUBTYPE_AUX_CONTROL_BUTTONS;
        event.compound.misc.L[0] = (NX_KEYUP << 8) | (keyCode << 16);
    }else {
        event.key.keyCode = keyCode;
    }
    kern_return_t ret = IOHIDPostEvent(_driver(), isAux ? NX_SYSDEFINED : NX_KEYUP, (IOGPoint){0}, &event, kNXEventDataVersion, 0, 0);
    if (KERN_SUCCESS != ret)
        return;
}
