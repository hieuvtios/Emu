////
////  GenesisInputBridge.mm
////  GameEmulator
////
////  Direct Swift-to-Genesis Plus GX input bridge implementation
////
//
//#import "GenesisInputBridge.h"
//#import <os/lock.h>
//
//// Import Genesis Plus GX bridge via GPGXDeltaCore framework
//#import <GPGXDeltaCore/GPGXEmulatorBridge.h>
//#import "GPGXDeltaCore/GPGXEmulatorBridge.h"
//#import <GPGXDeltaCore/GPGXEmulatorBridge.h>
//
//@implementation GenesisInputBridge {
//    os_unfair_lock _lock;
//}
//
//+ (instancetype)shared {
//    static GenesisInputBridge *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    return sharedInstance;
//}
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        _lock = OS_UNFAIR_LOCK_INIT;
//    }
//    return self;
//}
//
//- (void)pressButton:(int)buttonMask forPlayer:(int)playerIndex {
//    os_unfair_lock_lock(&_lock);
//
//    // Call Genesis Plus GX's direct input function via the emulator bridge
//    GPGXEmulatorBridge *bridge = [GPGXEmulatorBridge sharedBridge];
////    [bridge activateInput:buttonMask value:1.0 playerIndex:playerIndex];
//
//    os_unfair_lock_unlock(&_lock);
//}
//
//- (void)releaseButton:(int)buttonMask forPlayer:(int)playerIndex {
//    os_unfair_lock_lock(&_lock);
//
//    // Call Genesis Plus GX's direct input function via the emulator bridge
//    GPGXEmulatorBridge *bridge = [GPGXEmulatorBridge sharedBridge];
////    [bridge deactivateInput:buttonMask playerIndex:playerIndex];
//
//    os_unfair_lock_unlock(&_lock);
//}
//
//- (void)resetAllInputs {
//    os_unfair_lock_lock(&_lock);
//
//    // Call Genesis Plus GX's reset function
//    GPGXEmulatorBridge *bridge = [GPGXEmulatorBridge sharedBridge];
////    [bridge resetInputs];
//
//    os_unfair_lock_unlock(&_lock);
//}
//
//@end
