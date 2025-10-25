//
//  NESInputBridge.h
//  GameEmulator
//
//  Direct Swift-to-Nestopia C++ input bridge
//  Bypasses DeltaCore abstraction for immediate input response
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Direct bridge to Nestopia emulator input system
/// Provides immediate, thread-safe button input to running NES games
@interface NESInputBridge : NSObject

/// Shared singleton instance
+ (instancetype)shared;

/// Press a button on the NES controller
/// @param buttonMask The button mask matching NESGameInput values (0x01-0x80)
/// @param playerIndex Player index (0 for player 1, 1 for player 2)
- (void)pressButton:(int)buttonMask forPlayer:(int)playerIndex;

/// Release a button on the NES controller
/// @param buttonMask The button mask matching NESGameInput values (0x01-0x80)
/// @param playerIndex Player index (0 for player 1, 1 for player 2)
- (void)releaseButton:(int)buttonMask forPlayer:(int)playerIndex;

/// Reset all inputs (release all buttons)
- (void)resetAllInputs;

@end

NS_ASSUME_NONNULL_END
