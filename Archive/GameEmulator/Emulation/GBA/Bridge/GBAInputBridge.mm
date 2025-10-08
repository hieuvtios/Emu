//
//  GBAInputBridge.mm
//  GameEmulator
//
//  Direct Swift-to-mGBA C++ input bridge implementation
//

#import "GBAInputBridge.h"
#import <os/lock.h>

// Import GBADeltaCore framework
#import <GBADeltaCore/GBAEmulatorBridge.h>

// Forward declare protocol methods from EmulatorBridging
@protocol DLTAEmulatorBridging;
@interface GBAEmulatorBridge (InputMethods)
- (void)activateInput:(NSInteger)input value:(double)value playerIndex:(NSInteger)playerIndex;
- (void)deactivateInput:(NSInteger)input playerIndex:(NSInteger)playerIndex;
- (void)resetInputs;
@end

@implementation GBAInputBridge {
    os_unfair_lock _lock;
}

+ (instancetype)shared {
    static GBAInputBridge *sharedInstance = nil;
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

    // Use GBAEmulatorBridge to activate input
    GBAEmulatorBridge *bridge = [GBAEmulatorBridge sharedBridge];
    [bridge activateInput:buttonMask value:1.0 playerIndex:playerIndex];

    os_unfair_lock_unlock(&_lock);
}

- (void)releaseButton:(int)buttonMask forPlayer:(int)playerIndex {
    os_unfair_lock_lock(&_lock);

    // Use GBAEmulatorBridge to deactivate input
    GBAEmulatorBridge *bridge = [GBAEmulatorBridge sharedBridge];
    [bridge deactivateInput:buttonMask playerIndex:playerIndex];

    os_unfair_lock_unlock(&_lock);
}

- (void)resetAllInputs {
    os_unfair_lock_lock(&_lock);

    // Use GBAEmulatorBridge to reset inputs
    GBAEmulatorBridge *bridge = [GBAEmulatorBridge sharedBridge];
    [bridge resetInputs];

    os_unfair_lock_unlock(&_lock);
}

@end
