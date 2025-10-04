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

#endif /* GameEmulator_Bridging_Header_h */
