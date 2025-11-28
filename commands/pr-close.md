---
description: Close a pull request and optionally delete its branch.
agent: gh-pr-issue-controller
---
Load `gh-pr-issue` and follow "Close / Reopen Pull Request".
Run `gh pr close $1`, using the second argument as a farewell comment when provided and deleting the branch if the third argument equals `delete`.
