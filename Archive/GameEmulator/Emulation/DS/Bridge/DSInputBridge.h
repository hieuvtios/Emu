//
//  DSInputBridge.h
//  GameEmulator
//
//  Direct Swift-to-MelonDS C++ input bridge
//  Bypasses DeltaCore abstraction for immediate input response
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Direct bridge to MelonDS emulator input system
/// Provides immediate, thread-safe button input to running DS games
@interface DSInputBridge : NSObject

/// Shared singleton instance
+ (instancetype)shared;

/// Press a button on the DS controller
/// @param buttonMask The button mask matching MelonDS button values (MelonDSGameInput masks)
/// @param playerIndex Player index (0 for player 1)
- (void)pressButton:(int)buttonMask forPlayer:(int)playerIndex;

/// Release a button on the DS controller
/// @param buttonMask The button mask matching MelonDS button values (MelonDSGameInput masks)
/// @param playerIndex Player index (0 for player 1)
- (void)releaseButton:(int)buttonMask forPlayer:(int)playerIndex;

/// Reset all inputs (release all buttons)
- (void)resetAllInputs;

@end

NS_ASSUME_NONNULL_END
