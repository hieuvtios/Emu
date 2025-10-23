//
//  GameEmulator-Bridging-Header.h
//  GameEmulator
//
//  Bridging header to expose Objective-C/C++ to Swift
//

#ifndef GameEmulator_Bridging_Header_h
#define GameEmulator_Bridging_Header_h

// Direct bridge to Nestopia C++ core for NES input
#import "NESInputBridge.h"

// Direct bridge to Snes9x C++ core for SNES input
#import "SNESInputBridge.h"

// Direct bridge to Gambatte C++ core for GBC input
#import "GBCInputBridge.h"

// Direct bridge to Genesis Plus GX core for Genesis input
#import "GenesisInputBridge.h"

// Direct bridge to mGBA core for GBA input
#import "GBAInputBridge.h"

// Direct bridge to MelonDS core for DS input
#import "DSInputBridge.h"

// N64 uses N64DeltaCore bridge (no direct bridge needed)

#endif /* GameEmulator_Bridging_Header_h */
