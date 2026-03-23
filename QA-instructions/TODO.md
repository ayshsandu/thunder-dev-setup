# Test Setup Limitations & TODOs

## Limitations encountered during testing

- The proxy wire-dump does not capture request method in the filename for all HTTP methods — only GET, POST, OPTIONS were seen. PATCH/PUT/DELETE filenames would need to be verified once those methods are actually called.
- Stale tabs (Gate sign-in tab) continue polling APIs with expired tokens, generating 401 noise in net-dump logs. Consider adding token refresh or stopping polling on auth failure.
- The TanStack React Query devtools panel is visible in the Console UI — should be disabled for production/acceptance testing builds.

## Environment setup improvements

- Seed data has duplicate themes (54 entries = 9 copies of 6 themes). The seeding/migration script should be idempotent to avoid duplicates on re-runs.
- Consider adding a mechanism to reset the environment to a clean state (delete test applications, reset seed data) for repeatable acceptance testing.
