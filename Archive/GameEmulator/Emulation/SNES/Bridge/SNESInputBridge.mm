//
//  SNESInputBridge.mm
//  GameEmulator
//
//  Direct Swift-to-Snes9x C++ input bridge implementation
//

#import "SNESInputBridge.h"
#import <os/lock.h>

// Import SNESDeltaCore framework
#import <SNESDeltaCore/SNESEmulatorBridge.h>

// Forward declare protocol methods from EmulatorBridging
@protocol DLTAEmulatorBridging;
@interface SNESEmulatorBridge (InputMethods)
- (void)activateInput:(NSInteger)input value:(double)value playerIndex:(NSInteger)playerIndex;
- (void)deactivateInput:(NSInteger)input playerIndex:(NSInteger)playerIndex;
- (void)resetInputs;
@end

@implementation SNESInputBridge {
    os_unfair_lock _lock;
}

+ (instancetype)shared {
    static SNESInputBridge *sharedInstance = nil;
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

    // Use SNESEmulatorBridge to activate input
    SNESEmulatorBridge *bridge = [SNESEmulatorBridge sharedBridge];
    [bridge activateInput:buttonMask value:1.0 playerIndex:playerIndex];

    os_unfair_lock_unlock(&_lock);
}

- (void)releaseButton:(int)buttonMask forPlayer:(int)playerIndex {
    os_unfair_lock_lock(&_lock);

    // Use SNESEmulatorBridge to deactivate input
    SNESEmulatorBridge *bridge = [SNESEmulatorBridge sharedBridge];
    [bridge deactivateInput:buttonMask playerIndex:playerIndex];

    os_unfair_lock_unlock(&_lock);
}

- (void)resetAllInputs {
    os_unfair_lock_lock(&_lock);

    // Use SNESEmulatorBridge to reset inputs
    SNESEmulatorBridge *bridge = [SNESEmulatorBridge sharedBridge];
    [bridge resetInputs];

    os_unfair_lock_unlock(&_lock);
}

@end
