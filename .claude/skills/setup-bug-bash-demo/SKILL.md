---
name: setup-bug-bash-demo
description: Set up the Bug Bash GitHub demo end to end - local git repo, GitHub repository, labels, Actions check, pre-made backup issues for the live demo, and the list of browser tabs to open. Use when the user wants to prepare, set up, bootstrap or reset this demo repository before a talk.
argument-hint: "[OWNER/]REPO [public|private]"
arguments: repo visibility
disable-model-invocation: true
allowed-tools: Bash(gh auth status*) Bash(gh api user*) Bash(gh repo view*) Bash(gh label list*) Bash(gh workflow list*) Bash(gh run list*) Bash(gh issue list*) Bash(git status*) Bash(git remote*) Bash(git log*)
---

# Set up the Bug Bash demo

This skill gets the demo in this repository ready for a live talk: a GitHub repository that has the issue form, labels, workflow, and two backup issues. Work through the steps in order and stop at the first failure. Report the failure; don't work around it silently.

Arguments: repository `$repo` (either `OWNER/REPO` or just `REPO`, in which case the owner is the authenticated user) and visibility `$visibility` (`public` or `private`).

## 0. Preflight

1. Run `gh auth status`. If it fails, tell the user to run `gh auth login` and stop.
2. Check that `git` and `jq` are installed.
3. Resolve the target:
   - If `$repo` is empty, ask the user for a repository name and suggest `bug-bash-demo`.
   - If `$repo` has no owner, prefix it with `gh api user --jq .login`.
   - If `$visibility` is empty, ask. Recommend `public` if the audience should be able to clone it afterwards, `private` otherwise.
4. Check whether `docs/SPEAKER-SCRIPT.md` exists. If it does and visibility is `public`, ask whether the speaker notes should be published. If not, add `docs/SPEAKER-SCRIPT.md` to `.gitignore` before the first commit.
5. **Confirm before anything outward-facing.** Show the user a short plan: target `OWNER/REPO`, visibility, whether the repository already exists (`gh repo view OWNER/REPO`), and what will be created (labels, 2 issues). Wait for an explicit yes. Never push to a repository that already exists and holds unrelated content.

## 1. Local git repository

- If the working directory is not a git repository, run `git init -b main`.
- Stage everything and commit if there are changes: `git add -A && git commit -m "chore: set up Bug Bash demo"`.
- Before committing, check `git status` for anything that should not be published, such as `.env` files, secrets, or personal notes. If you find any, stop and ask.

## 2. GitHub repository

- **The repository does not exist:** run `gh repo create OWNER/REPO --$visibility --source=. --remote=origin --push`.
- **The repository exists and is empty or already this demo:** set `origin` if it is missing (`git remote add origin https://github.com/OWNER/REPO.git`), then run `git push -u origin main`.
- Check that the default branch is `main` and contains `.github/workflows/triage-bug-bash-finding.yml`. The `issues` trigger only runs workflows from the default branch.

## 3. Labels

Run `./scripts/bootstrap-labels.sh OWNER/REPO`. Then check with `gh label list --repo OWNER/REPO` that `bug-bash` and `needs-triage` exist. Without them the issue form cannot apply its labels and the workflow never runs.

## 4. GitHub Actions

- Run `gh api repos/OWNER/REPO/actions/permissions --jq .enabled`. If the result is `false`, ask the user before enabling it with `gh api -X PUT repos/OWNER/REPO/actions/permissions -F enabled=true`.
- Run `gh workflow list --repo OWNER/REPO` and confirm that `Triage new Bug Bash finding` is listed and active.

## 5. Backup issues for the live demo

Run the bundled script:

```bash
"${CLAUDE_SKILL_DIR}/scripts/create-backup-issues.sh" OWNER/REPO
```

It is idempotent, so running it again reuses existing issues. It creates:

- **Issue A:** the demo finding, freshly submitted. The script waits up to about 2 minutes for the workflow's triage comment. This is the fallback if Actions is slow during the talk.
- **Issue B:** the same finding, already triaged, with `finding:risk` and `decision-needed` applied and a filled decision record as a comment. This is what gets shown at minute 4:00.

The script also smoke-tests the whole chain. If issue A gets no triage comment, run `gh run list --repo OWNER/REPO --workflow "Triage new Bug Bash finding" --limit 3`, show the user the latest run's status, and suggest causes: labels missing, Actions disabled, workflow not on the default branch, or an organization policy that blocks Actions.

## 6. Hand-off

End with a short summary for the user:

1. The repository URL and its visibility.
2. **Browser tabs to open, in presentation order:**
   1. `https://github.com/OWNER/REPO/blob/main/docs/RISK-MAP.md`
   2. `https://github.com/OWNER/REPO/blob/main/docs/CHARTER-LIBRARY.md`
   3. `https://github.com/OWNER/REPO/issues/new?template=bug-bash-finding.yml`
   4. Issue A URL
   5. Issue B URL
3. Reminders: browser zoom at 125–150%, notifications muted, the form values from `docs/DEMO-SCENARIO.md` ready to paste, and offline screenshots as a fallback.
4. Anything skipped or failed, stated plainly.

## Reset after a rehearsal

If the user asks to reset the demo, list the non-backup issues created during rehearsal: `gh issue list --repo OWNER/REPO --label bug-bash --state open`, excluding the ones whose body contains `demo-backup:`. Ask before closing them. Never delete the repository unless the user explicitly asks.
