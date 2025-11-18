# Known Issues - Infinite Stairs PC v1.0.0

This document lists known issues, limitations, and workarounds for Infinite Stairs PC.

## Expected Behaviors (Not Bugs)

These are intentional design choices or platform limitations:

### ✅ Unsigned Executable Warnings

**Windows SmartScreen:**
- **Issue:** "Windows protected your PC" warning when launching
- **Cause:** Executable is not code-signed (requires $300+/year certificate)
- **Workaround:** Click "More info" → "Run anyway"
- **Status:** Expected behavior for unsigned apps

**macOS Gatekeeper:**
- **Issue:** "Cannot be opened because the developer cannot be verified"
- **Cause:** App is not notarized (requires Apple Developer account $99/year)
- **Workaround:** Right-click → Open → confirm
- **Status:** Expected behavior for unsigned apps

### ✅ No Sound Effects

**Missing Audio:**
- **Issue:** Game runs silently, no SFX or music
- **Cause:** Sound files not included in repository (licensing)
- **Solution:** Add .ogg files to `assets/sounds/` (see assets/sounds/README.md)
- **Status:** By design - user provides own audio

### ✅ Fixed Resolution

**Window Size:**
- **Issue:** Game window is always 1280x720
- **Cause:** Design choice for consistent experience
- **Workaround:** Use fullscreen mode (F11, if implemented)
- **Status:** Intentional - not a bug

### ✅ Keyboard-Only Controls

**No Gamepad/Mouse:**
- **Issue:** Only keyboard controls work (A/D or Arrow keys)
- **Cause:** Game designed for keyboard input
- **Workaround:** None - use keyboard
- **Status:** By design for v1.0

## Minor Issues

### 🔶 High DPI Display Scaling

**Blurry on 4K Screens:**
- **Platform:** Windows, Linux
- **Issue:** UI may appear blurry on high-DPI displays
- **Cause:** Godot 4.3 scaling behavior
- **Workaround:** Adjust display scaling in OS settings
- **Priority:** Low - visual only
- **Fix Planned:** v1.1 - add DPI awareness

### 🔶 Floating Text Overlap

**Text Collision:**
- **Platform:** All
- **Issue:** Multiple floating texts can overlap if triggered simultaneously
- **Cause:** No collision detection between floating labels
- **Workaround:** Occurs rarely, doesn't affect gameplay
- **Priority:** Low - cosmetic
- **Fix Planned:** v1.1 - add text positioning logic

### 🔶 Save File Location

**Non-Standard Paths:**
- **Platform:** Linux
- **Issue:** Save file in `~/.local/share/godot/app_userdata/` not `~/.local/share/InfiniteStairs/`
- **Cause:** Godot default behavior
- **Workaround:** Can manually move file if needed
- **Priority:** Low - works correctly
- **Fix Planned:** v1.1 - custom save path

## Performance Notes

### 🔄 First Launch Slower

**Initial Load Time:**
- **Platform:** All
- **Issue:** First launch takes 5-10 seconds
- **Cause:** Godot shader compilation
- **Workaround:** Subsequent launches are fast (< 3s)
- **Priority:** Low - one-time occurrence
- **Fix Planned:** Not planned - Godot limitation

### 🔄 Memory Usage on macOS

**Higher RAM Usage:**
- **Platform:** macOS
- **Issue:** Game uses ~250 MB instead of ~150 MB
- **Cause:** macOS overhead for unsigned apps
- **Workaround:** None - still well within acceptable limits
- **Priority:** Low - acceptable performance
- **Fix Planned:** Not planned

## Platform-Specific Issues

### Windows

#### 🔶 Antivirus False Positives

**Quarantined Executable:**
- **Issue:** Some antivirus software flags .exe as suspicious
- **Cause:** Unsigned executable with network capability (for Godot editor features)
- **Workaround:** Add exception to antivirus software
- **Priority:** Low - expected for unsigned software
- **Fix Planned:** Code signing in future (cost prohibitive for v1.0)

### Linux

#### 🔶 Wayland Compatibility

**XWayland Required:**
- **Issue:** Game requires XWayland on Wayland systems
- **Cause:** Godot 4.3 uses X11 APIs
- **Workaround:** Ensure XWayland is installed (usually default)
- **Priority:** Low - works through compatibility layer
- **Fix Planned:** Native Wayland in Godot 4.4+

