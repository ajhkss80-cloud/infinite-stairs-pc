# Infinite Stairs PC

> 🎮 Fast-paced 2D arcade stair-climbing game inspired by the mobile classic

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/yourusername/infinite-stairs-pc/releases)
[![Godot](https://img.shields.io/badge/Godot-4.3-blue.svg)](https://godotengine.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/tests-164%20passing-brightgreen.svg)](TESTING_GUIDE.md)

## 🎯 Overview

**Infinite Stairs PC** is a modern reimagining of the mobile game "Infinite Stairs" for desktop platforms. Climb an endless staircase using only two keys, avoid obstacles, build combos, and chase high scores!

### Key Features

- **🎮 Three Difficulty Levels** - EASY, NORMAL, HARD with distinct challenges
- **🚧 Dynamic Obstacles** - CRACK (score penalty), ICE (combo break), SPIKE (instant death)
- **🏆 High Score System** - Per-difficulty leaderboards with automatic save
- **🎨 Polished UX** - Smooth animations, floating text feedback, visual effects
- **🔊 Audio Support** - SFX and background music (user-provided)
- **⚡ High Performance** - 60+ FPS, lightweight (~150 MB RAM)
- **📊 164 Automated Tests** - 85% code coverage with TDD methodology
- **🌐 Cross-Platform** - Windows, Linux, macOS

## 🎮 Gameplay

### Controls

| Action | Keys |
|--------|------|
| Move Left | `A` or `←` |
| Move Right | `D` or `→` |
| Pause/Menu | `ESC` |

### Difficulty Comparison

| Difficulty | Timeout | Obstacle Rate | Multiplier |
|------------|---------|---------------|------------|
| **EASY** | 2.5s | 10% | 1.0x |
| **NORMAL** | 1.8s | 20% | 1.2x |
| **HARD** | 1.2s | 30% | 1.5x |

### Obstacles

- **🟡 CRACK** - Reduces score by 50%, combo preserved
- **🔵 ICE** - Breaks combo chain, score preserved
- **🔴 SPIKE** - Instant game over (HARD only)

### Scoring

```
Score = (10 pts/stair + combo bonus + timing bonus) × difficulty multiplier
```

- **Combo Bonus:** 50 points every 10 consecutive stairs
- **Timing Bonus:** 5 points for quick inputs (within 80% of timeout)

## 🚀 Quick Start

### Download & Play

1. Download latest release from [Releases](https://github.com/yourusername/infinite-stairs-pc/releases)
2. Extract archive
3. Run executable:
   - **Windows:** `InfiniteStairs.exe`
   - **Linux:** `./InfiniteStairs.x86_64` (may need `chmod +x`)
   - **macOS:** Open `InfiniteStairs.app` (Right-click → Open for unsigned app)

### Build from Source

**Requirements:**
- Godot 4.3+
- Git

**Steps:**
```bash
# Clone repository
git clone https://github.com/yourusername/infinite-stairs-pc.git
cd infinite-stairs-pc

# Open in Godot
godot -e project.godot

# OR build directly
./build.sh all
```

See [BUILD.md](BUILD.md) for detailed build instructions.

## 📦 System Requirements

### Minimum

- **OS:** Windows 7+ / Ubuntu 18.04+ / macOS 10.13+
- **CPU:** Dual-core 2.0 GHz
- **RAM:** 2 GB
- **GPU:** OpenGL 3.3 compatible
- **Storage:** 50 MB

### Recommended

- **CPU:** Quad-core 2.5+ GHz
- **RAM:** 4 GB
- **GPU:** Dedicated GPU with OpenGL 4.5+
- **Display:** 1920x1080 (Full HD)

See [SYSTEM_REQUIREMENTS.md](SYSTEM_REQUIREMENTS.md) for full details.

## 🎵 Audio Setup

The game supports audio but doesn't include sound files (licensing). Add your own `.ogg` files:

```
assets/sounds/
├── sfx/
│   ├── correct_step.ogg
│   ├── wrong_step.ogg
│   ├── game_over.ogg
│   └── combo_bonus.ogg
└── bgm/
    └── theme_music.ogg
```

See [assets/sounds/README.md](assets/sounds/README.md) for audio specifications.

## 🏗️ Architecture

Built with **Clean Architecture** and **TDD** principles:

```
┌─────────────────────────────────────┐
│         UI Layer (Godot)            │
│  Views, Scenes, Input Handling      │
├─────────────────────────────────────┤
│     Application Layer (GDScript)    │
│  Controllers, Services, Use Cases   │
├─────────────────────────────────────┤
│      Core Layer (Pure GDScript)     │
│  Domain Logic, Entities, Rules      │
└─────────────────────────────────────┘
```

### Project Structure

```
infinite-stairs-pc/
├── src/
│   ├── core/                 # Pure business logic (100% tested)
│   │   ├── difficulty/       # Difficulty configuration
│   │   ├── stair/            # Stair generation & validation
│   │   ├── score/            # Score calculation
│   │   └── obstacle/         # Obstacle system
│   ├── application/          # Controllers & services
│   │   ├── controllers/      # GameController
│   │   └── services/         # SaveService, SoundManager
│   └── ui/                   # View scripts (Thin UI)
│       └── views/            # MainView, GameView, GameOverView
├── scenes/                   # Godot scenes (.tscn)
├── tests/                    # 164 automated tests
├── docs/                     # Design documents
└── builds/                   # Export builds (generated)
```

## 🧪 Testing

### Run Automated Tests

```bash
# All tests (164 total)
godot --headless -s addons/gut/gut_cmdln.gd -gtest=tests/ -gexit

# Specific test suite
godot --headless -s addons/gut/gut_cmdln.gd -gtest=tests/unit/core/ -gexit
```

### Test Coverage

- **Core Layer:** 104 tests (100% coverage)
- **Application Layer:** 60 tests (95% coverage)
- **Total:** 164 tests (85% overall coverage)

See [TESTING_GUIDE.md](TESTING_GUIDE.md) for comprehensive testing procedures.

## 📚 Documentation

- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes
- **[BUILD.md](BUILD.md)** - Build and distribution guide
- **[BALANCE.md](BALANCE.md)** - Game balance and playtesting data
- **[QA_CHECKLIST.md](QA_CHECKLIST.md)** - Quality assurance procedures
- **[TESTING_GUIDE.md](TESTING_GUIDE.md)** - Testing documentation
- **[KNOWN_ISSUES.md](KNOWN_ISSUES.md)** - Known limitations and workarounds
- **[SYSTEM_REQUIREMENTS.md](SYSTEM_REQUIREMENTS.md)** - Hardware requirements
- **[docs/](docs/)** - Design documents (Game Design, Architecture, Test Strategy)

## 🐛 Known Issues

- **Unsigned executables** - Security warnings expected (see workarounds in [KNOWN_ISSUES.md](KNOWN_ISSUES.md))
- **No sound files included** - User must provide own audio (licensing)
- **Fixed resolution** - 1280x720 by design (fullscreen available)

## 🤝 Contributing

This is primarily a solo TDD demonstration project, but feedback is welcome!

1. Check [KNOWN_ISSUES.md](KNOWN_ISSUES.md) first
2. Open an issue with detailed description
3. Include platform, version, and steps to reproduce

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Credits

- **Engine:** [Godot Engine 4.3](https://godotengine.org/)
- **Testing Framework:** [GUT (Godot Unit Test)](https://github.com/bitwes/Gut)
- **Inspiration:** "Infinite Stairs" mobile game
- **Development Methodology:** TDD, Clean Architecture, SOLID principles

## 📈 Project Stats

- **Lines of Code:** ~3,000+ (excluding tests)
- **Test Code:** ~2,500+
- **Tests:** 164 (all passing ✓)
- **Development Time:** 8 phases (iterative TDD)
- **Commits:** 10+ (organized by phase)

## 🎯 Roadmap

### v1.0.0 (Current)
- ✅ Core gameplay complete
- ✅ Three difficulties with obstacles
- ✅ High score system
- ✅ Audio support
- ✅ Cross-platform builds

### v1.1 (Planned)
- Custom difficulty settings
- Gamepad support
- Endless mode with progressive difficulty
- Additional obstacles
- Steam integration (achievements, leaderboards)
- Mobile ports (Android, iOS)

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/yourusername/infinite-stairs-pc/issues)
- **Discussions:** [GitHub Discussions](https://github.com/yourusername/infinite-stairs-pc/discussions)
- **Build Help:** See [BUILD.md](BUILD.md)
- **Testing:** See [TESTING_GUIDE.md](TESTING_GUIDE.md)

---

**Made with ❤️ using Godot Engine and TDD principles**

**[Download Now](https://github.com/yourusername/infinite-stairs-pc/releases)** | **[View Documentation](docs/)** | **[Report Issue](https://github.com/yourusername/infinite-stairs-pc/issues)**
