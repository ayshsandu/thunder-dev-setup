# Manage Users - Critical Analysis

## Implementation/Backend critique

- [ ] GET /users?include=display sends no pagination parameters (limit/offset) — will fail to scale with many users (P2)
- [ ] CORS access-control-allow-methods inconsistent across endpoints — user list (GET, POST) vs user detail (GET, PUT, DELETE) — but PATCH is missing everywhere (P2)
- [ ] Password is sent in plaintext in the POST /users request body — visible in wire dumps, proxy logs, and any intermediate infrastructure (P1)
- [ ] **No server-side password strength validation — CONFIRMED**: user "weakpwduser" created with password "123" was accepted (201 Created). Any password is accepted regardless of length or complexity (P1)
- [ ] The "sub" (subject) OIDC claim is exposed as a fillable field in the create-user form — this should be system-generated, not admin-editable (P2)
- [ ] **User edit is completely broken** — PUT /users/{id} returns 400 (USR-1019 "Schema validation failed") because the edit form does not include a password field, but the schema marks password as `required:true` and PUT does full replacement (P1)
- [ ] PUT endpoint used instead of PATCH for user updates — forces full replacement semantics requiring all required fields including credentials, making partial attribute edits impossible (P1)
- [ ] Edit form sends empty strings for cleared optional fields instead of omitting them from the payload — empty string likely fails schema validation for fields that expect a non-empty value (P2)
- [ ] API error response (USR-1019) provides no detail on which attribute failed schema validation or why — makes debugging impossible for both users and developers (P2)

## UX critique

- [ ] Duplicate user creation (409 Conflict) shows only "Request failed with status code 409" — the API returns meaningful error `USR-1014: Attribute conflict` with description but the UI does not surface it to the admin (P2)
- [ ] Display Name column shows the `username` field ("admin") instead of the `name` attribute ("Administrator") — misleading column header (P2)
- [ ] Actions column is empty — no edit/delete/view buttons on user rows; the only way to interact with a user may be to click the row (P2)
- [ ] User type ("Person") is not shown in the list even though the API returns it — useful context missing (P3)
- [ ] No email or other identifying info shown in list — only Display Name and UUID, making it hard to identify users (P2)
- [ ] Create-user wizard only offers "Person" and "Customer" user types — Thunder claims to support employees, businesses, AI agents but these are not available (P3)
- [ ] No password strength indicator or requirements hint shown during user creation (P2)
- [ ] No confirm-password field — easy for admin to create a user with a mistyped password (P2)
- [ ] No success toast/notification after user creation — redirect to list is the only confirmation (P3)
- [ ] Post-creation, display name shows username ("testuser1") not the given_name + family_name ("Test User") (P3)
- [ ] Edit save error displays only "Request failed with status code 400" inline and generic toast — the API error code/description (USR-1019) is not surfaced to the admin (P2)
- [ ] Error banner from failed save persists in the form between retry attempts — stale error state (P3)

## UI critique

- [ ] Form field labels use raw attribute names with inconsistent casing — snake_case (given_name, family_name, phone_number) mixed with camelCase (mobileNumber) — affects both create and edit forms (P2)
- [ ] No field-level validation feedback before form submission (P3)
- [ ] Edit form placeholder text uses raw attribute names: "Enter phone_number", "Enter mobilenumber" — not user-friendly (P3)

## Other
