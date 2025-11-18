# Testing Guide - Infinite Stairs PC

Comprehensive guide for running automated tests and manual testing procedures.

## Automated Testing

### Test Framework

**GUT (Godot Unit Test)**
- Version: Compatible with Godot 4.3
- Location: `addons/gut/`
- Test files: `tests/` directory
- Command: `godot --headless -s addons/gut/gut_cmdln.gd`

### Test Structure

```
tests/
├── unit/
│   └── core/              # Core Layer unit tests (Pure GDScript)
│       ├── difficulty/    # 13 tests
│       ├── stair/         # 18 tests
│       ├── score/         # 27 tests
│       └── obstacle/      # 46 tests
└── integration/
    ├── controllers/       # 16 tests
    └── services/          # 44 tests
```

**Total: 164 tests**

### Running All Tests

#### Method 1: Godot Editor (Recommended)

1. Open project in Godot
2. Go to bottom panel → GUT
3. Click "Run All"
4. View results in panel

#### Method 2: Command Line

```bash
# Run all tests
godot --headless -s addons/gut/gut_cmdln.gd -gtest=tests/ -gexit

# Run specific test file
godot --headless -s addons/gut/gut_cmdln.gd -gtest=tests/unit/core/difficulty/test_difficulty_config.gd -gexit

# Run specific test directory
godot --headless -s addons/gut/gut_cmdln.gd -gtest=tests/unit/core/ -gexit
```

#### Method 3: CI/CD (GitHub Actions)

```yaml
- name: Run Tests
  run: |
    godot --headless -s addons/gut/gut_cmdln.gd -gtest=tests/ -gexit
```

### Test Coverage

| Layer | Tests | Coverage |
|-------|-------|----------|
| **Core Layer** | 104 | 100% |
| **Application Layer** | 60 | 95% |
| **UI Layer** | 0 | Manual only |
| **Total** | 164 | ~85% |

**Note:** UI Layer tested manually (see Manual Testing section)

### Test Categories

#### Unit Tests (Pure Logic)

**DifficultyConfig (13 tests):**
- Timeout values for each difficulty
- Scroll speed (reserved for future)
- Obstacle rates
- Score multipliers
- Error handling for invalid difficulty

**StairGenerator (10 tests):**
- Direction generation randomness
- Max consecutive same direction (5)
- Reset functionality
- Seeded randomness

**ScoreCalculator (27 tests):**
- Basic score calculation (10 pts/stair)
- Combo bonus (50 pts at 10 consecutive)
- Timing bonus (5 pts within 80% timeout)
- Difficulty multipliers
- Edge cases (negative, zero, large numbers)

**StairValidator (8 tests):**
- Input validation (correct/wrong direction)
- Null stair handling
- Invalid direction handling

**Obstacle Model (21 tests):**
- Type validation
- Effect methods (score_penalty, breaks_combo, causes_game_over)
- Display names

**ObstacleFactory (25 tests):**
- Spawn rate by difficulty
- Type distribution by difficulty
- Seeded randomness
- Edge cases

#### Integration Tests

**GameController (16 tests):**
- Full game flow (start → input → score → game over)
- Difficulty integration
- Score calculation with all components
- Timeout detection
- High score integration
- Obstacle integration

**SaveService (16 tests):**
- Save/load high scores
- Per-difficulty tracking
- File persistence
- Error handling (corrupt data, invalid scores)

**SoundManager (28 tests):**
- SFX playback (polyphonic)
- BGM playback (single track)
- Volume control
- Mute functionality
- Resource loading

### Expected Test Results

**All tests should pass:**
```
Tests:      164
Passed:     164  (100.0%)
Failed:     0    (0.0%)
Errors:     0    (0.0%)
Warnings:   0    (0.0%)
Orphans:    0    (Good!)
```

### Common Test Failures

#### Import Errors
```
Error: Failed to load 'res://src/core/...'
```
**Fix:** Ensure all class_name declarations are correct

#### Random Seed Issues
```
Test failed: Expected X but got Y
```
**Fix:** Tests use seeded RNG - check seed is set correctly

