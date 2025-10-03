# Street Fighter 2 Cheat Database - Visual Guide

## 📱 User Interface Flow

```
┌─────────────────────────────────────────┐
│         Game Menu                       │
├─────────────────────────────────────────┤
│  [Quick] [States] [Cheats] [Settings]  │
└─────────────────────────────────────────┘
                      ↓ Select "Cheats"
┌─────────────────────────────────────────┐
│         Cheats Tab                      │
├─────────────────────────────────────────┤
│  ➕ Add Cheat Code                      │
│  📖 Browse Cheat Database ← NEW!        │
│                                         │
│  Active Cheats                          │
│  ┌─────────────────────────────────┐   │
│  │ Infinite Health P1         [ON] │   │
│  │ 7E0433:60                       │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
                      ↓ Tap "Browse Cheat Database"
┌─────────────────────────────────────────┐
│    Cheat Database - Street Fighter 2    │
├─────────────────────────────────────────┤
│  ⬇️ Import All Cheats                   │
│  Import all available cheats at once    │
│                                         │
│  Available Cheats (8)                   │
│  ┌─────────────────────────────────┐   │
│  │ Infinite Health P1          ➕   │   │
│  │ 7E0433:60                       │   │
│  │ Raw Memory                      │   │
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │ Infinite Time               ➕   │   │
│  │ 7E0194:99                       │   │
│  │ Raw Memory                      │   │
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │ Full Super Meter P1         ➕   │   │
│  │ 7E0436:FF                       │   │
│  │ Raw Memory                      │   │
│  └─────────────────────────────────┘   │
│  ... (5 more cheats)                    │
└─────────────────────────────────────────┘
```

---

## 🎮 Street Fighter 2 Cheats Explained

### Player 1 Enhancement Cheats

#### 1. Infinite Health P1
```
Code: 7E0433:60
Effect: Player 1's health bar stays full
When to use: Practice combos without dying
```

#### 2. Max Power P1
```
Code: 7E0435:FF
Effect: Player 1 always at maximum power level
When to use: Maximize damage output
```

#### 3. Full Super Meter P1
```
Code: 7E0436:FF
Effect: Super combo gauge always full
When to use: Practice super moves anytime
```

### Opponent Control Cheats

#### 4. One Hit Kills
```
Code: 7E0533:00
Effect: Opponent's health drops to zero on first hit
When to use: Quick wins, testing endings
```

#### 5. Infinite Health P2
```
Code: 7E0633:60
Effect: Player 2/Opponent never loses health
When to use: Endless practice matches
```

### Game Modifier Cheats

#### 6. Infinite Time
```
Code: 7E0194:99
Effect: Round timer never decreases
When to use: No time pressure, practice mode
```

#### 7. Always Win Round
```
Code: 7E0438:02
Effect: Automatically win current round
When to use: Skip ahead quickly
```

#### 8. All Characters
```
Code: 7E0200:0F
Effect: Unlock all fighters including bosses
When to use: Play as M. Bison, Vega, Balrog, Sagat
```

---

## 🎯 Common Cheat Combinations

### Combo 1: God Mode (Invincibility)
```
✅ Infinite Health P1
✅ Max Power P1
✅ Full Super Meter P1

Result: Unstoppable player with infinite resources
Perfect for: Story mode speedruns
```

### Combo 2: Training Mode
```
✅ Infinite Health P1
✅ Infinite Health P2
✅ Infinite Time

Result: Endless practice matches
Perfect for: Learning combos and move sets
```

### Combo 3: Quick Playthrough
```
✅ One Hit Kills
✅ Infinite Time
✅ All Characters

Result: One-shot victories with any character
Perfect for: Seeing all endings quickly
```

### Combo 4: Boss Rush
```
✅ All Characters
✅ Infinite Health P1
✅ Full Super Meter P1

Result: Play as bosses with infinite resources
Perfect for: Experiencing boss move sets
```

---

## 🔬 How Cheats Work (Technical)

### Memory Address Structure

```
SNES Memory Map:
┌──────────────────────────────────────┐
│ 7E0000-7FFFFF: System RAM (WRAM)    │
│   ├─ 7E0000-7E01FF: Page 0          │
│   ├─ 7E0200-7E0FFF: Game Variables  │ ← Street Fighter 2 data here
│   └─ 7E1000-7FFFFF: Stack/Buffer    │
└──────────────────────────────────────┘
```

### Street Fighter 2 Memory Locations

```
7E0194: Timer (99 = infinite)
7E0200: Character Select (0F = all unlocked)
7E0433: Player 1 Health (60 = near max)
7E0435: Player 1 Power Level (FF = maximum)
7E0436: Player 1 Super Meter (FF = full)
7E0438: Round Win Counter (02 = auto-win)
7E0533: Player 2 Health (00 = instant KO)
7E0633: Player 2 Health (60 = near max)
```

### Cheat Application Process

