# Bug Bash on GitHub: a decision-focused demo

This repository is a small, runnable demonstration of how to configure GitHub for a decision-focused Bug Bash.

It is intentionally not a dashboard or a ticket factory. A Bug Bash is useful when a team needs to investigate a meaningful uncertainty with perspectives it does not otherwise have. GitHub is the shared record for the resulting evidence, triage, and decisions.

## What this demo configures

- A GitHub Issue Form that captures a **finding**, not only a defect.
- Labels that keep findings visible until a human triage decision is made.
- A conservative GitHub Action that posts a triage checklist. It does not create bugs, set priority, close issues, or accept risk automatically.
- A risk map, charter library, and decision-record template for the demo scenario.

## The model

```text
Production signals
        ↓
Risk map → Charter → Finding → Triage decision → Permanent protection
                                                       ↓
                                          test | code | design | telemetry |
                                          requirement | monitoring | accepted risk
```

The output is not “how many bugs did we find?” The output is a decision and, where appropriate, a permanent protection.

## Quick start

1. Create an empty GitHub repository and push this folder as its root.
2. Run the label bootstrap script with a repository where you have write access:

   ```bash
   ./scripts/bootstrap-labels.sh OWNER/REPOSITORY
   ```

3. On GitHub, open **Issues → New issue → Bug Bash finding**.
4. Submit the example from [docs/DEMO-SCENARIO.md](docs/DEMO-SCENARIO.md).
5. Watch the `Triage new Bug Bash finding` workflow post its deliberately limited prompt.
6. During triage, assign a finding type and an outcome label. Record material decisions using [docs/DECISION-RECORD.md](docs/DECISION-RECORD.md).

The form's automatic labels appear only after labels have been created in the target repository. GitHub does not create missing labels when a form is submitted.

## Five-minute live demo

| Time | Action | Point to make |
| --- | --- | --- |
| 0:00 | Show [the risk map](docs/RISK-MAP.md). | We start from uncertainty, not “everyone test the product.” |
| 0:45 | Show [the charter library](docs/CHARTER-LIBRARY.md). | A charter gives direction without pre-deciding the experiment. |
| 1:30 | Open the Bug Bash finding form. | A finding can be a risk, question, UX observation, or missing requirement - not only a defect. |
| 2:30 | Submit the checkout recovery scenario. | Capture evidence while the participant is thinking; do not require a full Jira ticket. |
| 3:15 | Open the automatic triage comment. | Automation helps preserve the question; a person still owns the decision. |
| 4:00 | Apply an outcome label and fill a decision record. | The durable output may be code, a test, telemetry, design, a requirement, or accepted risk. |
| 4:45 | Return to the risk map. | Production and triage update the next set of charters. |

## Repository structure

```text
.github/
  ISSUE_TEMPLATE/
    bug-bash-finding.yml        # Structured finding capture
    config.yml                  # Template chooser configuration
  workflows/
    triage-bug-bash-finding.yml # Conservative triage prompt
docs/
  RISK-MAP.md
  CHARTER-LIBRARY.md
  DECISION-RECORD.md
  DEMO-SCENARIO.md
scripts/
  bootstrap-labels.sh
```

## What the workflow deliberately does not do

- It does not turn every finding into a bug.
- It does not infer priority or severity from a form answer.
- It does not assign an owner, close an issue, or accept residual risk.
- It does not use finding text as shell input.

Those are decision and accountability questions, not safe automation defaults.

## Adapt it to a real product

1. Replace the example risk map with a product-specific risk inventory.
2. Use production incidents, support tickets, analytics, and observability as charter inputs.
3. Keep charters focused on a risk and an intended learning outcome, rather than a list of clicks.
4. Agree who participates in triage and who can accept residual risk.
5. Review whether findings changed decisions or created durable protections. Do not rank a Bug Bash by bug count.

## Sources

- [GitHub Issue Form syntax](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms)
- [GitHub Actions `issues` event](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows)
- [GitHub Actions permissions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax)
- [Managing labels](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels)

The Bug Bash method in this demo is a teaching template. It must be adapted to the product, its users, the decision at stake, and the relevant safety, privacy, accessibility, and compliance constraints.

https://www.aaronspencer.com/projects

