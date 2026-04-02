# Swifty Companion - Test Plan

## Platforms
- **Web (Firefox)**: `flutter run -d chrome` with `CHROME_EXECUTABLE=/usr/bin/firefox`
- **Android Emulator**: `flutter run -d emulator-5554` (AVD: swifty_emu, API 35)

## Test Cases

### T1 — App launches without crash
- [ ] Web: app loads, search page visible
- [ ] Android: app loads, search page visible

### T2 — Search with valid login
- [ ] Type "norminet" → profile page appears with photo, name, level, skills, projects
- [ ] Verify at least 4 user details shown (login, email, location/wallet, level)
- [ ] Verify profile picture loads
- [ ] Verify skills section with bars and percentages
- [ ] Verify projects section with pass/fail marks

### T3 — Search with invalid login
- [ ] Type "zzzzzzznotauser999" → red snackbar "User not found"
- [ ] App does not crash, stays on search page

### T4 — Empty search
- [ ] Submit with empty field → snackbar "Please enter a login"

### T5 — Network error handling
- [ ] (Android) Enable airplane mode → search → "Connection error" message
- [ ] (Web) Disconnect network → search → error handled gracefully

### T6 — Back navigation
- [ ] From profile page, press back → returns to search page
- [ ] Search field retains previous value

### T7 — Responsive layout
- [ ] (Web) Resize browser window: layout adapts, no overflow
- [ ] (Android) Rotate device: layout adjusts

### T8 — Token reuse (no token per query)
- [ ] Search two different logins in a row → both succeed (single token reused)
- [ ] Check logs: only 1 token request, not 2

### T9 — Token refresh (bonus)
- [ ] After token expires (or force expiry in code) → next search auto-refreshes token
- [ ] No user-visible error during refresh

### T10 — Special characters in search
- [ ] Type login with spaces or symbols → handled gracefully (error or trimmed)

### T11 — .env security
- [ ] `git status` shows .env is NOT tracked
- [ ] No credentials in any committed file
