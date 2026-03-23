# Application Integration - Critical Analysis

## Implementation/Backend critique

- [ ] Editing an application does not work — no PATCH/PUT API calls are made when editing fields (name, description, Application URL, etc.). Changes are lost on navigation. The edit functionality is non-functional. (P1)
- [ ] CORS access-control-allow-methods header only lists GET, POST — missing PUT/PATCH/DELETE which are needed for editing/deleting applications (P1)
- [ ] 54 duplicate themes in database — the same 6 themes are inserted 9 times with different UUIDs. GET /design/themes returns all 54. This is a data seeding/migration bug causing the UI to render ~50 duplicate theme cards (P1)
- [ ] Theme createdAt and updatedAt fields are empty strings instead of timestamps (P3)

## UX critique

- [ ] No Save/Update button on the application detail page — fields accept input but there is no way to persist changes. No auto-save, no dirty-state indicator, no "unsaved changes" warning (P1)
- [ ] Inline name edit gives false feedback — UI updates the name locally but doesn't persist it, misleading the user into thinking the change was saved (P1)
- [ ] "Type" column shows "-" for the Console app — the API does not return a type field for it; for React apps it shows "React" badge correctly (P2)
- [ ] Actions column is empty in the applications list — no edit/delete/view buttons visible in the list row (P2)
- [ ] Technology Stack step: the "OR" separator between Technology (React/Next.js) and Application Type (Browser App/Full-Stack/Mobile/Backend) is confusing — unclear if they are mutually exclusive or complementary selections (P2)
- [ ] UI pagination says "Rows per page: 10" but the API request uses limit=30 — inconsistency between displayed page size and actual fetch size (P3)

## UI critique

- [ ] Design step: Back/Continue buttons are buried below 54 duplicate theme cards, requiring extensive scrolling to proceed. Even with correct number of themes, page layout should ensure navigation buttons remain accessible (e.g., sticky footer or fixed position) (P1)
- [ ] No delete application functionality visible anywhere in the UI (P2)

## Other

- [ ] Stale 401 requests observed in background (from other tabs/sessions with expired tokens) — polling continues even after auth failure, causing unnecessary traffic (P3)
