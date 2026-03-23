# View the list of applications

## UI Actions Done

1. Logged into Console with admin:admin via Gate sign-in
2. Clicked "Applications" in sidebar under RESOURCES
3. Applications list page loaded at /console/applications

## Observations

- Page title: "Applications" with subtitle "Manage your applications and services"
- Search bar present at top
- Table columns: Name, Type, Client ID, Actions
- One application listed: "Console" with description "Management application for Thunder"
  - Type column shows "-" (dash)
  - Client ID: "CONSOLE"
  - Actions column: empty (no visible action buttons like edit/delete)
- Pagination shows "Rows per page: 10" with "1-1 of 1"
- "+ Add Application" button in top-right corner
- Application icon uses emoji (decoded from API: emoji:star)

### API Analysis (GET /applications?limit=30&offset=0 -> 200)

- API returns: totalResults, count, and applications array
- Each application object: id, name, description, client_id, logo_url, auth_flow_id, registration_flow_id, is_registration_flow_enabled
- API does NOT return a "type" field, yet the UI has a "Type" column showing "-"
- UI sends limit=30 but displays "Rows per page: 10" — mismatch between fetched data and displayed pagination setting
- CORS allows only GET, POST methods (no PUT/PATCH/DELETE in access-control-allow-methods)

### Background noise

- Multiple 401 Unauthorized responses observed from stale requests (likely from another tab/session with expired token)
- These 401 requests used limit=1&offset=0 (different from the main page's limit=30)
