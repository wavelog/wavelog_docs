# DX Waterfall  – Quick User Guide

<img width="1000" alt="screenshot" src="https://github.com/user-attachments/assets/92c2abae-0a45-4aba-967b-d6050b47d5e1" />

## Overview

DX Waterfall is a real-time visual display of DX cluster spots that helps you quickly identify and tune to interesting stations. It shows all available spots on a scrollable frequency spectrum with color-coded status indicators.

## Getting Started

### Preparation

If you like to use this feature, you need to enable it in the user settings: User Menu --> Account --> Wavelog Preferences --> QSO Logging Options (right column) --> DX Waterfall: Set to "Enabled"

<img width="292" height="160" alt="Enable the Waterfall in the user settings" src="https://github.com/user-attachments/assets/e20415be-6dcf-42fa-bc9b-6ba2e7756a64" />


### Enabling DX Waterfall

The DX Waterfall can only be used in the "Live QSO" screen.

1. Click anywhere in the black header bar to turn on the DX Waterfall
2. The waterfall canvas will appear showing current DX spots
3. Click the power icon (red when off, green when on) to toggle the display
4. Click the **?** icon to open the help documentation

<img width="969" height="422" alt="Screenshot that shows the black header bar" src="https://github.com/user-attachments/assets/b8ab431c-f4fd-4e45-9c05-06b02d918f10" />


### Understanding the Display

#### Color Coding
- **Gold**: New Continent
- **Silver**: New DXCC entity
- **Bronze**: New Callsign (never worked before)
- Labels:
  - Colors:
    - **Green**: Worked station
    - **Orange**: Worked, not confirmed
    - **Red**: Not worked
  - Elements:
    - Border: shown status of the continent (see colors above)
    - Fill color: shown status of the DXCC entity(see colors above)
    - Small square: shown status of the callsign (see colors above)

#### Information Display
The status bar shows:
- Current spot count (e.g., "62/62 20m NA spots")
- Active filters (continent, modes)
- Spot age timer

## Navigation

### Keyboard Shortcuts

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| Tune to spot & log QSO | `Ctrl+Shift+Space` | `Cmd+Shift+Space` |
| Cycle nearby spots | `Ctrl+Space` | `Cmd+Space` |
| Previous spot | `Ctrl+Left` | `Cmd+Left` |
| Next spot | `Ctrl+Right` | `Cmd+Right` |
| First spot | `Ctrl+Down` | `Cmd+Down` |
| Last spot | `Ctrl+Up` | `Cmd+Up` |
| Zoom in | `Ctrl++` | `Cmd++` |
| Zoom out | `Ctrl+-` | `Cmd+-` |

### Mouse Controls
- **Click on spot**: Tune radio to frequency and populate QSO form
- **Scroll wheel**: Navigate through frequency range
- **Click arrows**: Jump to previous/next spot
- **Click DX Hunter**: Cycle through unworked continents/DXCC

## Menu Bar Features

### Navigation Arrows
- **Left arrow**: Jump to previous spot
- **Right arrow**: Jump to next spot

### DX Hunter
Automatically cycles through unworked continents and DXCC entities on the current band. Click once to start cycling through new/unworked stations.

### Continent Filter
Click to cycle through spotter continents:
- **Any**: Show spots from all continents
- **AF**: Africa
- **AS**: Asia
- **EU**: Europe
- **NA**: North America
- **OC**: Oceania
- **SA**: South America

### Mode Filters
Toggle mode filters on/off:
- **Phone**: SSB, FM, AM voice modes
- **CW**: Morse code
- **Digi**: Digital modes (FT8, RTTY, PSK, etc.)

### Zoom Controls
- **Minus**: Zoom out (show wider frequency range)
- **Number**: Current zoom level - click to reset to default
- **Plus**: Zoom in (show narrower frequency range)

### Label Size
Cycle through text sizes: X-Small, Small, Medium, Large, X-Large

## Tips & Best Practices

1. **Use DX Hunter** to automatically find new entities and continents
2. **Filter by mode** to match your operating preferences
3. **Adjust zoom** based on band activity (zoom in on quiet bands, zoom out on busy bands)
4. **Watch for color indicators** to prioritize new entities
5. **Use keyboard shortcuts** for rapid navigation during contests or pileups
6. **Adjust label size** based on your screen resolution and personal preference

## Troubleshooting

- **No spots showing**: Check your DX cluster connection in Wavelog settings
- **Waterfall not updating**: Turn off and on again using the power icon
- **Radio not tuning**: Verify CAT control is properly configured
- **Spots appear out of band**: Check your station profile bandplan settings