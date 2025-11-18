# QA Checklist - Infinite Stairs PC

Complete quality assurance checklist for release validation.

## Pre-Release QA Checklist

### Core Gameplay

#### Stair Generation
- [ ] Stairs generate correctly (LEFT/RIGHT alternation)
- [ ] No more than 5 consecutive same-direction stairs
- [ ] Direction changes feel random and fair
- [ ] First stair always appears on game start

#### Input Handling
- [ ] A/Left Arrow moves to left stairs
- [ ] D/Right Arrow moves to right stairs
- [ ] Correct input advances to next stair
- [ ] Wrong input triggers game over
- [ ] ESC pauses/returns to menu

#### Timing System
- [ ] Timer decreases correctly (visual bar)
- [ ] Timer resets after successful input
- [ ] Timeout triggers game over
- [ ] Timer color changes at correct thresholds (5 levels)
- [ ] Timing bonus awards properly (within 80% timeout)

#### Scoring System
- [ ] Basic score: 10 points per stair
- [ ] Combo bonus: 50 points at 10 consecutive
- [ ] Timing bonus: 5 points for fast input
- [ ] Difficulty multipliers apply correctly:
  - EASY: 1.0x
  - NORMAL: 1.2x
  - HARD: 1.5x
- [ ] Score displays update in real-time

### Difficulty Levels

#### EASY
- [ ] Input timeout: 2.5 seconds
- [ ] Obstacle spawn rate: 10%
- [ ] Only CRACK obstacles appear
- [ ] Score multiplier: 1.0x
- [ ] Appropriate for new players

#### NORMAL
- [ ] Input timeout: 1.8 seconds
- [ ] Obstacle spawn rate: 20%
- [ ] CRACK and ICE obstacles appear
- [ ] Score multiplier: 1.2x
- [ ] Balanced challenge

#### HARD
- [ ] Input timeout: 1.2 seconds
- [ ] Obstacle spawn rate: 30%
- [ ] All obstacles (CRACK, ICE, SPIKE) appear
- [ ] Score multiplier: 1.5x
- [ ] High challenge level

### Obstacle System

#### CRACK Obstacles
- [ ] Appear with yellow pulsing indicator
- [ ] Reduce score by 50% on collision
- [ ] Do NOT break combo chain
- [ ] Do NOT cause game over
- [ ] Floating text shows "CRACK! -50%"

#### ICE Obstacles
- [ ] Appear with cyan pulsing indicator
- [ ] Break combo chain on collision
- [ ] Do NOT reduce score
- [ ] Do NOT cause game over
- [ ] Floating text shows "ICE! Combo Lost"

#### SPIKE Obstacles
- [ ] Appear with red pulsing indicator
- [ ] Cause immediate game over
- [ ] Only appear on HARD difficulty
- [ ] Floating text shows "SPIKE!"

### UI/UX

#### Main Menu
- [ ] EASY button starts EASY game
- [ ] NORMAL button starts NORMAL game
- [ ] HARD button starts HARD game
- [ ] Buttons have hover/click feedback
- [ ] Title displays correctly

#### Game HUD
- [ ] Score label updates correctly
- [ ] Stairs counter shows climbed count
- [ ] Combo counter updates and highlights at 10+
- [ ] Difficulty label shows correct difficulty
- [ ] Difficulty label color-coded (Green/Yellow/Red)
- [ ] Timer bar fills/empties correctly
- [ ] Debug label shows current stair direction

#### Game Over Screen
- [ ] Displays final score
- [ ] Displays high score for difficulty
- [ ] Shows "NEW HIGH SCORE!" when applicable
- [ ] Play Again button restarts same difficulty
- [ ] Main Menu button returns to menu
- [ ] All buttons functional

### Visual Effects

#### Animations
- [ ] Stair spawn animation (scale bounce)
- [ ] Obstacle pulsing animation
- [ ] Floating text animations (fade + rise)
- [ ] Timer color transitions smooth
- [ ] Background star field scrolling

#### Floating Text
- [ ] Score gains show as "+X" in green
- [ ] Combo milestones show in gold
- [ ] Obstacle messages show in correct colors
- [ ] Text fades out and floats up smoothly
- [ ] No text overlap or clipping

