# Save/Load State Testing Guide

## 🎯 Quick Test Checklist

Use this guide to verify the save/load state functionality works correctly without crashes.

---

## ✅ Basic Functionality Tests

### Test 1: Basic Save & Load
```
Steps:
1. Start Street Fighter 2
2. Play for a few seconds
3. Open Menu → Quick tab
4. Tap "Quick Save"
5. Wait for "Save Successful" message
6. Continue playing
7. Open Menu → Quick tab
8. Tap "Quick Load"

Expected Result:
✅ Game loads back to saved point
✅ No crash
✅ "Load Successful" message appears

What to Check:
- Character position restored
- Health bars restored
- Timer restored
- No visual glitches
```

### Test 2: Multiple Save Slots
```
Steps:
1. Start game
2. Play to certain point (Point A)
3. Open Menu → States tab
4. Create save in Slot 1
5. Continue playing to new point (Point B)
6. Create save in Slot 2
7. Load Slot 1
8. Verify at Point A
9. Load Slot 2
10. Verify at Point B

Expected Result:
✅ Both saves load correctly
✅ No crashes
✅ States are independent

What to Check:
- Each slot has different thumbnails
- Each slot has different timestamps
- Loading doesn't mix up states
```

### Test 3: Save While Paused
```
Steps:
1. Start game
2. Play for a bit
3. Open Menu (game pauses)
4. Quick → Quick Save
5. Close menu
6. Verify game resumes normally

Expected Result:
✅ Save succeeds while paused
✅ Game resumes after save
✅ No crashes

What to Check:
- Save file is created
- Game doesn't freeze
- Audio continues properly
```

### Test 4: Load While Running
```
Steps:
1. Start game
2. Let it run (don't pause)
3. Open Menu quickly
4. Quick → Quick Load
5. Close menu

Expected Result:
✅ Game pauses automatically
✅ State loads successfully
✅ Game resumes automatically
✅ No crashes

What to Check:
- Smooth pause → load → resume
- No audio glitches
- No visual stuttering
```

---

## 🔥 Stress Tests

### Test 5: Rapid Save/Load
```
Steps:
1. Start game
2. Quick Save
3. Immediately Quick Save again
4. Quick Load
5. Immediately Quick Load again
6. Repeat 5 times

Expected Result:
✅ All operations succeed
✅ No crashes
✅ Each operation completes

What to Check:
- No memory leaks
- No performance degradation
- Timestamps update correctly
```

### Test 6: Save/Load Different Games
```
Steps:
1. Start Street Fighter 2
2. Quick Save
3. Exit to menu
4. Start different game
5. Quick Save
6. Load SF2 save
7. Load other game save

Expected Result:
✅ Each game has separate saves
✅ No state mixing
✅ No crashes

What to Check:
- Saves are game-specific
- Loading wrong game's save shows error
- File organization is correct
```

### Test 7: Load Non-Existent State
```
Steps:
1. Start game
2. Open Menu → States tab
3. Note a save state ID
4. Close app
5. Delete save file manually:
   Documents/SaveStates/[ID].sav
6. Reopen app and game
7. Try to load deleted state

Expected Result:
✅ Error message: "Save state file not found"
✅ No crash
✅ App remains stable

What to Check:
- Clear error message displayed
- App doesn't freeze
- Other saves still work
```

### Test 8: Load Corrupted State
```
Steps:
1. Start game
2. Quick Save
3. Close app
4. Open Documents/SaveStates/
5. Find .sav file
6. Open in text editor and delete content
7. Save empty file
8. Reopen app and game
9. Try to load corrupted state

Expected Result:
✅ Error: "Save state file is empty or corrupted"
✅ No crash
✅ App remains stable

What to Check:
- Proper error detection
- Clear error message
- App can continue normally
```

---

## 🎮 Gameplay Integration Tests

