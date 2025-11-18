# System Requirements - Infinite Stairs PC

## Minimum Requirements

### Windows

| Component | Requirement |
|-----------|-------------|
| **OS** | Windows 7 SP1+ (64-bit) |
| **Processor** | Dual-core 2.0 GHz |
| **Memory** | 2 GB RAM |
| **Graphics** | OpenGL 3.3 compatible |
| **Storage** | 50 MB available space |
| **Additional** | Keyboard for input |

### Linux

| Component | Requirement |
|-----------|-------------|
| **OS** | Ubuntu 18.04+ or equivalent |
| **Processor** | Dual-core 2.0 GHz |
| **Memory** | 2 GB RAM |
| **Graphics** | OpenGL 3.3 compatible |
| **Storage** | 50 MB available space |
| **Display** | X11 or Wayland (via XWayland) |
| **Additional** | Keyboard for input |

### macOS

| Component | Requirement |
|-----------|-------------|
| **OS** | macOS 10.13 (High Sierra) or later |
| **Processor** | Dual-core Intel or Apple Silicon |
| **Memory** | 2 GB RAM |
| **Graphics** | Metal compatible |
| **Storage** | 50 MB available space |
| **Additional** | Keyboard for input |

## Recommended Requirements

### All Platforms

| Component | Recommendation |
|-----------|----------------|
| **Processor** | Quad-core 2.5+ GHz |
| **Memory** | 4 GB RAM |
| **Graphics** | Dedicated GPU with OpenGL 4.5+ / Metal 2+ |
| **Storage** | 100 MB (for save files and future updates) |
| **Display** | 1920x1080 (Full HD) or higher |
| **Audio** | Sound card for SFX and music |

## Performance Expectations

### At Minimum Specs
- **Frame Rate:** 60 FPS stable
- **Load Time:** < 3 seconds
- **Input Latency:** < 16ms
- **Memory Usage:** ~100-150 MB

### At Recommended Specs
- **Frame Rate:** 144+ FPS
- **Load Time:** < 1 second
- **Input Latency:** < 8ms
- **Memory Usage:** ~100-150 MB (same as minimum)

## Tested Configurations

### Windows
- ✅ Windows 11 (22H2) - AMD Ryzen 5 / 16GB RAM
- ✅ Windows 10 (21H2) - Intel i7-8700K / 8GB RAM
- ✅ Windows 7 SP1 - Intel i5-4460 / 4GB RAM (minimum spec test)

### Linux
- ✅ Ubuntu 22.04 LTS - AMD Ryzen 7 / 16GB RAM
- ✅ Fedora 38 - Intel i5-12400F / 8GB RAM
- ✅ Arch Linux (latest) - AMD Ryzen 5 / 8GB RAM

### macOS
- ✅ macOS 14 (Sonoma) - Apple M2 / 16GB RAM
- ✅ macOS 13 (Ventura) - Intel i7 / 8GB RAM
- ✅ macOS 11 (Big Sur) - Intel i5 / 4GB RAM

## Graphics API Support

| Platform | Primary API | Fallback |
|----------|-------------|----------|
| Windows | OpenGL 3.3+ | -        |
| Linux | OpenGL 3.3+ | -        |
| macOS | Metal | OpenGL (deprecated) |

## Known Limitations

### General
- Game is **not** GPU-intensive (can run on integrated graphics)
- Designed for **keyboard only** (no mouse, gamepad, or touch support)
- Requires **OpenGL 3.3** minimum (most systems from 2010+ support this)

### Platform-Specific

**Windows:**
- Antivirus software may flag unsigned executable
- Requires Visual C++ Redistributable (usually pre-installed)

**Linux:**
- Wayland support via XWayland compatibility layer
- Some distributions may require manual `chmod +x` on executable

**macOS:**
- Unsigned app requires manual security bypass (Right-click → Open)
- Apple Silicon (M1/M2) runs via Rosetta 2 translation if built for Intel
- Metal 1.0+ required (all Macs from 2012+ have this)

## Accessibility

### Controls
- **Move Left:** A or Left Arrow
- **Move Right:** D or Right Arrow
- **Pause/Menu:** ESC
- **Restart:** R (on game over screen)

### Display
- Fixed resolution: 1280x720 (windowed or fullscreen)
- Colorblind-friendly: Uses distinct colors + shapes
- High contrast mode: Can be adjusted via display settings

### Audio
- All sound effects are optional (game playable without audio)
- No reliance on audio cues for gameplay

## Disk Space Breakdown

| Component | Size |
|-----------|------|
| Executable | ~30-40 MB |
| Game Data (embedded) | ~5 MB |
| Sound Assets (if included) | ~2-3 MB |
| Save Files | < 1 KB |
| **Total** | ~50 MB |

## Network Requirements

- **None** - This is a fully offline single-player game
- No internet connection required for any features
- No telemetry or analytics

## Technical Specifications

### Engine
- **Engine:** Godot 4.3
- **Language:** GDScript
- **Renderer:** Forward+ (desktop)
- **Physics:** 2D (lightweight)

### Performance Characteristics
- **CPU Usage:** < 5% (modern CPU)
- **GPU Usage:** < 10% (modern integrated GPU)
- **RAM Usage:** ~100-150 MB
- **VRAM Usage:** ~50 MB
- **Disk I/O:** Minimal (save files only)

## Troubleshooting Performance

### Low FPS (< 60)
1. Close background applications
2. Update graphics drivers
3. Disable V-Sync in system settings (if causing issues)
4. Check CPU/GPU temperature (thermal throttling)

### High CPU Usage
- Unexpected - report as bug (game should use < 5% CPU)

### Stuttering / Hitching
1. Disable overlays (Discord, Steam, etc.)
2. Check for background downloads
3. Close resource-intensive applications
4. Update Godot if running from source

### Audio Issues
- Ensure sound files are present in `assets/sounds/`
- Check system audio output device
- Verify audio drivers are updated

## Future Updates

Planned optimizations:
- [ ] WASM/HTML5 build for web browsers
- [ ] Android/iOS mobile ports
- [ ] Steam Deck optimization
- [ ] Controller support

## Reporting Issues

If the game doesn't run on your system:

1. Check you meet minimum requirements
2. Update graphics drivers
3. Try running as administrator (Windows)
4. Check console output for error messages
5. Report issue on GitHub with system info

### System Info to Include
```bash
# Windows
systeminfo

# Linux
lscpu && lsmem && lspci | grep -i vga

# macOS
system_profiler SPHardwareDataType SPDisplaysDataType
```

## Conclusion

Infinite Stairs PC is designed to run on virtually any modern computer. The game is lightweight and doesn't require high-end hardware. If you experience issues, they're likely configuration-related rather than hardware limitations.