```
1. User enables cheat
2. CheatCodeManager parses code: "7E0433:60"
   ├─ Address: 0x7E0433
   └─ Value: 0x60
3. Timer starts (every 0.1 seconds)
4. Write value to memory address
5. Emulator reads modified value
6. Game uses modified value
7. Effect visible in gameplay
```

---

## 💡 Tips & Tricks

### Tip 1: Stack Cheats for Maximum Effect
```
Instead of one cheat, combine multiple:

Beginner Setup:
✅ Infinite Health P1
✅ Infinite Time

Advanced Setup:
✅ Infinite Health P1
✅ Max Power P1
✅ Full Super Meter P1
✅ One Hit Kills
✅ All Characters
```

### Tip 2: Test Before Playing
```
1. Enable cheats in menu
2. Resume game
3. Verify effects are active
4. If not working, toggle off/on
```

### Tip 3: Disable Cheats for Challenge
```
When you want normal gameplay:
1. Open menu
2. Cheats tab
3. Toggle all OFF
4. Resume normal difficulty
```

### Tip 4: Save States with Cheats
```
You can save game state with active cheats:
1. Enable desired cheats
2. Play to desired point
3. Save state (Quick Save)
4. Load anytime with cheats active
```

---

## 🎬 Quick Start Guide

### 30-Second Setup
```
1. Start Street Fighter 2
2. Tap [Menu] button (beside Start)
3. Go to Cheats tab
4. Tap "Browse Cheat Database"
5. Tap "Import All Cheats"
6. Toggle desired cheats ON
7. Close menu
8. Enjoy!
```

### First-Time User Flow
```
New Player Journey:

1️⃣ Start game
   "Hmm, this is hard!"

2️⃣ Open menu
   "What's this Menu button?"

3️⃣ See Cheats tab
   "Browse Cheat Database? Cool!"

4️⃣ See 8 cheats available
   "Infinite Health? Yes please!"

5️⃣ Import all cheats
   "Import All Cheats - easy!"

6️⃣ Enable favorites
   "Just turn these on..."

7️⃣ Resume game
   "Wow, I'm unstoppable!"

8️⃣ Beat the game
   "That was fun, what about normal mode?"

9️⃣ Disable cheats
   "Challenge accepted!"
```

---

## 📊 Cheat Effectiveness Chart

```
Cheat                    | Gameplay Impact | Fairness | Fun Factor
─────────────────────────┼─────────────────┼──────────┼───────────
Infinite Health P1       | ████████████ 5  | ██ 1     | ████ 4
Infinite Time            | ██████ 3        | ████ 4   | ████ 4
Full Super Meter P1      | ████████ 4      | ███ 3    | █████ 5
One Hit Kills            | █████████████ 5 | █ 0      | ███ 3
Max Power P1             | ████████ 4      | ███ 3    | ████ 4
Always Win Round         | █████████████ 5 | █ 0      | ██ 2
All Characters           | ████ 2          | █████ 5  | █████ 5
```

**Legend:**
- Gameplay Impact: How much it changes the game
- Fairness: How balanced/fair it is (higher = more fair)
- Fun Factor: How entertaining it is to use

---

## 🏆 Achievement Ideas (Future)

```
Achievements Using Cheats:

🎖️ "Cheat Master"
   - Enable all 8 cheats simultaneously

🎖️ "Quick Victory"
   - Beat game using One Hit Kills in under 10 minutes

🎖️ "Boss Hunter"
   - Unlock and play as all boss characters

🎖️ "Combo King"
   - Land 100-hit combo using Infinite Time

🎖️ "Immortal"
   - Complete arcade mode without taking damage
   (using Infinite Health)

🎖️ "Super Saiyan"
   - Win 10 rounds with Full Super Meter
```

---

## 📚 Cheat Code Reference Card

```
╔════════════════════════════════════════════════════════╗
║     STREET FIGHTER 2 - QUICK REFERENCE CARD           ║
╠════════════════════════════════════════════════════════╣
║                                                        ║
║  PLAYER ENHANCEMENTS                                   ║
║  ├─ 7E0433:60 → Infinite Health P1                    ║
║  ├─ 7E0435:FF → Max Power P1                          ║
║  └─ 7E0436:FF → Full Super Meter P1                   ║
║                                                        ║
║  OPPONENT CONTROL                                      ║
║  ├─ 7E0533:00 → One Hit Kills                         ║
║  └─ 7E0633:60 → Infinite Health P2                    ║
║                                                        ║
║  GAME MODIFIERS                                        ║
║  ├─ 7E0194:99 → Infinite Time                         ║
║  ├─ 7E0438:02 → Always Win Round                      ║
║  └─ 7E0200:0F → All Characters                        ║
║                                                        ║
║  ALL CODES USE: Raw Memory Format                      ║
║  Press [Menu] → Cheats → Browse Database               ║
╚════════════════════════════════════════════════════════╝
```

---

**Print this page and keep it handy while playing!** 🎮

---

**Last Updated**: 2025-10-01
**Game**: Street Fighter 2 (SNES)
**Total Cheats**: 8
**Difficulty**: ⭐ Easy (one-tap import)
