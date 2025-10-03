//
//  NESInputBridge.mm
//  GameEmulator
//
//  Direct Swift-to-Nestopia C++ input bridge implementation
//

#import "NESInputBridge.h"
#import <os/lock.h>

// Import Nestopia bridge functions via NESDeltaCore framework
#import <NESDeltaCore/NESEmulatorBridge.hpp>

@implementation NESInputBridge {
    os_unfair_lock _lock;
}

+ (instancetype)shared {
    static NESInputBridge *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)pressButton:(int)buttonMask forPlayer:(int)playerIndex {
    os_unfair_lock_lock(&_lock);

    // Call Nestopia's direct input function
    NESActivateInput(buttonMask, playerIndex);

    os_unfair_lock_unlock(&_lock);
}

- (void)releaseButton:(int)buttonMask forPlayer:(int)playerIndex {
    os_unfair_lock_lock(&_lock);

    // Call Nestopia's direct input function
    NESDeactivateInput(buttonMask, playerIndex);

    os_unfair_lock_unlock(&_lock);
}

- (void)resetAllInputs {
    os_unfair_lock_lock(&_lock);

    // Call Nestopia's reset function
    NESResetInputs();

    os_unfair_lock_unlock(&_lock);
}

@end
