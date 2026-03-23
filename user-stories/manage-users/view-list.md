# View user list

## UI Actions Done

1. Navigated to Console > Users (sidebar: IDENTITIES > Users)
2. Page loaded at /console/users
3. Observed the user list table with one user (admin)

## Observations

### Page layout
- Title: "User Management", subtitle: "Manage users, roles, and permissions across your organization"
- Two action buttons top-right: "Invite User" (outlined orange) and "+ Add User" (filled orange)
- Search bar: "Search users..." placeholder
- Table columns: Display Name, User ID, Actions
- Pagination: "Rows per page: 10", "1-1 of 1", prev/next arrows

### User row
- Avatar: orange circle with initials "AD"
- Display Name: "admin"
- User ID: `019d1969-d2c1-71e2-91b6-33d2ba3389a6`
- **Actions column is empty** — no edit/delete/view buttons in the row

### API analysis (GET /users?include=display → 200)
- Request: `GET /users?include=display` — no pagination parameters (no limit/offset)
- Response body: `totalResults:1, startIndex:1, count:1`
- User object fields: id, ouId, type ("Person"), attributes (email, email_verified, family_name, given_name, name, phone_number, phone_number_verified, picture, sub, username), display ("admin")
- The `display` field is "admin" which matches the `username` — the Display Name column shows the username, not the `name` attribute ("Administrator")
- The API returns rich user data (email, phone, picture URL) but the table only shows Display Name and User ID
- No pagination params sent — could be a problem with larger user sets
- CORS: access-control-allow-methods only lists GET, POST
- The admin user's type is "Person" — this is the admin's user type, not visible in the list UI
- The `links` field in the response is an empty array

### User detail page (clicking a row)
- Clicking a user row navigates to /console/users/{id}
- Header: username ("admin"), avatar, "Person" badge, user ID with copy button
- "← Back to Users" link
- Single tab: "General"
- "User Attributes" section with Edit button — shows all attributes as label:value pairs
- Attributes displayed: email, email_verified, family_name, given_name, name, phone_number, phone_number_verified, picture, sub, username
- "Danger Zone" section at bottom with "Delete User" (red button) and warning text
- No group/role assignment section visible — only one "General" tab

### Positive
- Page loads cleanly, search bar is present
- User data returned correctly from API
- Avatar initials correctly derived
- User row is clickable and navigates to detail page
- Delete functionality is available on user detail page
- Edit button present on user detail page