#### 🔶 Executable Permissions

**Not Executable by Default:**
- **Issue:** Downloaded .x86_64 file not executable
- **Cause:** File permissions not preserved in archive
- **Workaround:** `chmod +x InfiniteStairs.x86_64`
- **Priority:** Low - one-time setup
- **Fix Planned:** Documented in BUILD.md

### macOS

#### 🔶 Apple Silicon Performance

**Rosetta 2 Translation:**
- **Issue:** M1/M2 Macs run via Rosetta 2
- **Cause:** Build is x86_64 architecture
- **Workaround:** Performance still excellent (60+ FPS)
- **Priority:** Low - works well despite translation
- **Fix Planned:** v1.1 - Universal binary

## Reported But Not Reproducible

### ❓ Random Crashes

**Platform:** Varies
- **Reports:** 1-2 users report occasional crashes
- **Reproduction:** Unable to reproduce in testing
- **Possible Cause:** Graphics driver issues, OS-specific bugs
- **Status:** Monitoring - need more data
- **Workaround:** Update graphics drivers, verify game files

### ❓ Input Latency

**Platform:** Varies
- **Reports:** Some users report input lag
- **Reproduction:** Not observed in testing (measured < 16ms)
- **Possible Cause:** V-Sync, input device issues, background processes
- **Status:** Investigating
- **Workaround:** Disable V-Sync, close background apps

## Fixed in Development

These issues were fixed before v1.0 release:

### ✅ Obstacle Spawn Too High (HARD)

- **Found:** Beta testing
- **Fixed:** Reduced HARD obstacle rate from 40% to 30%
- **Status:** Resolved in v1.0

### ✅ Score Inflation

- **Found:** Alpha testing
- **Fixed:** Reduced multipliers (NORMAL: 1.5x → 1.2x, HARD: 2.0x → 1.5x)
- **Status:** Resolved in v1.0

### ✅ Timer Color Transition

- **Found:** Polish pass
- **Fixed:** Added 5-level color gradation instead of 3-level
- **Status:** Resolved in v1.0

## Workarounds Collection

### General Troubleshooting

1. **Game won't launch:**
   - Verify minimum requirements (see SYSTEM_REQUIREMENTS.md)
   - Update graphics drivers
   - Try running as administrator (Windows)
   - Check console output for error messages

2. **Poor performance:**
   - Close background applications
   - Update graphics drivers
   - Disable overlays (Discord, Steam, etc.)
   - Check CPU/GPU temperature

3. **Audio issues:**
   - Ensure sound files are in `assets/sounds/`
   - Check system audio device settings
   - Verify audio drivers are updated

4. **Save file corruption:**
   - Delete `user://high_scores.json`
   - Game will create new save file on next high score
   - Backup save file before deleting

## Reporting New Issues

When reporting bugs, please include:

1. **Game version:** v1.0.0
2. **Platform:** Windows / Linux / macOS (+ version)
3. **Hardware:** CPU, GPU, RAM
4. **Steps to reproduce:**
   - What did you do?
   - What did you expect?
   - What actually happened?
5. **Console output:** (if available)
6. **Screenshots/Video:** (if applicable)

**Submit to:** GitHub Issues (https://github.com/[your-repo]/issues)

## Issue Priority Levels

- **Critical:** Game crashes, data loss, unplayable
- **Major:** Significant gameplay impact, broken features
- **Minor:** Visual glitches, minor UX issues
- **Trivial:** Polish, nice-to-have improvements

## Update Policy

- **Critical issues:** Hotfix within 1 week
- **Major issues:** Patch within 1 month
- **Minor issues:** Bundled in next feature update
- **Trivial issues:** Considered for future versions

## Disclaimer

This software is provided "as is" without warranty. See LICENSE for full terms.

The developer is not responsible for:
- Data loss due to user error
- Issues caused by modified game files
- Platform-specific OS bugs
- Third-party software conflicts

## Community Support

For help:
1. Check this document first
2. Review BUILD.md and SYSTEM_REQUIREMENTS.md
3. Search existing GitHub issues
4. Create new issue with full details

Thank you for your patience and understanding!

---

**Last Updated:** 2025-11-18
**Version:** 1.0.0
