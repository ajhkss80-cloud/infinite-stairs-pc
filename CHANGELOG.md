# Changelog - Infinite Stairs PC

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-18

### Added

#### Core Gameplay
- **Three difficulty levels** with distinct challenge curves
  - EASY: 2.5s timeout, 10% obstacles, 1.0x multiplier
  - NORMAL: 1.8s timeout, 20% obstacles, 1.2x multiplier
  - HARD: 1.2s timeout, 30% obstacles, 1.5x multiplier
- **Dynamic stair generation** with max 5 consecutive same direction
- **Scoring system** with basic score, combo bonuses, and timing rewards
- **Input validation** with immediate feedback

#### Obstacle System
- **Three obstacle types** with unique gameplay effects:
  - CRACK: 50% score penalty (yellow indicator)
  - ICE: Combo chain break (cyan indicator)
  - SPIKE: Instant game over (red indicator, HARD only)
- **Visual indicators** with pulsing animations
- **Difficulty-based spawning** with balanced distribution

#### UI/UX
- **Main menu** with three difficulty selection buttons
- **Game HUD** displaying:
  - Real-time score counter
  - Stairs climbed counter
  - Combo counter with visual emphasis (gold at 10+)
  - Difficulty label (color-coded by difficulty)
  - 5-level timer bar with color gradation
  - Debug info showing current stair direction
- **Game Over screen** with:
  - Final score display
  - High score display per difficulty
  - "NEW HIGH SCORE!" celebration
  - Play Again and Main Menu buttons
- **Floating text feedback** for scores, combos, and obstacles
- **Smooth animations** for all UI elements

#### Visual Effects
- **Stair spawn animation** with bounce effect (Tween TRANS_BACK)
- **Obstacle pulsing** for visibility
- **Floating text** with fade and rise animations
- **Background star field** with scrolling parallax effect
- **Color-coded feedback** for all game states

#### Audio System
- **Sound effects** support:
  - correct_step - Valid input confirmation
  - wrong_step - Invalid input feedback
  - game_over - Timeout notification
  - combo_bonus - Combo milestone celebration
- **Background music** support with looping
- **Volume control** for SFX and BGM independently
- **Mute functionality** for accessibility
- **Polyphonic SFX** (8 concurrent sounds)

#### Persistence
- **High score system** with per-difficulty tracking
- **JSON file storage** (user://high_scores.json)
- **Automatic save** on new high scores
- **Data validation** to prevent corruption

#### Architecture
- **Clean Architecture** with three layers:
  - Core Layer: Pure GDScript business logic
  - Application Layer: Controllers and services
  - UI Layer: Godot scenes and views
- **TDD approach** with 164 automated tests
- **SOLID principles** throughout codebase
- **Error-first design** for robustness

#### Documentation
- **Comprehensive README** with gameplay instructions
- **Game Design Document** (docs/GAME_DESIGN.md)
- **Architecture Document** (docs/ARCHITECTURE.md)
- **Test Strategy** (docs/TEST_STRATEGY.md)
- **Build Guide** (BUILD.md)
- **System Requirements** (SYSTEM_REQUIREMENTS.md)
- **Icon Guide** (ICON_GUIDE.md)
- **Balance Documentation** (BALANCE.md)
- **QA Checklist** (QA_CHECKLIST.md)
- **Sound Assets Guide** (assets/sounds/README.md)

#### Build & Deploy
- **Export presets** for Windows, Linux, and macOS
- **Build scripts** (build.sh / build.bat) for automation
- **Multi-platform support** with platform-specific optimizations

### Technical Details

#### Test Coverage
- **164 total tests** across all layers:
  - 79 Core Layer unit tests
  - 44 Application Layer integration tests
  - 41 mixed integration tests
- **100% Core Layer coverage**
- **All tests passing** ✓

#### Performance
- **60+ FPS** on minimum hardware
- **< 150 MB** memory usage
- **< 3 second** load time
- **< 16ms** input latency

#### Technologies
- **Engine:** Godot 4.3
- **Language:** GDScript
- **Testing:** GUT framework
- **Renderer:** Forward+ (desktop)
- **Minimum OpenGL:** 3.3

### Development Phases

This release represents the culmination of 8 development phases:

1. **Phase 1:** Project skeleton & documentation
2. **Phase 2:** Core Layer (TDD) - DifficultyConfig, StairGenerator, ScoreCalculator
3. **Phase 3:** Application Layer - GameController, StairValidator
4. **Phase 4:** UI/Scene Layer - MVP gameplay complete
5. **Phase 5:** Polish Pass - UX/UI improvements, sound system
6. **Phase 6:** Obstacle System - Full obstacle implementation
7. **Phase 7:** Build & Deploy - Export configuration, documentation
8. **Phase 8:** QA & Balance - Testing, balance tuning, release prep

### Known Limitations

- **Keyboard-only** controls (no gamepad/mouse/touch)
- **Fixed resolution** 1280x720 (design choice)
- **Offline-only** (no online features)
- **Unsigned executables** (Windows SmartScreen warning expected)
- **Sound assets** not included (user must provide .ogg files)

### Credits

- **Engine:** Godot Engine 4.3
- **Development:** TDD with Clean Architecture
- **Testing:** GUT framework
- **Audio:** User-provided (see assets/sounds/README.md)

---

## [Unreleased]

### Planned for v1.1

#### Features Under Consideration
- Custom difficulty settings
- Gamepad support
- Endless mode with progressive difficulty
- Daily challenge mode
- Steam integration (achievements, leaderboards)
- Additional obstacle types
- Power-ups system
- Tutorial mode

#### Platforms Under Consideration
- HTML5/WASM web build
- Android port
- iOS port
- Steam Deck optimization

---

## Version History

- **v1.0.0** (2025-11-18) - Initial Release

---

## How to Report Issues

Found a bug or have a suggestion?

1. Check [KNOWN_ISSUES.md](KNOWN_ISSUES.md) first
2. Open an issue on GitHub with:
   - Game version
   - Platform (Windows/Linux/macOS)
   - Steps to reproduce
   - Expected vs. actual behavior
   - Console output (if applicable)

## Contributing

This is currently a solo project, but feedback is welcome!

For build issues, see [BUILD.md](BUILD.md).
For testing, see [QA_CHECKLIST.md](QA_CHECKLIST.md).

---

**Thank you for playing Infinite Stairs PC!**
