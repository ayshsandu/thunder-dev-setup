# Edit a user

## UI Actions Done

1. From Users list, clicked on "testuser1" row to navigate to detail page
2. On detail page, clicked "Edit" button in User Attributes section
3. Edit mode activated — all attributes became editable form fields
4. Changed given_name from "Test" to "TestEdited"
5. Added phone_number "+1234567890"
6. Clicked "Save"
7. **Save failed** — "Request failed with status code 400", toast: "Failed to update user. Please try again."
8. Cleared phone_number field, clicked Save again
9. **Save failed again** — same 400 error

## Observations

### Edit mode UI
- Clicking "Edit" transforms the read-only attribute display into an editable form
- All schema-defined fields are shown, including empty optional ones (mobileNumber, phone_number, sub, name, picture)
- Required fields (username, email) marked with red asterisk
- Cancel and Save buttons appear at bottom
- No password field shown in edit mode (password was required during creation)
- The Danger Zone / Delete section remains visible below the form during edit (after scrolling)
- Previous error banner persists in the form area between save attempts — not cleared on re-edit

### Form field labels (same issue as create)
- Labels use raw attribute names: snake_case (given_name, family_name, phone_number, phone_number_verified) and camelCase (mobileNumber) mixed inconsistently
- Placeholder text is "Enter {attribute_name}" using the raw attribute name

### API analysis — first attempt (PUT → 400)
- Method: `PUT /users/{id}` (not PATCH)
- Request body: `{"ouId":"...","type":"Person","attributes":{"email":"testuser1@example.com","family_name":"User","given_name":"TestEdited","username":"testuser1","phone_number":"+1234567890"}}`
- Response: `400 Bad Request` — `{"code":"USR-1019","message":"Schema validation failed","description":"User attributes do not conform to the required schema"}`
- CORS preflight for PUT: access-control-allow-methods correctly lists `GET, PUT, DELETE` (different from user list endpoint which only has GET, POST)

### API analysis — second attempt (PUT → 400, phone_number cleared)
- Request body: `{"ouId":"...","type":"Person","attributes":{"email":"testuser1@example.com","family_name":"User","given_name":"TestEdited","username":"testuser1","phone_number":""}}`
- The cleared phone_number is sent as empty string `""` instead of being omitted from the payload
- Same 400 error — schema validation fails on the empty string for phone_number (or possibly the missing password field)

### Root cause analysis
- The user schema defines `password` as `{"type":"string","required":true,"credential":true}` — but the edit form does not include a password field
- The GET /users/{id} response does not return the password attribute (correctly, as it's a credential)
- The PUT endpoint likely validates all required fields including password, causing the schema validation failure
- This is a **backend/frontend contract mismatch**: the PUT endpoint requires a full replacement including credentials, but the UI has no way to provide the password on edit
- The API should either: (a) use PATCH for partial updates, (b) exclude credential fields from PUT validation, or (c) the UI should include a password field in edit mode
- Additionally, the UI sends empty strings for cleared optional fields instead of omitting them, which may also fail schema validation

### Error handling
- Error message is completely opaque: "Schema validation failed" / "User attributes do not conform to the required schema"
- No indication of WHICH attribute failed or WHY
- The inline error banner says "Request failed with status code 400" — just the HTTP status, no useful detail
- Toast message is equally generic: "Failed to update user. Please try again."
- The detailed error code (USR-1019) and description from the API response are not surfaced to the user

### User detail page (GET /users/{id} → 200)
- Returns: id, ouId, type, attributes (email, family_name, given_name, username), display
- Only attributes that were set during creation are returned — empty optional fields are not in the response
- The user-schema is also fetched (GET /user-schemas/{id}) to determine which fields to render in edit mode

### Positive
- Edit mode correctly transitions from read-only to editable
- Required fields correctly marked with asterisks
- CORS is properly configured for PUT on the user endpoint
- Cancel button works to exit edit mode without changes
- User detail page loads correctly with all stored attributes
