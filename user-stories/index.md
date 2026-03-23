# Introduction

Top level are user epic. Each sub item in the list is a user story. Format: each story reads as a continuation of `As a xxx I should be able to`. Stories should cover all the variations or edge cases of the epic. Each story is something that should work if the product is to be accepted. Completed ones are marked with a check mark. Strikes through ones we are skipping for now (eg: due to limitations of the test setup).

Epics at top level. Stories as

For each epic there is a subdirectory in ./user-stories/. Each epic dir contains critical-analysis.md and multiple <story>.md files. Create the filename by summarizing the story to couple of words.
eg: ./user-stories/login/login.md, ./user-stories/login/wrong-password.md

# <epic>/<story>.md structure

- UI Actions Done
- Observations

# <epic>/critical-analysis.md structure

Must only contain issues that need to be addressed. No positive statements, those should be in the <story>.md file. Eg: `- [ ] xxx (P1)`

- Implementation/Backend critique
- UX critique
- UI critique
- Other

Each item must be (P1), (P2), (P3) priority appended.

# User stories

- Console login
  - [ ] login successfully with valid credentials
  - [ ] login with wrong password shows error
  - [ ] session expiry and re-authentication
- Application integration
  - [x] view the list of applications
  - [x] create a new single page application
  - [x] edit an application
  - [ ] delete an application
  - [ ] search/filter applications in the list
  - [ ] create a full-stack application
  - [ ] create a mobile application
  - [ ] create a backend service application
- Application configuration
  - [ ] configure OAuth2/OIDC settings (scopes, grant types)
  - [ ] manage authorized redirect URIs
  - [ ] configure token settings (validity periods)
  - [ ] manage application sign-in flows
  - [ ] customize application theme/design
- Manage user types
  - [ ] add a new user type
  - [ ] view existing user types
  - [ ] edit a user type
  - [ ] delete a user type
- Manage users
  - [x] view user list
  - [x] create a new user
  - [x] edit a user (**BLOCKED — PUT /users/{id} returns 400 due to missing password in edit payload**)
  - [ ] delete a user
  - [ ] assign user to a group
  - [ ] search/filter users in the list
- Manage groups
  - [ ] view group list
  - [ ] create a new group
  - [ ] edit a group
  - [ ] delete a group
- Design & theming
  - [ ] view available themes
  - [ ] create a custom theme
  - [ ] apply theme to an application
- Sign-in experience (Gate)
  - [ ] sign in with username and password
  - [ ] sign in with passkey
  - [ ] sign in with social providers (Google, GitHub)
  - [ ] self-registration flow
- Organization units
  - [ ] view organization units
  - [ ] create an organization unit
- Integrations
  - [ ] view available integrations
  - [ ] configure an integration (Google, GitHub)
- Flows
  - [ ] view authentication flows
  - [ ] edit an authentication flow
