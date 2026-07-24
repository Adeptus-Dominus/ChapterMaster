# Audio Modding Guide

## Overview

- You can add your own music and sound effects (SFX) to Chapter Master.
- The game supports **.ogg** files only.
- Newly added files are **lazy-loaded** on the next play, you don't need to relaunch the game.

## Where To Put Files

There are two places where audio files live:

1. **Shipped** (inside the game's install folder)
2. **User** (your personal override folder)

**User files always override shipped files** if they share the same name. This means you never need to modify the game's installation.

```
AppData/Local/ChapterMaster/Custom Files/Audio/
    Music/
        menu/
        sector/
        battle/
        creation/
        defeat/
        diplomacy/
        postbattle/
    SFX/
```

> If a folder doesn't exist, just create it. The game will read it automatically.

## Music

- Music is organized by **context** (what is happening in the game).
- Each context is a folder.
- Any `.ogg` file you put in that folder becomes part of that context's playlist.
- The game picks a random track from the folder and avoids playing the same track twice in a row.

### Context Folders

| Context | Folder Name | When It Plays |
|---|---|---|
| Menu | `menu/` | Main Menu |
| Sector | `sector/` | Star Map |
| Battle | `battle/` | Combat |
| Creation | `creation/` | Chapter Creation |
| Defeat | `defeat/` | Defeat |
| Diplomacy | `diplomacy/` | Diplomacy Events |
| Post-Battle | `postbattle/` | After Combat Results |

### Example

To add your own battle music:
1. Go to your **User** folder: `<AppData>/Local/ChapterMaster/Custom Files/Audio/Music/battle/`
2. Drop `.ogg` files in there (e.g. `my_battle_track.ogg`, `epic_fight.ogg`)
3. Next time you enter combat, the game will randomly pick from your tracks

### Built-in Music

- The game comes with built-in tracks.
- They play only when no external `.ogg` files exist in a context folder.
- You don't need to worry about them, just adding your own files automatically replaces them.

## Sound Effects (SFX)

SFX files go into the `SFX/` folder (not inside a context subfolder).

### Overridable SFX Names

Place a file named exactly like one of these in `SFX/` to replace that sound:

| Name | Plays When... |
|---|---|
| `click` | Button click |
| `click_small` | Small button click (???) |
| `error` | Error (duh) |
| `buzz` | Buzzing on the creation screen |
| `end_turn` | Ending your turn |
| `identify` | Identifying an artifact |
| `stc` | Identifying an STC fragment |

### Example

To replace the click sound:

1. Create an `.ogg` file named `click.ogg`
2. Put it in `<AppData>/Local/ChapterMaster/Custom Files/Audio/SFX/`
3. The game will now use your file instead of the built-in one

## File Priority (How The Game Decides Which File To Play)

1. User folder (already cached from a previous play)
2. User folder (loads fresh from disk)
3. Shipped folder
4. Built-in asset (compiled into the game)

The game checks these in order and plays the first one it finds. This means:
- Put your custom files in the **User folder** to override everything
- Add new names (not just override existing ones) to expand playlists

## Quick Start Checklist

1. Find your user audio folder: `<AppData>/Local/ChapterMaster/Custom Files/Audio/`
2. Pick SFX or Music, and the context: `Music/battle/` (or whatever)
3. Convert your audio to **.ogg** format
4. Drop the `.ogg` files in the correct folder
5. Launch the game, your audio will play automatically

That's it. No config files, no mod loader, no editing game files.
