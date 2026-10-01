# VLC Dark Theme for Windows

A dark theme for **VLC media player 3.0.x on Windows** that keeps **every feature**, and a fix for tiny controls on **4K / HiDPI** screens.

This is **not a skin**. VLC skins (`.vlt`) replace the interface with a simpler one and drop features. This project switches on VLC's own hidden dark palette on the standard interface. You keep every menu, the playlist, Effects & Filters, the equalizer, subtitle tools, Convert/Stream, Preferences and all keyboard shortcuts.

## Features
- 🌙 **Dark interface** that uses VLC's built-in `qt-dark-palette`
- 🎨 **Fusion style**, so the dark colours apply to every dialog and widget, not just some
- 🖥️ **HiDPI scaling**, so controls, the seek bar and buttons are the right size on 4K at 150% or more
- ↩️ **Revert with one command**, and your original config is backed up automatically
- ✅ **No feature loss**: it is the standard VLC interface, recoloured

## Requirements
- Windows 10 or 11
- VLC 3.0.x (tested on **3.0.24**). The dark palette option is not in older 3.0 builds.

## Install
1. **Close VLC** completely.
2. Clone or download this repo.
3. Run:
   ```powershell
   powershell -ExecutionPolicy Bypass -File apply.ps1
   ```
4. Start VLC again. If the controls still look small, **sign out and back in** once so the scaling variable reaches Explorer.

### Make the UI bigger still
```powershell
powershell -ExecutionPolicy Bypass -File apply.ps1 -Scale 1.25
```
`-Scale` multiplies on top of Windows display scaling, so `1.25` means 25% larger.

## Uninstall
```powershell
powershell -ExecutionPolicy Bypass -File revert.ps1
```
This restores the light theme and removes the scaling variables. A copy of each original config file is also saved in `backups/`, a local folder that git ignores.

## Manual setup (no scripts)
1. In VLC, open **Tools → Preferences → Interface**.
2. Set **Style** to **Fusion**.
3. Tick **Use a dark palette**.
4. Click **Save** and restart VLC.
5. For 4K scaling, add the user environment variable `QT_AUTO_SCREEN_SCALE_FACTOR=1` (Start → "Edit environment variables for your account"), then sign out and back in.

## How it works
| Setting | Where | What it does |
|---|---|---|
| `qt-dark-palette=1` | `%APPDATA%\vlc\vlcrc` | Turns on VLC's built-in dark palette |
| `QtStyle=Fusion` (`[MainWindow]`) | `%APPDATA%\vlc\vlc-qt-interface.ini` | Uses the Qt Fusion style, which fully respects the palette |
| `QT_AUTO_SCREEN_SCALE_FACTOR=1` | User environment variable | Makes Qt scale the UI by the monitor's DPI |
| `QT_SCALE_FACTOR` (optional) | User environment variable | Extra size multiplier from `-Scale` |

## Troubleshooting
- **Theme reset after running the script:** VLC was still open and wrote its old settings back when it closed. Close VLC (check the system tray too) and run `apply.ps1` again.
- **Still tiny on 4K:** sign out and back in, or restart, so new programs see the environment variable.
- **Other Qt apps look larger too:** `QT_AUTO_SCREEN_SCALE_FACTOR` applies to every Qt 5 app for your user. That is normally an improvement on HiDPI screens. Run `revert.ps1` if you don't want it.

## License
MIT
