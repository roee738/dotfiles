# Zen Browser Settings

## Initial Setup

1. Install Bitwarden and uBlock Origin extensions
2. Login to Bitwarden extension and set lock to 30 min timeout
3. Go to uBlock preferences and check:
   - EasyList cookie notices
   - EasyList annoyances

## General Settings

4. Uncheck "Open previous windows and tabs"
5. Uncheck "Ask before quitting"
6. Check "Delete files downloaded in private browsing"
7. Uncheck "Enable picture-in-picture"
8. Uncheck "Enable glance"

## Search Settings

9. Check "Show search suggestions"
10. Uncheck "Suggest bookmarks, clipboard, open tabs, and search engines to use"

## Privacy and Security

11. Uncheck "Ask to save passwords"
12. Uncheck "Save and autofill payment"
13. Uncheck "Save addresses"

## Zen Mods

14. Install the following mods:
    - Ghost Tabs
    - Private Mode Highlighting
    - Remove Tab X

## Spaces Setup

### Base Space
15. Retitle Space to "Base"
16. Change icon to water droplet
17. Set profile to Personal
18. Edit theme to orange-y gradient

### School Space
19. Create a new space called "School"
20. Change icon to graduation cap
21. Edit theme to blue-ish gradient

## Container Tabs

22. Access Container Tabs Settings
23. Remove "Banking" and "Shopping" containers
24. Rename "Work" to "School"
25. Change "School" container color to blue and icon to glasses
26. Change "Personal" container color to orange

## Tab Configuration

### Base Container
- **Essential tabs:**
  - Gmail (bouskilare)
  - Claude
  - ChatGPT
- **Pinned tabs:**
  - Gmail (roee738)
  - Google Maps
  - TD
  - Koodo
  - Telus
  - BC Hydro
  - Google Calendar
  - Weather Network
  - YouTube

### School Container
- **Essential tabs:**
  - Gmail (bouskilare)
  - ChatGPT
- **Pinned tabs:**
  - UVic
  - Brightspace
  - Outlook
  - GitHub

## Disable top bar expand on hover

27. Go to `about:config` and set `zen.view.experimental-no-window-controls` to `true`

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