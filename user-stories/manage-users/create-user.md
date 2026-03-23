# Create a new user

## UI Actions Done

1. From Users list, clicked "+ Add User"
2. Step 1 — "Select a user type": opened dropdown, only "Person" available, selected it, clicked Continue
3. Step 2 — "Enter user details": filled in username (testuser1), email (testuser1@example.com), given_name (Test), family_name (User), password (TestPass123!)
4. Clicked "Create User"
5. Redirected to Users list — new user "testuser1" appears in the table

## Observations

### Wizard flow (2 steps)
- Step 1: User Type selection (dropdown, required). Breadcrumb: "User Type"
- Step 2: User Details form. Breadcrumb: "User Type > User Details"
- Wizard has X close button and Back/Continue navigation

### User type dropdown
- Two options available: "Person" and "Customer"
- Thunder claims to support employees, businesses, AI agents — but only Person and Customer types exist in seed data
- Previous testing session only found "Person"; "Customer" appeared in subsequent testing

### Form fields (Step 2)
- Required fields (red asterisk): username, email, password
- Optional fields: email_verified (checkbox), given_name, family_name, mobileNumber, phone_number, phone_number_verified (checkbox), sub, name, picture
- **Field labels use raw attribute names** — snake_case (given_name, family_name, phone_number) and camelCase (mobileNumber) mixed inconsistently
- No field validation feedback shown before submission
- No password strength indicator or requirements shown
- No confirm password field
- The "sub" field is confusing for an admin creating a user — this is an OIDC claim, not something an admin should fill

### API analysis (POST /users → 201)
- Request body: `{"ouId":"...","type":"Person","attributes":{"username":"testuser1","email":"testuser1@example.com","given_name":"Test","family_name":"User","password":"TestPass123!"}}`
- **Password is sent in plaintext** in the JSON request body — visible in wire dumps/logs
- Response (201): returns id, ouId, type, and attributes (email, family_name, given_name, username) — password correctly NOT echoed back
- The ouId is automatically inherited from the admin user's org unit
- Empty optional fields are NOT included in the request or response

### Post-creation
- Redirected to user list automatically
- New user appears in list with Display Name "testuser1" (username, not full name)
- Avatar shows "TE" initials
- No success toast/notification visible on redirect
- Pagination updated to "1-2 of 2"

### Edge case: Duplicate user (POST /users → 409)
- Created a second user with same username/email as testuser1
- API returned 409 with error: `{"code":"USR-1014","message":"Attribute conflict","description":"A user with the same unique attribute value already exists"}`
- **UI only showed "Request failed with status code 409"** — the meaningful API error code and description were not surfaced to the admin
- Uniqueness constraint enforced server-side on both username and email

### Edge case: Weak password (POST /users → 201)
- Created user "weakpwduser" with password "123"
- **API accepted it and returned 201 Created** — no server-side password strength validation
- This is a **P1 security vulnerability**: any password is accepted regardless of length or complexity
- No client-side password strength validation either — no strength indicator, no requirements hint

### Edge case: Invalid email format
- Entered "not-an-email" in the email field
- **Client-side validation caught it** — "email format is invalid" shown in red below the email field
- No API call was made — form prevented submission
- Client-side validation uses regex pattern matching on email format

### Positive
- User creation works end-to-end
- Required field validation correctly enables/disables Create button
- API returns 201 with new user ID
- Password not echoed in response
- Client-side email format validation prevents invalid submissions
- Server-side uniqueness constraint on username/email works correctly (409 Conflict)
