---
description: Comment on a GitHub issue with gh issue comment.
agent: gh-pr-issue-controller
---
Load `gh-pr-issue` and execute the "Comment on Issue" instructions with `gh issue comment $1 --body "$2"`.
If no comment body is provided, ask for it first.
