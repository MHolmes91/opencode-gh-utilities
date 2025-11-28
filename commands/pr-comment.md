---
description: Add a pull request comment using gh pr comment.
agent: gh-pr-issue-controller
subtask: true
---
Load `gh-pr-issue` and follow "Comment on Pull Request" using `gh pr comment $1 --body "$2"`.
If `$2` is empty, ask for the message before executing.
