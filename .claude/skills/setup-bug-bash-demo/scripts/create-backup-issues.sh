#!/usr/bin/env bash
# Create (or reuse) the two backup issues used during the live demo.
#   A: freshly submitted finding, waits for the triage workflow comment.
#   B: same finding, already triaged, with a decision record comment.

set -euo pipefail

repository="${1:-}"

if [[ -z "$repository" ]]; then
	echo 'Usage: create-backup-issues.sh OWNER/REPOSITORY' >&2
	exit 1
fi

title='[Bug Bash] Second Pay possible while first payment result is unknown'

finding_body() {
	local marker="$1"

	cat <<EOF
<!-- demo-backup:${marker} -->
### Finding type

Risk or fragile condition

### Charter or perspective

Recovery - interrupted checkout

### What did you observe?

After an interrupted submission, the user can return to checkout and select Pay again while the first payment result is unknown.

### Why is this interesting or risky?

The user may create a duplicate payment or receive contradictory recovery messages.

### Evidence and reproducibility

Environment: payment sandbox, sandbox account
Steps: add items to cart, select Pay, interrupt the network immediately, return to checkout
Observed result: Pay is enabled again while the first payment is still pending
Evidence attached: none (teaching scenario)

### Potential impact if confirmed

High - critical journey, safety, security, legal, privacy, or material financial impact

### Context

Mobile browser, payment sandbox, existing cart, interrupted network after Pay.

### Before submitting

- [X] I captured an observation and evidence rather than only a conclusion.
- [X] I did not include secrets, personal data, or real customer data.
EOF
}

find_issue() {
	local marker="$1"

	gh issue list --repo "$repository" --state all --label bug-bash --limit 100 \
		--json number,body \
		--jq "map(select(.body | contains(\"demo-backup:${marker}\"))) | .[0].number // empty"
}

ensure_issue() {
	local marker="$1"
	shift
	local number

	number="$(find_issue "$marker")"
	if [[ -n "$number" ]]; then
		echo "Reusing issue ${marker}: #${number}" >&2
	else
		number="$(finding_body "$marker" | gh issue create --repo "$repository" \
			--title "$title" --body-file - --label bug-bash --label needs-triage "$@" |
			sed -E 's#.*/issues/([0-9]+).*#\1#')"
		echo "Created issue ${marker}: #${number}" >&2
	fi
	echo "$number"
}

wait_for_triage_comment() {
	local number="$1"
	local attempt

	for attempt in $(seq 1 24); do
		if gh api "repos/${repository}/issues/${number}/comments" \
			--jq 'any(.[]; .body | contains("## Bug Bash triage"))' | grep -q true; then
			return 0
		fi
		sleep 5
	done
	return 1
}

issue_a="$(ensure_issue A)"

if wait_for_triage_comment "$issue_a"; then
	echo "Triage comment present on #${issue_a}." >&2
	triage_ok=true
else
	echo "No triage comment on #${issue_a} after 2 minutes. Check the workflow runs." >&2
	triage_ok=false
fi

issue_b="$(ensure_issue B)"

gh issue edit "$issue_b" --repo "$repository" \
	--add-label 'finding:risk' --add-label 'decision-needed' --remove-label 'needs-triage' >/dev/null

if ! gh api "repos/${repository}/issues/${issue_b}/comments" \
	--jq 'any(.[]; .body | contains("Quality Decision Record"))' | grep -q true; then
	gh issue comment "$issue_b" --repo "$repository" --body-file - >/dev/null <<'EOF'
## Quality Decision Record

> Teaching example only. It is not a production approval.

| Field | Decision |
| --- | --- |
| Context | Release of the revised checkout recovery flow. |
| Risk | Duplicate payment or contradictory recovery state after an interrupted Pay. |
| Evidence | Reproduced once in a sandbox after interrupting connectivity; backend idempotency is still unconfirmed. |
| Alternatives | Ship as is and monitor (rejected: impact too high); disable retry entirely (rejected: blocks legitimate recovery). |
| Decision | Hold release of the changed recovery UI until payment state is made explicit and duplicate-submit behaviour is verified. |
| Durable outcome | Design (explicit pending state) · Test (integration test for duplicate submit) · Telemetry (payment-state events) |
| Authority | Checkout Product Manager |
| Owner | Checkout Engineering Lead |
| Residual risk | The provider's delayed webhook behaviour has not been tested under all regional conditions. |
| Review date | Before the next release candidate. |
EOF
	echo "Decision record added to #${issue_b}." >&2
fi

echo "ISSUE_A=https://github.com/${repository}/issues/${issue_a}"
echo "ISSUE_B=https://github.com/${repository}/issues/${issue_b}"
echo "TRIAGE_COMMENT_OK=${triage_ok}"
