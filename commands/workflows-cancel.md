---
description: Cancel an in-progress workflow run with gh run cancel.
agent: gh-ops
---
Load `gh-workflows` and apply the "Cancel a Run" steps: run `gh run cancel $1` then `gh run watch $1 --exit-status` to verify it stopped.
If the run already completed, report that status instead of erroring.
