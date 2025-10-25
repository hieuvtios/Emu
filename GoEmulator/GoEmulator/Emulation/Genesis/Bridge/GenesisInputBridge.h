////
////  GenesisInputBridge.h
////  GameEmulator
////
////  Direct Swift-to-Genesis Plus GX input bridge
////  Bypasses DeltaCore abstraction for immediate input response
////
//
//#import <Foundation/Foundation.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
///// Direct bridge to Genesis Plus GX emulator input system
///// Provides immediate, thread-safe button input to running Genesis/Mega Drive games
//@interface GenesisInputBridge : NSObject
//
///// Shared singleton instance
//+ (instancetype)shared;
//
///// Press a button on the Genesis controller
///// @param buttonMask The button mask matching GPGXGameInput values (0x01-0x800)
///// @param playerIndex Player index (0 for player 1, 1 for player 2)
//- (void)pressButton:(int)buttonMask forPlayer:(int)playerIndex;
//
///// Release a button on the Genesis controller
///// @param buttonMask The button mask matching GPGXGameInput values (0x01-0x800)
///// @param playerIndex Player index (0 for player 1, 1 for player 2)
//- (void)releaseButton:(int)buttonMask forPlayer:(int)playerIndex;
//
///// Reset all inputs (release all buttons)
//- (void)resetAllInputs;
//
//@end
//
//NS_ASSUME_NONNULL_END
