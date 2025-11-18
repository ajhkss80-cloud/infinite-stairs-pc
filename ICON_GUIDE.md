# Icon and Assets Guide

## Game Icon Requirements

### Primary Icon: `icon.png`

**Location:** `/icon.png` (project root)

**Specifications:**
- **Size:** 512x512 pixels minimum (recommended: 1024x1024 for best quality)
- **Format:** PNG with transparency
- **Content:** Simple, recognizable stair/ladder design
- **Color Scheme:** Match game theme (green/blue stairs)

**Design Recommendations:**
- Use clear, bold shapes (visible at small sizes)
- Include 2-3 stairs in geometric pattern
- Add slight gradient or shadow for depth
- Keep it simple and iconic

### Platform-Specific Icons

Icons will be automatically resized by Godot export system:
- **Windows:** 256x256, 128x128, 64x64, 48x48, 32x32, 16x16
- **Linux:** 512x512, 256x256, 128x128
- **macOS:** 1024x1024, 512x512, 256x256, 128x128

### Creating the Icon

**Option 1: Use GIMP (Free)**
```bash
# Create 512x512 canvas with transparent background
# Draw stair pattern using geometric shapes
# Export as icon.png
```

**Option 2: Use Inkscape (Free, Vector)**
```bash
# Create 512x512 document
# Use vector shapes for stairs
# Export as PNG at 512x512 or higher
```

**Option 3: Online Tools**
- [Canva](https://www.canva.com/) - Free tier available
- [Pixlr](https://pixlr.com/) - Free online editor
- [Photopea](https://www.photopea.com/) - Free Photoshop alternative

### Quick Placeholder Icon

For testing, create a simple geometric icon:

1. Create 512x512 PNG
2. Draw 3-4 horizontal rectangles (stairs) in green/blue
3. Offset each stair to create climbing effect
4. Add white/light outline for visibility

### Splash Screen (Optional)

**Location:** `splash.png` (if needed)

**Specifications:**
- **Size:** 1920x1080 (Full HD) or 3840x2160 (4K)
- **Format:** PNG
- **Content:** Game title + subtitle + version
- **Duration:** 2-3 seconds (configured in project settings)

## Current Status

⚠️ **No icon file included in repository**

To build the game, you must add `icon.png` to the project root.

The export presets are configured to use `res://icon.png`.

## Testing Icons

After creating your icon:

1. Place `icon.png` in project root
2. Open Godot Editor
3. Check Project → Project Settings → Application → Config → Icon
4. Run the game and check taskbar/dock icon
5. Export a build and verify icon appears in file explorer

## References

- [Godot Icon Documentation](https://docs.godotengine.org/en/stable/tutorials/export/changing_application_icon_for_windows.html)
- [Icon Design Best Practices](https://developer.apple.com/design/human-interface-guidelines/app-icons)
