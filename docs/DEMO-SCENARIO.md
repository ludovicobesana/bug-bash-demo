# Live-demo scenario

## The prompt

Use the **Checkout recovery** charter from [CHARTER-LIBRARY.md](CHARTER-LIBRARY.md). Simulate an interrupted connection immediately after selecting **Pay**.

## Example finding to submit

| Form field | Demo value |
| --- | --- |
| Finding type | Risk or fragile condition |
| Charter or perspective | Recovery - interrupted checkout |
| What did you observe? | After an interrupted submission, the user can return to checkout and select Pay again while the first payment result is unknown. |
| Why is this interesting or risky? | The user may create a duplicate payment or receive contradictory recovery messages. |
| Evidence and reproducibility | Sandbox account; simulated slow or interrupted network; attach a screenshot or short recording without personal data. |
| Potential impact | High - critical journey, safety, security, legal, privacy, or material financial impact |
| Context | Mobile browser, payment sandbox, existing cart, interrupted network after Pay. |

## Triage choices to demonstrate

Do not decide the outcome before the evidence is discussed. Show that the same observation can lead to different durable outcomes:

| What triage discovers | Appropriate outcome |
| --- | --- |
| The backend creates two charges. | Defect, code fix, regression test. |
| The backend is idempotent but the message is misleading. | UX finding, design change, user-facing copy review. |
| The state is safe but prevalence is unknown. | Telemetry or monitoring. |
| The product behaviour was never specified. | Missing requirement and product decision. |
| Evidence disproves the concern. | Close with the evidence and preserve the learning in the charter notes. |
