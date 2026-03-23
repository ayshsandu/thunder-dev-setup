# Edit an application

## UI Actions Done

1. From Applications list, clicked "Test SPA App" to open its detail page
2. Clicked edit (pencil) icon next to app name "Test SPA App"
3. Name field became an inline text input with current value
4. Changed name to "My Updated SPA", pressed Enter
5. UI updated to show "My Updated SPA" — appeared to save
6. Navigated back to Applications list
7. Applications list still shows original name "Test SPA App" — name change was NOT persisted
8. Re-entered app detail page, clicked General tab
9. Scrolled to Access section
10. Entered "https://myapp.example.com" in Application URL field
11. Clicked away (blur) — no save button appeared, no API call made
12. Checked net-dump: only GET requests, no PATCH/PUT/POST for updates

## Observations

### Inline name editing
- Edit icon (pencil) next to app name converts it to a text input on click
- User can type a new name and press Enter
- UI updates the displayed name immediately (optimistic update)
- **No API call is made** — the change is purely cosmetic/local and lost on navigation
- Same edit icon exists next to "No description" text

### General tab content
- Quick Copy section: Application ID and Client ID (read-only, with copy buttons)
- Access section:
  - Allowed User Types: chip-based selector with "Customer" pre-selected, dropdown to add more
  - Application URL: editable text input (placeholder: https://example.com)
  - Authorized redirect URIs: shows "http://localhost:5173" with delete icon and "+ Add URI" button

### Missing save mechanism
- **No Save/Update button exists** on the General tab or anywhere on the detail page
- Fields accept input but changes are never persisted
- No auto-save functionality observed
- No dirty-state indicator (no "unsaved changes" warning)
- No PATCH/PUT API calls observed in net-dump after editing any field

### API behavior
- GET /applications/{id} returns the full application object correctly
- No update endpoint was called during editing attempts
- CORS headers only allow GET, POST methods — PATCH/PUT may not even be configured on the backend
