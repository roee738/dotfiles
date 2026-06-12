# Zen Browser Settings

## Initial Setup

1. Install Bitwarden and uBlock Origin extensions
2. Login to Bitwarden extension and set lock to 30 min timeout
3. Go to uBlock preferences and check:
   - EasyList cookie notices
   - EasyList annoyances

## General Settings

1. Uncheck "Open previous windows and tabs"
2. Check "Ctrl+Tab cycles"
3. Uncheck "Ask before quitting"
4. Check "Delete files downloaded in private browsing"
5. Uncheck "Enable picture-in-picture"

## Look and Feel
1. Uncheck "Show New Tab Button"
2. Uncheck "Enable glance"
3. Zen URL Bar "Floating only when typing"

## Tab Management
1. Check "Restore pinned tabs to their original..."

## Zen Mods

1. Install the following mods:
    - Ghost Tabs
    - Private Mode Highlighting
    - Remove Tab X
    - Zen Context Menu
      - Within Zen Context Menu settings, check everything except *Restore back all icons, Hide all icons, Apple zen workspace gradient, Apply zen accent color, Hide search web, Hide search in private window, Hide translate, and Hide pin tab.* In macOS, also uncheck the very top selection in order to enable the mod.

## Search

1. Check "Show search suggestions"
2. Uncheck "Suggest bookmarks, clipboard, open tabs, and search engines to use"

## Privacy & Security

1. Uncheck "Ask to save passwords"
2. Uncheck "Save and autofill payment"
3. Uncheck "Save addresses"

## Spaces Setup

### Base Space
1. Retitle Space to "Base"
2. Change icon to water droplet
3. Set profile to Personal
4. Edit theme to black gradient with halfway dialed granular effect

### School Space
1. Create a new space called "School"
2. Change icon to graduation cap
3. Edit theme to blue-ish gradient

## Container Tabs

1. Access Container Tabs Settings
2. Remove "Banking" and "Shopping" containers
3. Rename "Work" to "School"
4. Change "School" container color to blue and icon to glasses
5. Change "Personal" container color to orange

## Tab Configuration

### Base Container
- **Essential tabs:**
  - Gmail (roee738)
  - Claude
  - ChatGPT
  - YouTube
  - GitHub
  - Google Maps
  - TD
  - Google Calendar
  - Koodo
  - Wealthsimple
  - Telus
  - Gmail bouskilare
- **Pinned tabs:**
  - Weather
  - BC Hydro

### School Container
- **Essential tabs:**
  - Gmail (bouskilare)
  - Claude
  - ChatGPT
  - GitHub
  - UVic
  - Brightspace
  - Outlook

## Additional settings

1. Go to `about:config` and set `zen.view.experimental-no-window-controls` to `true`
2. Set `zen.theme.content-element-separation = 0`

## macOS Only: Hide Titlebar Buttons

### 1. Enable Custom CSS
1. Type `about:config` in the address bar
2. Click "Accept the Risk and Continue"
3. Search for `toolkit.legacyUserProfileCustomizations.stylesheets`
4. Toggle it to `true`

### 2. Locate Profile Folder
1. Type `about:support` in the address bar
2. Find "Profile Folder" or "Profile Directory"
3. Click "Open Folder" or "Show in Finder"

### 3. Create Chrome Folder
1. In your profile folder, create a folder named `chrome` (lowercase)
2. If it already exists, open it

### 4. Create userChrome.css
Inside the `chrome` folder, create `userChrome.css` and add:
```css
/* Hide macOS titlebar buttons in Zen Browser */
.titlebar-buttonbox-container {
  display: none !important;
}
```

### 5. Restart Zen Browser
