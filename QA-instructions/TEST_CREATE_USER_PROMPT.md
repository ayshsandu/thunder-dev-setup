Do acceptance testing for Thunder.
Read ./thunder-dev-setup/QA-instructions/DEBUG.md
Read ./thunder-dev-setup/user-stories/manage-users/create-user.md

Focus specifically on executing the testing steps outlined in the create user user story.

- Perform black box testing for the create user flow. You must use chrome via mcp tool, if can't, stop.
- Read all relevant ./net-dump/logs/requests/\*.txt files. Use an `Explore` task if needed.
- Prod the black boxes directly to reveal implementation issues specific to user creation.
- Create/update ./thunder-dev-setup/user-stories/manage-users/create-user.md and ./thunder-dev-setup/user-stories/manage-users/critical-analysis.md with your findings. Don’t wait till the end, create and modify often.
- Delete ./net-dump/logs/requests/\*.txt (repeat this as needed during the testing).

If there is some functionality related to user management that the product may/should provide but is not defined yet, you must add those to the documentation. If you faced difficulties due to limitations of the test setup, add those to ./thunder-dev-setup/QA-instructions/TODO.md.

Mark the completed story in index.md and reset the environment before you finish.
