# Login successfully with valid credentials

## UI Actions Done

1. Navigated to `https://localhost:8090/console`
2. Browser redirected to `https://localhost:8090/gate/signin` (Gate authentication portal)
3. Sign-in page displayed with Thunder branding, Username and Password fields, and Sign In button
4. Left panel shows marketing copy: "Flexible Identity Platform", "Zero-trust Security", "Developer-first Experience", "Extensible & Enterprise-ready"
5. Entered "admin" in Username field
6. Entered "admin" in Password field
7. Clicked "Sign In" button
8. Successfully redirected to `https://localhost:8090/console/` — Console dashboard showing "Hello, Administrator"

## Observations

### Login flow (OAuth2/OIDC Authorization Code with PKCE)

The login follows a standard OAuth2 authorization code flow with PKCE:

1. **GET /oauth2/authorize** → 302 redirect to Gate sign-in page
   - Sends: `response_type=code`, `client_id=CONSOLE`, `scope=openid profile email ou system ...`, PKCE `code_challenge` (S256), `state`
   - Returns: redirect to `/gate/signin` with `applicationId`, `authId`, `flowId`
   - Security headers present: `content-security-policy: frame-ancestors 'none'`, `x-frame-options: DENY` — good clickjacking protection

2. **POST /flow/execute** (initial) — fetches the sign-in form definition
   - Sends: `{"flowId":"...","verbose":true}`
   - Returns: `flowStatus: "INCOMPLETE"`, form component tree with text inputs for username/password

3. **POST /flow/execute** (credential submission) — submits credentials
   - Sends: `{"flowId":"...","inputs":{"username":"admin","password":"admin"},"action":"action_001"}`
   - Returns: `flowStatus: "COMPLETE"` with a JWT `assertion` token
   - The assertion JWT contains assurance info: `aal: "AAL1"`, `ial: "IAL1"`, authenticator: "CredentialsAuthenticator"

4. **POST /oauth2/auth/callback** — exchanges assertion for authorization code
   - Sends: assertion JWT + authId
   - Returns: `redirect_uri` with `code` and `state` params

5. **POST /oauth2/token** — exchanges code for tokens
   - Sends: `client_id=CONSOLE`, `code`, `grant_type=authorization_code`, `redirect_uri`, `code_verifier` (PKCE)
   - Returns: `access_token` (JWT), `id_token` (JWT), `token_type=Bearer`, `expires_in=3600`, `scope=openid profile email ou system`

6. **GET /oauth2/jwks** — fetches public keys for token verification
   - Returns RSA public key set

### Post-login API calls
- **GET /applications** → 200: fetches application list (3 apps: Console, React SDK Sample, Sample App)
- **GET /users** → 200: fetches user list

### Sign-in page UI
- Clean, professional design with Thunder branding
- Username and Password fields clearly marked as required (asterisks)
- Password field has visibility toggle icon (eye icon)
- No "Forgot password?" link present
- No "Create account" / self-registration link present
- No social login options (Google, GitHub) visible

### Positive findings
- PKCE is used (code_challenge_method=S256) — protects against authorization code interception
- Clickjacking protection headers present (CSP frame-ancestors 'none', X-Frame-Options DENY)
- Access token has 1-hour expiry (3600s) — reasonable default
- CORS properly configured with specific origin allowlisting
- Flow-based authentication architecture allows extensible sign-in experiences
- Assurance level tracking (AAL1, IAL1) shows NIST compliance awareness
- i18n support built into the flow component model

### Concerns
- Password sent in plaintext in POST body (mitigated by HTTPS, but visible in wire-dump/proxy logs)
- No CSRF token visible in the OAuth2 flow (state parameter serves a similar purpose)
- No rate limiting headers visible on authentication endpoints
- Token response does not include a refresh_token despite scope including "openid"
- No "remember me" option on the sign-in form
- Console client_id is hardcoded as "CONSOLE" with no client_secret — public client, appropriate for SPA but worth noting
