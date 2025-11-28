---
description: Dispatch a workflow using gh workflow run.
agent: gh-ops
---
Load `gh-workflows` and follow "Trigger a Workflow" to run `gh workflow run $1 --ref ${2:-$DEFAULT_BRANCH}`.
If a JSON blob is provided as the third argument, treat it as `--inputs` for the command.
Summarize the run id returned by gh.