### Test 9: Save/Load with Active Cheats
```
Steps:
1. Start game
2. Enable "Infinite Health" cheat
3. Quick Save
4. Disable cheat
5. Play (take damage)
6. Quick Load

Expected Result:
✅ State loads with cheat active
✅ Health returns to saved value
✅ Cheat remains enabled

What to Check:
- Cheats are saved with state
- Cheats reactivate on load
- Cheat toggle states preserved
```

### Test 10: Save/Load with Fast Forward
```
Steps:
1. Start game
2. Enable 4x Fast Forward
3. Quick Save
4. Reset speed to 1x
5. Quick Load

Expected Result:
✅ State loads correctly
✅ Speed returns to saved value (4x)
✅ No timing issues

What to Check:
- Speed setting is preserved
- Audio pitch is correct
- No desync issues
```

### Test 11: Save During Special Move
```
Steps:
1. Start Street Fighter 2
2. Begin executing special move (Hadouken)
3. Quick Save mid-animation
4. Let animation finish
5. Quick Load

Expected Result:
✅ Loads back to mid-animation
✅ Animation completes correctly
✅ No glitches

What to Check:
- Animation state preserved
- Sound effects correct
- No stuck animations
```

### Test 12: Save/Load with Full Screen
```
Steps:
1. Start game in landscape
2. Quick Save
3. Rotate to portrait
4. Quick Load
5. Rotate back to landscape
6. Quick Load again

Expected Result:
✅ All loads work regardless of orientation
✅ No layout issues
✅ No crashes

What to Check:
- Orientation doesn't affect saves
- UI adapts correctly
- Menu button visible in all orientations
```

---

## 📊 Performance Tests

### Test 13: Save Operation Performance
```
Steps:
1. Start game
2. Enable dev logging (check console)
3. Quick Save
4. Check console for timing

Expected Result:
✅ Save completes in < 500ms
✅ No frame drops
✅ Smooth operation

Console Output Should Show:
"SaveState operation completed in: [time]ms"
Acceptable: 200-500ms
```

### Test 14: Load Operation Performance
```
Steps:
1. Start game
2. Create save
3. Enable dev logging
4. Quick Load
5. Check console for timing

Expected Result:
✅ Load completes in < 500ms
✅ ~200ms delays present (safety)
✅ Smooth transition

Console Output Should Show:
"Loading save state:"
"  Emulator state before: running"
"  [100ms pause delay]"
"  [50ms load delay]"
"  [50ms resume delay]"
"  Emulator state after: running"
"Save state loaded successfully"
```

### Test 15: Memory Usage
```
Steps:
1. Open Xcode → Debug → Memory Report
2. Note baseline memory
3. Create 10 save states
4. Load each state 3 times
5. Check memory usage

Expected Result:
✅ No memory leaks
✅ Memory returns to baseline
✅ No excessive growth

What to Check:
- Baseline: ~150-200 MB
- After 10 saves: ~160-220 MB
- After loads: Returns to ~150-200 MB
```

---

## 🐛 Error Handling Tests

### Test 16: Save When Stopped
```
Steps:
1. Start game
2. Stop emulator (if possible)
3. Try to save

Expected Result:
✅ Error: "Cannot save state: emulator is stopped"
✅ No crash
```

### Test 17: Load When Stopped
```
Steps:
1. Create a save state
2. Stop emulator
3. Try to load

Expected Result:
✅ Error: "Cannot load state: emulator is stopped"
✅ No crash
```

### Test 18: Disk Full Scenario
```
Steps:
1. Fill device storage (use large files)
2. Try to save state

Expected Result:
✅ Error: "Failed to save: disk full"
✅ No crash
✅ App remains stable
```

---

## 📋 Test Results Template

### Copy and use this template for testing:

