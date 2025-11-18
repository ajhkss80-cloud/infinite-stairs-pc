# Sound Assets for Infinite Stairs PC

This directory contains game audio files (SFX and BGM).

## Required Sound Files

### SFX (Sound Effects) - `sfx/`
Place the following `.ogg` files in the `sfx/` directory:

- `correct_step.ogg` - Played when player climbs a stair correctly
- `wrong_step.ogg` - Played when player makes a wrong input (game over)
- `game_over.ogg` - Played when time runs out
- `combo_bonus.ogg` - Played when achieving combo milestones (every 10 consecutive successes)

### BGM (Background Music) - `bgm/`
Place the following `.ogg` files in the `bgm/` directory:

- `theme_music.ogg` - Main gameplay background music (loops)

## Audio Format

- **Format**: OGG Vorbis (`.ogg`)
- **Sample Rate**: 44100 Hz recommended
- **Channels**: Mono or Stereo
- **Bit Depth**: 16-bit recommended

## Recommended Audio Sources

For placeholder/free audio:
- [Freesound.org](https://freesound.org/)
- [OpenGameArt.org](https://opengameart.org/)
- [Zapsplat.com](https://www.zapsplat.com/)

## Godot Import Settings

After adding `.ogg` files, Godot will automatically create `.import` files.
For BGM files, ensure "Loop" is enabled in the import settings.

## Current Status

⚠️ **Sound files are not included in the repository.**
The game will run without sounds, but for full experience, add the audio files as specified above.

SoundManager is implemented and will automatically load sounds when files are present at the specified paths.
