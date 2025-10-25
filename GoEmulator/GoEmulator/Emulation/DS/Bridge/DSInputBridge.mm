//
//  DSInputBridge.mm
//  GameEmulator
//
//  Direct Swift-to-MelonDS C++ input bridge implementation
//

#import "DSInputBridge.h"
#import <os/lock.h>

// Import MelonDSDeltaCore framework
#import <MelonDSDeltaCore/MelonDSEmulatorBridge.h>

// Forward declare protocol methods from EmulatorBridging
@protocol DLTAEmulatorBridging;
@interface MelonDSEmulatorBridge (InputMethods)
- (void)activateInput:(NSInteger)input value:(double)value playerIndex:(NSInteger)playerIndex;
- (void)deactivateInput:(NSInteger)input playerIndex:(NSInteger)playerIndex;
- (void)resetInputs;
@end

@implementation DSInputBridge {
    os_unfair_lock _lock;
}

+ (instancetype)shared {
    static DSInputBridge *sharedInstance = nil;
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

    // Use MelonDSEmulatorBridge to activate input
    MelonDSEmulatorBridge *bridge = [MelonDSEmulatorBridge sharedBridge];
    [bridge activateInput:buttonMask value:1.0 playerIndex:playerIndex];

    os_unfair_lock_unlock(&_lock);
}

- (void)releaseButton:(int)buttonMask forPlayer:(int)playerIndex {
    os_unfair_lock_lock(&_lock);

    // Use MelonDSEmulatorBridge to deactivate input
    MelonDSEmulatorBridge *bridge = [MelonDSEmulatorBridge sharedBridge];
    [bridge deactivateInput:buttonMask playerIndex:playerIndex];

    os_unfair_lock_unlock(&_lock);
}

- (void)resetAllInputs {
    os_unfair_lock_lock(&_lock);

    // Use MelonDSEmulatorBridge to reset inputs
    MelonDSEmulatorBridge *bridge = [MelonDSEmulatorBridge sharedBridge];
    [bridge resetInputs];

    os_unfair_lock_unlock(&_lock);
}

@end