### Audio System

#### Sound Effects
- [ ] correct_step.ogg plays on valid input
- [ ] wrong_step.ogg plays on invalid input
- [ ] game_over.ogg plays on timeout
- [ ] combo_bonus.ogg plays at combo milestones
- [ ] Sounds don't overlap incorrectly

#### Background Music
- [ ] theme_music.ogg plays on game start
- [ ] Music loops correctly
- [ ] Music stops appropriately
- [ ] Volume levels balanced

**Note:** Audio tests require sound files in assets/sounds/

### Persistence

#### High Score System
- [ ] High scores save to user://high_scores.json
- [ ] Separate high scores per difficulty
- [ ] High scores persist between sessions
- [ ] File creates automatically on first save
- [ ] No data corruption on save/load
- [ ] Invalid scores rejected (negative, NaN)

### Performance

#### Frame Rate
- [ ] Maintains 60 FPS minimum
- [ ] No frame drops during gameplay
- [ ] Smooth animations at all times
- [ ] No stuttering or hitching

#### Memory
- [ ] No memory leaks (stable over time)
- [ ] Memory usage < 200 MB
- [ ] No crashes after extended play (30+ minutes)

#### Responsiveness
- [ ] Input latency < 16ms
- [ ] Game starts < 3 seconds
- [ ] Scene transitions instant

## Platform-Specific QA

### Windows
- [ ] Executable launches without errors
- [ ] Icon shows in taskbar
- [ ] Alt+F4 closes game properly
- [ ] Fullscreen toggle works (if implemented)
- [ ] Save files in correct AppData location

### Linux
- [ ] Executable has correct permissions
- [ ] Launches from terminal without errors
- [ ] Icon shows in dock/taskbar
- [ ] Save files in correct ~/.local/share location
- [ ] Works on X11 and Wayland

### macOS
- [ ] .app bundle opens correctly
- [ ] Right-click → Open works (unsigned app)
- [ ] Icon shows in dock
- [ ] Save files in correct ~/Library location
- [ ] Works on Intel and Apple Silicon (if tested)

## Regression Testing

After any code changes, verify:
- [ ] All 164 automated tests still pass
- [ ] No new console errors or warnings
- [ ] No visual regressions
- [ ] No performance degradation
- [ ] High scores still load correctly

## Accessibility

- [ ] Game playable without sound
- [ ] Color-coded elements distinguishable
- [ ] High contrast for readability
- [ ] Keyboard-only controls work
- [ ] No flashing effects that could trigger photosensitivity

## Edge Cases

#### Extreme Scenarios
- [ ] Score > 10,000 displays correctly
- [ ] Stairs > 1,000 counted correctly
- [ ] Combo > 100 doesn't break UI
- [ ] Very fast inputs handled properly
- [ ] Simultaneous key presses handled

#### Error Recovery
- [ ] Corrupted save file doesn't crash game
- [ ] Missing sound files don't prevent gameplay
- [ ] Invalid difficulty defaults gracefully
- [ ] Null/invalid stairs handled

## Known Acceptable Behaviors

These are **not bugs**:
- Unsigned Windows .exe triggers SmartScreen warning (expected)
- macOS requires Right-click → Open for unsigned app (expected)
- No gamepad support (keyboard-only by design)
- Fixed resolution 1280x720 (design choice)
- No online features (fully offline by design)

## Bug Severity Classification

### Critical (Must Fix Before Release)
- Game crashes
- Data loss (high scores)
- Game unplayable
- Security vulnerabilities

### Major (Should Fix Before Release)
- Incorrect scoring
- Broken obstacles
- UI elements not displaying
- Performance < 30 FPS

### Minor (Can Fix in Patch)
- Visual glitches
- Minor text issues
- Non-critical UX improvements
- Minor performance optimization

### Trivial (Nice to Have)
- Code refactoring
- Comment improvements
- Additional polish

## Sign-Off

Release approved by:
- [ ] Developer: All tests pass, no critical bugs
- [ ] QA: All checklist items verified
- [ ] Producer: Gameplay balanced, ready for players

**Date:** ___________

**Version:** 1.0.0

**Notes:**
