# DX Cluster – Quick User Guide

<img width="600" alt="screenshot" src="https://github.com/user-attachments/assets/57a63cc2-35da-4320-8736-f2b3e065858e" />

## Contents
1. [Overview](#overview)
2. [Setup](#setup)
3. [Interface](#interface)
4. [Filters](#filters)
5. [Spots](#spots)
6. [CAT Control](#cat-control)
7. [Shortcuts](#shortcuts)
8. [Tips](#tips)
9. [FAQ](#faq)

---

## Overview
The **DX Cluster Bandmap** shows live DX spots from cluster networks and integrates with your radio via **CAT control**. It filters and highlights only the most relevant spots.

### Features
- Real-time DX spots  
- Smart filtering (band, mode, DXCC, worked, continent)  
- CAT tracking and click-to-tune  
- Visual badges for worked/confirmed, contests, and POTA/SOTA/IOTA/WWFF  
- Interactive map with propagation paths  
- One-click logging to QSO form  
- “My Favorites” quick filter  

---

## Setup

### 1. DX Cluster Connection (admin needed)
- Go to **Global Options → DXCluster**  
- “Provider of DXClusterCache”: Enter the suggested url (e.g. `https://dxc.wavelog.org/dxcache`) there, or - if you want to use your own DXCluster-Cache - you can download/install a copy from [here](https://github.com/int2001/DXClusterAPI)
- Adjust “Max age” 
- Set the “de” filter (only spots reported by stations on this continent are taken into account) and save  

<img width="961" height="538" alt="Config of DXCluster-Cache" src="https://github.com/user-attachments/assets/330c92a2-9b0f-4499-8b36-84b66c0262bd" />


### 2. (Optional) CAT Control
- Go to **Settings → Hardware Interfaces**  
- Add your radio and enable CAT connection  

---

## Interface

### Header
- **Help** → opens this wiki  
- **Fullscreen toggle**  

### Menu Rows
- **CAT Toggle / Radio Selector / de Continent**  
- **Advanced Filters / My Favorites / Clear / Band / Mode**  
- **Quick Filters / DX Map toggle**

### DX Map
Shows your location, DX stations, paths, day/night, zoom.  
Colors:
- **Green** – worked+confirmed  
- **Orange** – worked not confirmed  
- **Red** – new  

### Main Table
- Columns (auto-fit screen): DX, Freq, DXCC, Mode, de, Time, Comment  
- Purple marker (when CAT enabled): marks your current position at the band
- Spot colors: 
  - green - added less than a minute ago
  - red - will be gone at next data fetch (within a minute)
  - blue - row highlighted by the mouse pointer

---

## Filters

Click **Advanced Filters** for details.

**Worked Status**
- Not Worked / Worked / Confirmed / Worked not Confirmed  

**Extras**
- LoTW users only  
- Contest only  
... and more!

Use **Apply** or **Clear** buttons.

---

## Spots

### Logging
- **Click** → open QSO form (auto-filled)  
- **Ctrl/Cmd + Click** → tune radio via CAT  

---

## CAT Control

- **Auto Band Tracking:** follows your radio band  
- **Click-to-Tune:** Ctrl/Cmd + click frequency  
- **Toast message** confirms action  

---

## Shortcuts

| Action | Keys |
|--------|------|
| Tune radio | Ctrl/Cmd + Click |
| Multi-select filters | Ctrl/Cmd + Click |
| Close popup | Esc |
| Toggle fullscreen | F11 |
| My Favorites | Click “My Favorites” |
| Clear filters | Click “Clear Filters” |

---

## Tips

**Performance**
- Use few active bands/modes  
- Enable CAT only when needed  
- Adjust “Max Age” in settings  

**Contest Use**
- Use “Contest Only” filter  
- Sort by frequency  

**Award Hunting**
- “New Countries” + “Not Worked” filters  
- Medal colors show new entities  

**Refresh**
- Auto-refreshes; “Last fetched” shown  
- Manual: reload page  

**Text search**
- You can easily filter the Spots by typing in search-terms a the searchfield on top of the cluster. There's even an enhanced syntax available. E.g.: Type in `!POTA` and you won't see POTA Spots. You can also combine terms like `!FT8 Italy` -> Shows all Spots with DXCC Italy, but no FT8-Spots and so on.

**Checking history**
- Click on the DXCC-Column, and you'll see where you've already worked the DXCC and where it may be missing. Same goes with CQ zone and continent columns.

---

## FAQ

**No spots?**  
→ Check DXCluster settings, filters, and server status.  

**CAT required?**  
→ No, works manually too.  

**Band keeps changing?**  
→ Disable CAT tracking toggle.  

**Map missing?**  
→ Enable JavaScript, set gridsquare, disable ad-blocker, refresh.  

**Report issues:**  
→ [GitHub Issues](https://github.com/wavelog/wavelog/issues)  

**More help:**  
- [Radio Interface Guide](https://github.com/wavelog/wavelog/wiki/Radio-Interface)  
