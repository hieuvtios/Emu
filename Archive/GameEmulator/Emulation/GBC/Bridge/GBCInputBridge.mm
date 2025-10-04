//
//  GBCInputBridge.mm
//  GameEmulator
//
//  Direct Swift-to-Gambatte C++ input bridge implementation
//

#import "GBCInputBridge.h"
#import <os/lock.h>

// Import GBCDeltaCore framework
#import <GBCDeltaCore/GBCEmulatorBridge.h>

// Forward declare protocol methods from EmulatorBridging
@protocol DLTAEmulatorBridging;
@interface GBCEmulatorBridge (InputMethods)
- (void)activateInput:(NSInteger)input value:(double)value playerIndex:(NSInteger)playerIndex;
- (void)deactivateInput:(NSInteger)input playerIndex:(NSInteger)playerIndex;
- (void)resetInputs;
@end

@implementation GBCInputBridge {
    os_unfair_lock _lock;
}

+ (instancetype)shared {
    static GBCInputBridge *sharedInstance = nil;
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

    // Use GBCEmulatorBridge to activate input
    GBCEmulatorBridge *bridge = [GBCEmulatorBridge sharedBridge];
    [bridge activateInput:buttonMask value:1.0 playerIndex:playerIndex];

    os_unfair_lock_unlock(&_lock);
}

- (void)releaseButton:(int)buttonMask forPlayer:(int)playerIndex {
    os_unfair_lock_lock(&_lock);

    // Use GBCEmulatorBridge to deactivate input
    GBCEmulatorBridge *bridge = [GBCEmulatorBridge sharedBridge];
    [bridge deactivateInput:buttonMask playerIndex:playerIndex];

    os_unfair_lock_unlock(&_lock);
}

- (void)resetAllInputs {
    os_unfair_lock_lock(&_lock);

    // Use GBCEmulatorBridge to reset inputs
    GBCEmulatorBridge *bridge = [GBCEmulatorBridge sharedBridge];
    [bridge resetInputs];

    os_unfair_lock_unlock(&_lock);
}

@end
