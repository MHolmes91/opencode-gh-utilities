# GitHub Operations Skills Pack

A set of OpenSkills-driven gh automations plus Opencode agents, subagents, and commands that keep workflows and pull requests healthy. Everything lives directly in this repository so it can be installed locally or imported into another project.

## Contents

- `skills/gh-workflows/SKILL.md` – OpenSkills instructions for listing, running, cancelling, and monitoring workflows.
- `skills/gh-pr-issue/SKILL.md` – OpenSkills instructions for keeping PRs/issues tidy (checks, comments, state changes).
- `agents/gh-ops.md` – top-level agent wiring every skill and command together.
- `agents/subagents/*.md` – dedicated workflow and PR/issue controllers.
- `commands/*.md` – Opencode command templates that install to `~/.config/opencode/command/` (or `DIR/.opencode/command/` when overridden).
- `scripts/install_deps.sh` – dependency installer (gh, jq, Python packages).
- `scripts/init.sh` – initialization helper that copies commands and registers skills/agents.
- `Makefile` – wraps dependency installation plus the init workflow.

## Dependencies

The skills rely on the GitHub CLI plus jq for JSON shaping. Install everything with:

```bash
make deps
```

`make deps` ensures:

- `gh` – GitHub CLI authenticated with `gh auth login --scopes repo,workflow`.
- `jq` – lightweight JSON processor used by skill shell snippets.
- `python3` + `pip` – installs `opencode`, `openskills`, and helper libraries from `requirements.txt`.

> **Note:** `scripts/install_deps.sh` attempts to use Homebrew on macOS and `apt-get` on Linux. If neither is available you will be prompted to install the binaries manually.

## Environment Variables

Export the repository defaults before running the init step so skills know which repo to target:

```bash
export GITHUB_REPOSITORY=owner/repo
export GITHUB_TOKEN=ghp_your_token_with_repo_and_workflow_scopes
export DEFAULT_BRANCH=main
```

## Initialize Everything

After installing dependencies, run the init workflow:

```bash
make init
```

This will:

1. Copy every file under `commands/` into `~/.config/opencode/command/` so they are available via `/` commands in the TUI. If you pass `DIR=/some/project`, files install under `/some/project/.opencode/command/` instead.
2. Copy the agent markdown files into `~/.config/opencode/agent/` (or `DIR/.opencode/agent/`) and register the top-level agent plus both subagents with Opencode (when the CLI is installed).
3. Install and sync the local SKILL catalog through `openskills install . --universal -y` followed by `openskills sync`.

Each run writes a manifest at `~/.config/opencode/.gh_ops_manifest` (or `DIR/.opencode/.gh_ops_manifest`) so any previously installed commands/agents from this package are removed before copying new versions. That keeps updates clean and makes rerunning safe.

You can re-run `make init` any time after editing skills/commands. To install into another checkout, rerun `make init DIR=/path/to/project`.

## Provided Skills

### `gh-workflows`

Instructions for:

- Listing workflows for a repo with `gh workflow list`.
- Listing, viewing, and monitoring workflow runs via `gh run list/view/watch`.
- Cancelling noisy runs and confirming they stop.
- Manually dispatching workflows against a branch/ref with optional JSON inputs.

### `gh-pr-issue`

Instructions for:

- Listing PRs and summarizing failing checks.
- Opening PRs in the browser, commenting, and closing/deleting branches.
- Listing issues, viewing metadata, commenting, and closing/reopening state.

Both SKILL files follow the [OpenSkills `SKILL.md` spec](https://github.com/numman-ali/openskills?tab=readme-ov-file#the-skillmd-format) and describe the exact `gh` commands to run in each scenario.

## Agents & Subagents

- `agents/gh-ops.md` – orchestrates both skill packs, default env vars, and the Opencode command set.
- `agents/subagents/gh-workflow-controller.md` – polls workflow runs, cancels duplicates, and monitors restarts.
- `agents/subagents/gh-pr-issue-controller.md` – triages review queues, checks statuses, and keeps issue hygiene.

Register them with `make init` or manually:

```bash
opencode agents add agents/gh-ops.md --force
opencode agents add agents/subagents/gh-workflow-controller.md --force
opencode agents add agents/subagents/gh-pr-issue-controller.md --force
```

## Commands

Command files such as `commands/workflows-monitor.md` and `commands/pr-checks.md` follow the [Opencode command specification](https://opencode.ai/docs/commands/). After `make init` copies them into `~/.config/opencode/command/` (or `DIR/.opencode/command/`), they are available via:

```
/workflows-list
/workflows-runs deploy.yml
/workflows-monitor 123456789
/workflows-trigger deploy.yml feature-branch
/pr-open 123
/pr-checks 123
/pr-comment 123 "Ship it"
/pr-close 123 "Closing in favor of #456" delete
/issue-comment 42 "Following up"
/issue-close 42 "Resolved by PR #123"
```

Each template reminds the agent to invoke the relevant skill so the `gh` commands run automatically.

## Manual Registration (Optional)

If you prefer finer control than `make init`, run the following yourself:

```bash
mkdir -p ~/.config/opencode/command
cp commands/*.md ~/.config/opencode/command/
opencode agents add agents/gh-ops.md --force
opencode agents add agents/subagents/gh-workflow-controller.md --force
opencode agents add agents/subagents/gh-pr-issue-controller.md --force
openskills install . --universal -y
openskills sync
```

Prefer project-scoped installs? Replace `~/.config/opencode` with `$DIR/.opencode` in the commands above.

That’s it—you now have reproducible `gh` automation that can monitor, cancel, rerun, and summarize workflows alongside complete PR/issue hygiene.
