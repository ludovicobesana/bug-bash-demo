# Risk map: checkout recovery

> Teaching scenario only. It does not describe a real product or release.

## Decision

Can we release a revised checkout flow without creating inconsistent order or payment state when a user is interrupted?

## Why a Bug Bash is justified

| Dimension | Assessment | Why it matters |
| --- | --- | --- |
| Impact | High | A duplicate payment, lost order, or misleading recovery state harms a critical user journey. |
| Uncertainty | High | Automated happy-path coverage does not settle recovery after network, navigation, or state interruption. |
| Distributed knowledge | High | Engineering knows retries and idempotency; Design knows user-facing state; Support knows real recovery behaviour; Product owns the intended promise. |

## Known coverage

- Payment success and decline paths are covered by automated end-to-end tests.
- Coupon validation and order creation have integration coverage.
- The following uncertainty remains intentionally in scope: recovery after interruption, state across tabs, and whether the UI communicates uncertainty honestly.

## Risk inventory

| Risk | Critical journey | Evidence needed | Current blind spot |
| --- | --- | --- | --- |
| Duplicate payment after retry | Checkout recovery | Browser state, request evidence, user-facing status | The first payment may remain pending while the user retries. |
| Missing order after apparent success | Checkout recovery | Order history, confirmation state, eventual consistency behaviour | A user may see a message that does not explain what to do next. |
| Conflicting state across tabs | Checkout | Session/state behaviour and UI consistency | Separate tabs may expose different truths. |
| Recovery inaccessible on mobile | Checkout recovery | Keyboard, screen-reader, viewport, and network evidence | A technically valid recovery may still be unusable. |

## Out of scope

- Re-running already-covered happy-path payment scenarios.
- Load testing or payment-provider certification.
- Testing with real payment details or customer data.