#### Floating Point Precision
```
Expected: 15.0, Got: 15.000001
```
**Fix:** Use assert_almost_eq() for float comparisons

## Manual Testing

### Pre-Flight Test (5 minutes)

Quick smoke test before releases:

1. **Launch Game**
   - [ ] Game opens without errors
   - [ ] Main menu displays correctly

2. **EASY Gameplay**
   - [ ] Play for 30 seconds
   - [ ] Climb 10+ stairs
   - [ ] Verify scoring works
   - [ ] Trigger game over (timeout or wrong input)

3. **NORMAL Gameplay**
   - [ ] Play for 30 seconds
   - [ ] Encounter obstacles
   - [ ] Achieve combo (10+ consecutive)
   - [ ] Verify high score saves

4. **HARD Gameplay**
   - [ ] Play until encountering SPIKE
   - [ ] Verify SPIKE causes game over
   - [ ] Check all obstacle types appear

5. **UI Verification**
   - [ ] Check all HUD elements update
   - [ ] Verify floating text appears
   - [ ] Test Play Again and Main Menu buttons

### Complete Test Suite (30 minutes)

Full manual testing procedure:

#### Test 1: Stair Generation
- **Duration:** 5 minutes
- **Steps:**
  1. Start EASY game
  2. Play for 100 stairs
  3. Observe stair patterns
- **Verify:**
  - No more than 5 consecutive same direction
  - Patterns feel random
  - Both LEFT and RIGHT stairs appear

#### Test 2: Timing System
- **Duration:** 5 minutes
- **Steps:**
  1. Start NORMAL game
  2. Test varying input speeds
  3. Observe timer bar behavior
- **Verify:**
  - Timer resets after each input
  - Timer color changes at correct thresholds
  - Timeout triggers game over
  - Fast inputs award timing bonus

#### Test 3: Scoring System
- **Duration:** 5 minutes
- **Steps:**
  1. Start HARD game
  2. Achieve 10 consecutive (combo bonus)
  3. Test timing bonus (fast inputs)
  4. Test obstacle penalties
- **Verify:**
  - Basic score: 10 pts/stair
  - Combo bonus: 50 pts at 10 consecutive
  - Timing bonus: 5 pts for fast input
  - HARD multiplier: 1.5x applied
  - CRACK reduces score by 50%

#### Test 4: Obstacle Behavior
- **Duration:** 5 minutes per difficulty
- **EASY:**
  - Verify 10% obstacle rate (~1 per 10 stairs)
  - Verify only CRACK appears
  - Test CRACK effect (score reduction)
- **NORMAL:**
  - Verify 20% obstacle rate
  - Verify CRACK and ICE appear
  - Test ICE effect (combo break)
- **HARD:**
  - Verify 30% obstacle rate
  - Verify all obstacles appear
  - Test SPIKE effect (game over)

#### Test 5: High Score Persistence
- **Duration:** 5 minutes
- **Steps:**
  1. Achieve score on EASY (e.g., 500)
  2. Quit to main menu
  3. Play EASY again, score lower (e.g., 300)
  4. Check Game Over screen shows 500 as high score
  5. Close game completely
  6. Relaunch game
  7. Play EASY, verify high score still 500
- **Verify:**
  - High scores save per difficulty
  - High scores persist between sessions
  - "NEW HIGH SCORE!" shows when appropriate

#### Test 6: Visual Effects
- **Duration:** 5 minutes
- **Steps:**
  1. Play any difficulty
  2. Observe all visual effects
- **Verify:**
  - Stair spawn animation (bounce)
  - Obstacle pulsing animation
  - Floating text (scores, combos, obstacles)
  - Timer color gradation (5 levels)
  - Background stars scrolling
  - Combo counter highlights at 10+

#### Test 7: Audio System
- **Duration:** 5 minutes (requires sound files)
- **Steps:**
  1. Ensure sound files are in assets/sounds/
  2. Start game
  3. Trigger all sound effects
- **Verify:**
  - correct_step plays on valid input
  - wrong_step plays on invalid input
  - game_over plays on timeout
  - combo_bonus plays at combo milestones
  - theme_music loops in background
  - No audio crackling or distortion

