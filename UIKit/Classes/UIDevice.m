/*
 * Copyright (c) 2011, The Iconfactory. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of The Iconfactory nor the names of its contributors may
 *    be used to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE ICONFACTORY BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UIDevice.h"
#include <IOKit/IOKitLib.h>
#import <SystemConfiguration/SystemConfiguration.h>
#include <IOKit/ps/IOPowerSources.h>
#include <IOKit/ps/IOPSKeys.h>

NSString *const UIDeviceOrientationDidChangeNotification = @"UIDeviceOrientationDidChangeNotification";

static UIDevice *theDevice;

@implementation UIDevice

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self == [UIDevice class]) {
            theDevice = [[UIDevice alloc] init];
        }
    });
}

+ (UIDevice *)currentDevice
{
    return theDevice;
}

- (instancetype)init
{
    if ((self=[super init])) {
        _userInterfaceIdiom = UIUserInterfaceIdiomDesktop;
    }
    return self;
}

- (NSString *)name
{
    return CFBridgingRelease(SCDynamicStoreCopyComputerName(NULL,NULL));
}

- (UIDeviceOrientation)orientation
{
    return UIDeviceOrientationPortrait;
}


- (NSDictionary<NSString*,id> *)primaryPowerSource
{
    CFTypeRef powerSourceInfo = IOPSCopyPowerSourcesInfo();
    NSArray *powerSources = CFBridgingRelease(IOPSCopyPowerSourcesList(powerSourceInfo));
    
    if (powerSources.count == 0) return nil;
    
    CFDictionaryRef primarySourceRef = IOPSGetPowerSourceDescription(powerSourceInfo, (__bridge CFTypeRef)(powerSources[0]));
    NSDictionary *primarySource = [[NSDictionary alloc] initWithDictionary:(__bridge NSDictionary *) primarySourceRef];
    
    CFRelease(primarySourceRef);
    CFRelease(powerSourceInfo);

    return primarySource;
}

- (UIDeviceBatteryState)batteryState
{
    UIDeviceBatteryState state = UIDeviceBatteryStateUnknown;
    
    NSDictionary<NSString*,id> *powerSource = [self primaryPowerSource];
    id powerSourceState = powerSource[@kIOPSPowerSourceStateKey];
    
    if ([powerSourceState isEqualToString:@kIOPSACPowerValue]) {
        id currentObj = powerSource[@kIOPSCurrentCapacityKey];
        id capacityObj = powerSource[@kIOPSMaxCapacityKey];
        
        if ([currentObj isEqualToNumber:capacityObj]) {
            state = UIDeviceBatteryStateFull;
        } else {
            state = UIDeviceBatteryStateCharging;
        }
    } else if ([powerSourceState isEqualToString:@kIOPSBatteryPowerValue]) {
        state = UIDeviceBatteryStateUnplugged;
    }
    
    return state;
}

- (float)batteryLevel
{
    float batteryLevel = 1.f;
    
    NSDictionary<NSString*,id> *powerSource = [self primaryPowerSource];
    
    if (powerSource != nil) {
        id currentObj = powerSource[@kIOPSCurrentCapacityKey];
        id capacityObj = powerSource[@kIOPSMaxCapacityKey];
        
        batteryLevel = [currentObj floatValue] / [capacityObj floatValue];
    }
    
    return batteryLevel;
}

- (BOOL)isMultitaskingSupported
{
    return YES;
}

- (NSString *)systemName
{
    return [[NSProcessInfo processInfo] operatingSystemName];
}

- (NSString *)systemVersion
{
    return [NSProcessInfo processInfo].operatingSystemVersionString;
}

- (NSString *)model
{
    return @"Mac";
}

- (BOOL)isGeneratingDeviceOrientationNotifications
{
    return NO;
}

- (void)beginGeneratingDeviceOrientationNotifications
{
}

- (void)endGeneratingDeviceOrientationNotifications
{
}

@end
