---
description: Show the latest runs for a workflow via gh run list.
agent: gh-ops
---
Load `gh-workflows` and execute the "List Workflow Runs" procedure using `gh run list --workflow $1`.
Treat `$2` as the branch filter and `$3` as the status filter when provided, passing them to the command.
Return the resulting JSON payload.
