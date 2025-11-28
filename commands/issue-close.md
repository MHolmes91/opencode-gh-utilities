---
description: Close an issue using gh issue close.
agent: gh-pr-issue-controller
---
Load `gh-pr-issue` and run the "Close or Reopen Issue" steps with `state=closed` to execute `gh issue close $1`.
Optionally take a second argument for a context comment before closing.
