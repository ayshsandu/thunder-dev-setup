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
- Application integration
  - [ ] view the list of applications
  - [ ] create a new single page application
- Manage user types
  - [ ] add a new user type
- Manage users
  - [] view user list