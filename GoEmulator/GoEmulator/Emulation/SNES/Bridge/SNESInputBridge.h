//
//  SNESInputBridge.h
//  GameEmulator
//
//  Direct Swift-to-Snes9x C++ input bridge
//  Bypasses DeltaCore abstraction for immediate input response
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Direct bridge to Snes9x emulator input system
/// Provides immediate, thread-safe button input to running SNES games
@interface SNESInputBridge : NSObject

/// Shared singleton instance
+ (instancetype)shared;

/// Press a button on the SNES controller
/// @param buttonMask The button mask matching Snes9x button values (SNES_*_MASK from snes9x.h)
/// @param playerIndex Player index (0 for player 1, 1 for player 2)
- (void)pressButton:(int)buttonMask forPlayer:(int)playerIndex;

/// Release a button on the SNES controller
/// @param buttonMask The button mask matching Snes9x button values (SNES_*_MASK from snes9x.h)
/// @param playerIndex Player index (0 for player 1, 1 for player 2)
- (void)releaseButton:(int)buttonMask forPlayer:(int)playerIndex;

/// Reset all inputs (release all buttons)
- (void)resetAllInputs;

@end

NS_ASSUME_NONNULL_END
