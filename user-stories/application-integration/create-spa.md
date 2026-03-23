# Create a new single page application

## UI Actions Done

1. Clicked "+ Add Application" from the Applications list page
2. Step 1 - Name: Entered "Test SPA App", clicked Continue
3. Step 2 - Design: Selected default logo (COOL emoji), kept default theme (Acrylic Orange), scrolled past massively duplicated theme list, clicked Continue
4. Step 3 - Sign In Options: Username & Password ON (default), Passkey OFF, Google/GitHub "Not configured", clicked Continue
5. Step 4 - Sign-In Experience: Selected "Redirect to Thunder sign-in/sign-up handling pages", User Access: "Customer" selected, clicked Continue
6. Step 5 - Technology Stack: React selected (default), Application Type options available (Browser App, Full-Stack App, Mobile App, Backend Service), clicked Continue
7. Application created successfully, redirected to detail page at /console/applications/{id}

## Observations

### Wizard flow (5 steps)
- Create an Application > Design > Sign In Options > Sign-In Experience > Technology Stack
- Breadcrumb navigation shows full path
- Live preview panel on right side shows themed sign-in form
- Preview has responsive toggles (mobile/tablet/desktop) and color scheme (light/dark)
- "In a hurry? Pick a random name" feature with generated names (eg: "Six Nails Go")

### Design step issues
- **Theme list renders 54 items** — the same 6 themes duplicated 9 times with different IDs in the database
- The Back/Continue buttons are pushed far below the massive theme list, requiring extensive scrolling
- Users must scroll through ~50+ duplicate theme cards to reach Continue
- The theme list comes from GET /design/themes which returns totalResults:54 — 9 copies of 6 unique themes
- createdAt and updatedAt fields are all empty strings in the API response

### Sign In Options
- Google and GitHub shown as "Not configured" — good UX, shows what's possible
- Hint text: "You can always change these settings later in the application settings."

### Technology Stack
- Next.js has "Coming Soon" badge and is greyed out
- Application Type section appears below with an "OR" separator — unclear if selecting a Technology (React) and an Application Type are mutually exclusive or complementary

### API Analysis (POST /applications -> 201)

Request body sent:
- name, logo_url (emoji:COOL), auth_flow_id, user_attributes, theme_id, is_registration_flow_enabled: true
- allowed_user_types: ["Customer"], template: "react"
- inbound_auth_config with oauth2: public_client, pkce_required, grant_types (authorization_code, refresh_token), redirect_uris (http://localhost:5173), scopes (openid, profile, email)

Response includes:
- Generated client_id (opaque string, not UUID)
- token validity defaults: access_token 3600s, id_token 3600s
- login_consent validity_period: 0
- certificate type: NONE

### Post-creation page
- Detail view with tabs: Guide, General, Flows, Customization, Token, Advanced Settings
- Guide tab active by default — shows React integration steps
- "Integrate with an LLM Prompt" section with "Copy Prompt" button — innovative feature
- App ID shown with copy button
- Name and description are editable inline
