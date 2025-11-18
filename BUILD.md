# Build Guide - Infinite Stairs PC

Complete guide for building and distributing Infinite Stairs PC across multiple platforms.

## Prerequisites

### Required Software

1. **Godot Engine 4.3+**
   - Download: https://godotengine.org/download
   - Use the standard version (not .NET)

2. **Export Templates**
   - Install from Godot Editor: Editor → Manage Export Templates → Download and Install

3. **Platform-Specific Tools** (for distribution)
   - **Windows:** No additional tools needed
   - **Linux:** No additional tools needed
   - **macOS:** Xcode Command Line Tools (for code signing, optional)

### Recommended Tools

- **Git** - Version control
- **7-Zip / WinRAR** - Creating distribution archives
- **GIMP / Inkscape** - Creating game icon (see ICON_GUIDE.md)

## Pre-Build Checklist

- [ ] Game icon (`icon.png`) is in project root (512x512 or larger)
- [ ] All tests passing (164 tests)
- [ ] Sound assets added (see `assets/sounds/README.md`)
- [ ] Version number updated in export presets
- [ ] CHANGELOG.md updated with release notes

## Building from Godot Editor

### Method 1: GUI Export (Recommended for First Build)

1. Open project in Godot Editor
2. Go to **Project → Export**
3. You should see 3 presets:
   - Windows Desktop
   - Linux/X11
   - macOS

4. For each platform:
   - Select the preset
   - Click **Export Project**
   - Choose output location (builds folder is pre-configured)
   - Click **Save**

5. Builds will be created in:
   - `builds/windows/InfiniteStairs.exe`
   - `builds/linux/InfiniteStairs.x86_64`
   - `builds/macos/InfiniteStairs.zip`

### Method 2: Command Line Export

```bash
# Export all platforms
godot --headless --export-release "Windows Desktop" builds/windows/InfiniteStairs.exe
godot --headless --export-release "Linux/X11" builds/linux/InfiniteStairs.x86_64
godot --headless --export-release "macOS" builds/macos/InfiniteStairs.zip
```

**Note:** Command line export requires export templates to be installed first.

## Using the Build Script

A convenience script is provided for automated builds:

```bash
# Make script executable (Linux/macOS)
chmod +x build.sh

# Run build for all platforms
./build.sh

# Run build for specific platform
./build.sh windows
./build.sh linux
./build.sh macos
```

Windows users can use `build.bat`:
```cmd
build.bat
build.bat windows
```

## Post-Build Steps

### 1. Test the Build

**Windows:**
```cmd
cd builds\windows
InfiniteStairs.exe
```

**Linux:**
```bash
cd builds/linux
chmod +x InfiniteStairs.x86_64
./InfiniteStairs.x86_64
```

**macOS:**
```bash
cd builds/macos
unzip InfiniteStairs.zip
open InfiniteStairs.app
```

### 2. Create Distribution Archives

**Windows:**
```bash
cd builds/windows
7z a InfiniteStairs-Windows-v1.0.0.zip InfiniteStairs.exe
```

**Linux:**
```bash
cd builds/linux
tar -czf InfiniteStairs-Linux-v1.0.0.tar.gz InfiniteStairs.x86_64
```

**macOS:**
```bash
# macOS build is already zipped
cd builds/macos
mv InfiniteStairs.zip InfiniteStairs-macOS-v1.0.0.zip
```

### 3. Verify Build Integrity

- [ ] Game launches without errors
- [ ] All 3 difficulty levels work
- [ ] Sound effects play (if assets provided)
- [ ] High scores save and load
- [ ] Obstacles appear and function correctly
- [ ] Game over screen displays correctly
- [ ] Controls respond (keyboard: A/D or Arrow keys)

## Distribution

### File Structure

Your release should include:

```
InfiniteStairs-v1.0.0/
├── InfiniteStairs.exe (or .x86_64 / .app)
├── README.md
├── LICENSE
└── CHANGELOG.md
```

### Platform-Specific Notes

**Windows:**
- Executable is standalone
- No dependencies required
- Antivirus may flag unsigned executable (expected)

**Linux:**
- May need to mark as executable: `chmod +x InfiniteStairs.x86_64`
- Tested on Ubuntu 20.04+, should work on most distros
- Requires X11 (Wayland works through XWayland)

**macOS:**
- Delivered as .app bundle in .zip
- Unsigned apps need: Right-click → Open (first time only)
- Code signing requires Apple Developer account ($99/year)

## Troubleshooting

### "Export template not found"
- Go to Editor → Manage Export Templates
- Click "Download and Install"
- Wait for download to complete
- Restart Godot Editor

### Icon not showing
- Ensure `icon.png` exists in project root
- Size must be at least 256x256 (512x512 recommended)
- PNG format with transparency

### Build crashes immediately
- Check console output for errors
- Verify all dependencies in export preset
- Ensure Godot version matches project (4.3+)

### Missing game data
- Check export preset filter settings
- Ensure "Export all resources" is enabled
- Verify critical files aren't excluded

## CI/CD Integration (Advanced)

For automated builds via GitHub Actions:

```yaml
# .github/workflows/build.yml
name: Build Game
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: chickensoft-games/setup-godot@v1
        with:
          version: 4.3
      - run: godot --headless --export-release "Windows Desktop" builds/windows/InfiniteStairs.exe
```

## Version Management

Update version numbers in:
1. `export_presets.cfg` - All platform presets
2. `CHANGELOG.md` - Release notes
3. Git tag - `git tag v1.0.0`

## Release Checklist

- [ ] All tests passing
- [ ] Version numbers updated
- [ ] CHANGELOG.md updated
- [ ] Builds created for all platforms
- [ ] Builds tested on each platform
- [ ] Distribution archives created
- [ ] README.md updated
- [ ] Git tag created
- [ ] GitHub Release created with binaries
- [ ] Itch.io / Steam page updated (if applicable)

## Next Steps

After successful build:
1. Create GitHub Release with build artifacts
2. Upload to itch.io or other distribution platforms
3. Announce release
4. Gather player feedback
5. Plan next update

## Support

For build issues:
- Check Godot export documentation: https://docs.godotengine.org/en/stable/tutorials/export/
- Open an issue on GitHub repository
- Review error logs in Godot console
