---
description: Open a pull request in the browser.
agent: gh-ops
---
Load the `gh-pr-issue` skill and follow the "View Pull Request" instructions for the `--web` mode.
Execute `gh pr view $1 --web` for the configured repo; if `$1` is omitted, default to the current branch's PR.
