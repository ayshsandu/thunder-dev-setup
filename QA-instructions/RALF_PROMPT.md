Do acceptance testing for Thunder.
Read ./thunder-dev-setup/QA-instructions/DEBUG.md
Read ./thunder-dev-setup/user-stories/index.md

Pick a single epic (prioritize by breadth and importance) and at most 3 (related/interdependent) stories in it.

For each story:

- Perform black box testing. You must use chrome via mcp tool, if can't, stop.
- Read all relevant ./net-dump/logs/requests/\*.txt files. Use an `Explore` task if needed.
- Prod the black boxes directly to reveal implementation issues.
- Create ./thunder-dev-setup/user-stories/<epic>/<story>.md and ./thunder-dev-setup/user-stories/<epic>/critical-analysis.md Don’t wait till the end, create and modify often.
- Delete ./net-dump/logs/requests/\*.txt (repeat this as needed during the testing).

You may imagine and do additional stories (not a priority) as you go, but be sure to update index.md. Add/modify ./thunder-dev-setup/user-stories/index.md with epics/stories you discovered (both completed/yet to be completed). If there is some functionality that the product may/should provide but not in the current index, you must add those. Organize/split/rearrange the epics/stories. If you faced difficulties due to limitations of the test setup, add those to ./thunder-dev-setup/instructions/TODO.md.

Mark the completed stories and reset the environment before you finish.