```
Test Session: [Date]
Tester: [Name]
Build: [Version]

┌─────────────────────────────────────────────────┐
│ Test 1: Basic Save & Load                      │
├─────────────────────────────────────────────────┤
│ Status: [ ] Pass [ ] Fail [ ] N/A              │
│ Notes: ________________________________         │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│ Test 2: Multiple Save Slots                    │
├─────────────────────────────────────────────────┤
│ Status: [ ] Pass [ ] Fail [ ] N/A              │
│ Notes: ________________________________         │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│ Test 3: Save While Paused                      │
├─────────────────────────────────────────────────┤
│ Status: [ ] Pass [ ] Fail [ ] N/A              │
│ Notes: ________________________________         │
└─────────────────────────────────────────────────┘

[Continue for all 18 tests...]

Overall Results:
- Tests Passed: ____ / 18
- Tests Failed: ____ / 18
- Critical Issues: ____
- Minor Issues: ____

Recommendation:
[ ] Approved for release
[ ] Needs fixes
[ ] Needs retesting
```

---

## 🚨 Known Issues (Expected Behavior)

### Not Bugs - Working As Intended:

1. **~200ms Delay on Load**
   - This is intentional for crash prevention
   - User won't notice (< 1/5 second)
   - Ensures thread safety

2. **Resume Warning in Console**
   - "Warning: Failed to resume emulator after loading save state"
   - Rare edge case, doesn't affect functionality
   - State loads successfully regardless

3. **Emulator Must Be Running**
   - Can't save/load when emulator is stopped
   - This is a safety feature
   - Start game first, then save/load

---

## 📞 Reporting Issues

### If You Find a Crash:

**Collect This Information:**

1. **Steps to Reproduce**
   ```
   1. [First step]
   2. [Second step]
   3. [Third step]
   → Crash occurs
   ```

2. **Console Output**
   ```
   Copy the last 20-30 lines from Xcode console
   Include any "SaveStateManager" or "EmulatorCore" logs
   ```

3. **Device Info**
   ```
   - Device: [iPhone 14 Pro, iPad, etc.]
   - iOS Version: [16.0, 17.0, etc.]
   - Orientation: [Portrait/Landscape]
   - Build Version: [Debug/Release]
   ```

4. **Save State File**
   ```
   - Include the .sav file if possible
   - Location: Documents/SaveStates/
   - File size: [bytes]
   ```

5. **Screenshots/Video**
   ```
   - Screen recording of the crash
   - Screenshot of error message
   ```

---

## ✅ Success Criteria

### All Tests Must Pass:

- [ ] All 18 tests complete successfully
- [ ] No crashes during any test
- [ ] All error messages are clear and helpful
- [ ] Performance is acceptable (< 500ms per operation)
- [ ] Memory usage is stable
- [ ] User experience is smooth

### Quality Metrics:

- **Crash Rate**: 0% (zero tolerance)
- **Success Rate**: > 99%
- **Performance**: < 500ms per operation
- **Memory**: No leaks, stable usage
- **User Satisfaction**: Clear errors, smooth UX

---

## 🎓 Testing Tips

### For Best Results:

1. **Test on Real Device**
   - Simulator doesn't catch all crashes
   - Real device has different performance
   - Test on iOS 15, 16, 17, 18

2. **Use Different Games**
   - Each game may behave differently
   - Test with various ROM sizes
   - Test with different systems (SNES, NES, etc.)

3. **Vary Timing**
   - Save at different game moments
   - Load at different times
   - Test rapid operations

4. **Check Console Logs**
   - Monitor for warnings
   - Look for error patterns
   - Track timing information

5. **Monitor Performance**
   - Use Xcode instruments
   - Watch memory usage
   - Check for leaks

---

**Happy Testing!** 🎮

If all 18 tests pass, the save/load system is production-ready! ✅

---

**Last Updated**: 2025-10-01
**Test Coverage**: 18 Tests
**Critical Tests**: 6 (Tests 1-6)
**Stress Tests**: 6 (Tests 7-12)
**Integration Tests**: 6 (Tests 13-18)
