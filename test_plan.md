# Swifty Companion — Test Plan

## Environment

| Platform | Command | Notes |
|---|---|---|
| Web (Firefox) | `CHROME_EXECUTABLE=/usr/bin/firefox flutter run -d web-server --web-port=8080` | Open http://localhost:8080 in Firefox |
| Android Emulator | `flutter run -d emulator-5554` | AVD: swifty_emu, Android 15 (API 35), x86_64 |

**Start emulator:**
```
$ANDROID_HOME/emulator/emulator -avd swifty_emu -no-window -no-audio -gpu swiftshader_indirect &
```

---

## Results

### T1 — App launches without crash
- [x] Web: search page loads in Firefox, dark background, input field visible
- [x] Android: app installs and launches, search page renders in 2.2s

### T2 — Search with valid login (rluiz)
- [x] Profile page loads: photo, display name, login
- [x] 4+ details shown: email, location (c1r7p11), wallet (945), eval points (1), level (14.85)
- [x] Profile picture loads from CDN
- [x] Skills rendered with name, level, percentage bar (Unix 14.6 / 69%, Rigor 11.3 / 54%…)
- [x] Projects listed with green dot = pass (100+), red dot = fail (matcha: 0)

### T3 — Search with invalid login
- [x] "zzznotreal9999" → red snackbar: `User "zzznotreal9999" not found`
- [x] App stays on search page, no crash

### T4 — Empty search
- [x] Submit with empty field → red snackbar: `Please enter a login`

### T5 — Network error (airplane mode)
- [x] App shows `Connection error. Check your network.` snackbar
- [x] App stays on search page, no crash
- [x] Token cached before disconnect: no double auth attempt

### T6 — Back navigation
- [x] Back button (←) from profile → returns to search page
- [x] Search field retains previous login text

### T7 — Responsive layout
- [x] Android: SliverAppBar collapses on scroll, cards fill width
- [x] Web: single-column layout scales with window resize, no overflow errors

### T8 — Token reuse (no token per query)
- [x] Two consecutive searches succeed without re-authenticating
- [x] `_ensureToken()` reuses cached token when `_tokenExpiry` not reached

### T9 — Token refresh (bonus)
- [x] `_tokenExpiry` set to `expires_in - 60s` to pre-emptively refresh
- [x] If token is expired or null, `_authenticate()` is called before any API request
- [x] On 401 response: token cleared and one automatic retry performed

### T10 — Special characters in search
- [x] Input is `.trim().toLowerCase()` before sending — leading/trailing spaces stripped
- [x] Symbols/spaces that aren't valid logins get a 404 → "User not found" snackbar

### T11 — Credentials security
- [x] `git ls-files` does NOT list `.env`
- [x] `.gitignore` explicitly ignores `.env`
- [x] No credentials hardcoded in any `.dart` file

---

## Known Limitations

- **Web CORS**: The 42 API does not send CORS headers, so web builds cannot call the API directly from the browser. The app works on Android (native HTTP) and Linux desktop. For web demo, a proxy would be needed.
- **T5 snackbar timing**: The `Connection error` snackbar auto-dismisses in ~4s; must screenshot within that window to capture it visually.
- **norminet skills**: norminet has level 0 / no cursus skills — normal, not a display bug.
