//
//  GBAInputBridge.h
//  GameEmulator
//
//  Direct Swift-to-mGBA C++ input bridge
//  Bypasses DeltaCore abstraction for immediate input response
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Direct bridge to mGBA emulator input system
/// Provides immediate, thread-safe button input to running GBA games
@interface GBAInputBridge : NSObject

/// Shared singleton instance
+ (instancetype)shared;

/// Press a button on the GBA controller
/// @param buttonMask The button mask matching mGBA button values (GBA_*_MASK from gba.h)
/// @param playerIndex Player index (0 for player 1)
- (void)pressButton:(int)buttonMask forPlayer:(int)playerIndex;

/// Release a button on the GBA controller
/// @param buttonMask The button mask matching mGBA button values (GBA_*_MASK from gba.h)
/// @param playerIndex Player index (0 for player 1)
- (void)releaseButton:(int)buttonMask forPlayer:(int)playerIndex;

/// Reset all inputs (release all buttons)
- (void)resetAllInputs;

@end

NS_ASSUME_NONNULL_END
