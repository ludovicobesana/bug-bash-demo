#!/usr/bin/env bash

set -euo pipefail

repository="${1:-}"

if [[ -z "$repository" ]]; then
	echo 'Usage: ./scripts/bootstrap-labels.sh OWNER/REPOSITORY' >&2
	exit 1
fi

create_label() {
	local name="$1"
	local color="$2"
	local description="$3"

	gh label create "$name" \
		--repo "$repository" \
		--color "$color" \
		--description "$description" \
		--force
}

create_label 'bug-bash' '8B5CF6' 'Finding created during a Bug Bash session'
create_label 'needs-triage' 'FBBF24' 'Needs a human triage decision'
create_label 'finding:defect' 'DC2626' 'Confirmed behaviour violates an agreed expectation'
create_label 'finding:risk' 'EA580C' 'Fragile condition or potential harm needs investigation'
create_label 'finding:question' '2563EB' 'Ambiguous behaviour or decision needed'
create_label 'finding:ux' 'DB2777' 'User experience observation needs review'
create_label 'finding:requirement' '7C3AED' 'Missing or unclear product requirement'
create_label 'finding:idea' '059669' 'Potential protection or improvement'
create_label 'decision-needed' '1D4ED8' 'Requires a documented product, delivery, or risk decision'
create_label 'accepted-risk' '6B7280' 'Known risk consciously accepted with owner and review date'
create_label 'charter' '0F766E' 'Exploratory charter or perspective to reuse'

echo "Bug Bash labels are ready in ${repository}."
