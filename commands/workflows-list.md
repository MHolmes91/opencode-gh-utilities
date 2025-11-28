---
description: List workflows in the target repo with gh workflow list.
agent: gh-ops
---
Load the `gh-workflows` skill (`openskills read gh-workflows`) and follow the "List Workflows" section.
Run `gh workflow list` for ${ARGUMENTS:-$GITHUB_REPOSITORY} and return the JSON table so I can decide what to monitor next.
