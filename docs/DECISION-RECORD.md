# Quality Decision Record

Use this record when a Bug Bash finding changes a release, product, risk, or operational decision. Do not create it for every observation.

```text
Context: What is being decided, and why now?
Finding: Link to the Bug Bash finding.
Risk: What harm or uncertainty is under discussion?
Evidence: What confirms, weakens, or limits the finding?
Alternatives: What options were considered and rejected?
Decision: What will happen now?
Durable outcome: Code | Test | Design | Telemetry | Monitoring | Requirement | Documentation | Accepted risk
Authority: Who can make this decision?
Owner: Who is responsible for the next action?
Residual risk: What remains knowingly uncovered?
Review date: When must this be reconsidered?
Observed result: What happened after the decision?
```

## Example: checkout retry

> Teaching example only. It is not a production approval.

| Field | Example |
| --- | --- |
| Finding | A retry can be submitted while the first payment is pending. |
| Evidence | Reproduced once in a sandbox after interrupting connectivity; backend idempotency is still unconfirmed. |
| Decision | Hold release of the changed recovery UI until payment state is made explicit and duplicate-submit behaviour is verified. |
| Durable outcome | UI change, integration test, and payment-state telemetry. |
| Owner | Checkout Engineering Lead. |
| Residual risk | The provider's delayed webhook behaviour has not been tested under all regional conditions. |
| Review date | Before the next release candidate. |