### Platform-Specific Testing

#### Windows
- [ ] Executable launches (handle SmartScreen warning)
- [ ] Icon appears in taskbar
- [ ] Alt+F4 closes game
- [ ] Save file in correct AppData location

#### Linux
- [ ] Executable permission set correctly
- [ ] Launches from terminal without errors
- [ ] Icon appears in dock
- [ ] Save file in correct ~/.local/share location

#### macOS
- [ ] .app bundle opens (handle Gatekeeper)
- [ ] Icon appears in dock
- [ ] Cmd+Q closes game
- [ ] Save file in correct ~/Library location

### Regression Testing

After any code changes:

1. **Run automated tests**
   ```bash
   godot --headless -s addons/gut/gut_cmdln.gd -gtest=tests/ -gexit
   ```

2. **Run Pre-Flight Test** (5 minutes)

3. **Verify no new errors** in console

4. **Check performance** (FPS, memory usage)

### Performance Testing

#### FPS Test
- **Tool:** Godot Profiler or external FPS counter
- **Target:** 60 FPS minimum
- **Steps:**
  1. Enable FPS counter
  2. Play for 5 minutes
  3. Monitor FPS throughout
- **Verify:**
  - No drops below 60 FPS
  - Average FPS > 100 (on modern hardware)
  - Stable frame times

#### Memory Test
- **Tool:** Task Manager / Activity Monitor
- **Target:** < 200 MB RAM usage
- **Steps:**
  1. Monitor memory before launch
  2. Launch game
  3. Play for 30 minutes
  4. Monitor memory usage
- **Verify:**
  - Initial: ~100-150 MB
  - After 30 min: < 200 MB (no leaks)
  - No gradual increase over time

### Stress Testing

#### Endurance Test
- **Duration:** 1 hour
- **Goal:** Verify no crashes or memory leaks
- **Steps:**
  1. Start EASY mode
  2. Play until 500+ stairs (or game over, restart)
  3. Monitor for issues
- **Verify:**
  - No crashes
  - No memory leaks
  - Performance stable
  - All features still work

#### Rapid Input Test
- **Duration:** 5 minutes
- **Goal:** Verify input handling
- **Steps:**
  1. Start EASY mode
  2. Press keys rapidly and randomly
  3. Try simultaneous key presses
- **Verify:**
  - No crashes
  - Input queue handled correctly
  - No stuck states

## Test Data

### Sample High Scores for Testing

Create `user://high_scores.json` manually:
```json
{
	"0": 1234.0,
	"1": 2345.0,
	"2": 3456.0
}
```

### Test Save File Locations

- **Windows:** `%APPDATA%\Godot\app_userdata\InfiniteStairs\high_scores.json`
- **Linux:** `~/.local/share/godot/app_userdata/InfiniteStairs/high_scores.json`
- **macOS:** `~/Library/Application Support/Godot/app_userdata/InfiniteStairs/high_scores.json`

## Continuous Integration

### GitHub Actions Example

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: chickensoft-games/setup-godot@v1
        with:
          version: 4.3
      - name: Run Tests
        run: |
          godot --headless -s addons/gut/gut_cmdln.gd -gtest=tests/ -gexit
```

## Reporting Test Failures

When tests fail, report:

1. **Test name:** Which test failed?
2. **Expected:** What should happen?
3. **Actual:** What actually happened?
4. **Error message:** Full error output
5. **Reproduction:** Steps to reproduce
6. **Environment:** Godot version, OS, etc.

## Best Practices

1. **Run tests before committing** code changes
2. **Write tests first** (TDD) for new features
3. **Keep tests fast** (< 5 seconds total)
4. **Test edge cases** (null, negative, large numbers)
5. **Use descriptive test names**
6. **One assertion per test** (when possible)
7. **Clean up after tests** (free resources)

## Conclusion

- **164 automated tests** provide solid coverage
- **Manual testing** complements automation
- **Platform testing** ensures compatibility
- **Performance testing** ensures smooth gameplay
- **Regression testing** prevents bugs

All tests passing = Ready to release! ✅

---

**Last Updated:** 2025-11-18
**Version:** 1.0.0
