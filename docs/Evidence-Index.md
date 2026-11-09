# Screenshot Evidence Index

[← Back to README](../README.md) · [Final audit report](Final-IAM-Governance-Audit-Report.md)

Each image was captured from the isolated lab, except where noted as recovered from previously uploaded screenshots. Numbering follows the chronological lab workflow; `19b` is an additional final verification capture.

| Screenshot | Evidence captured | Section |
|---|---|---|
| [`01-active-directory-user-baseline.png`](../screenshots/01-active-directory-user-baseline.png) | Initial active-user identity inventory | Identity inventory |
| [`02-complete-iam-user-inventory.png`](../screenshots/02-complete-iam-user-inventory.png) | All nine identities including disabled Sales account | Identity inventory |
| [`03-approved-role-access-matrix.png`](../screenshots/03-approved-role-access-matrix.png) | Five-role approved fictional access matrix | RBAC policy |
| [`04-application-entitlement-groups.png`](../screenshots/04-application-entitlement-groups.png) | Requester and Approver Global Security groups | Entitlement setup |
| [`05-employee-role-assignment-validation.png`](../screenshots/05-employee-role-assignment-validation.png) | Eight employees mapped to required roles and entitlements | Role assignments |
| [`06-iam-access-request-validation.png`](../screenshots/06-iam-access-request-validation.png) | Three requests pending; each policy matched | Request validation |
| [`07-iam-management-approval-validation.png`](../screenshots/07-iam-management-approval-validation.png) | Three explicitly simulated provisioning approval decisions | Approval simulation |
| [`08-approved-access-provisioning-whatif.png`](../screenshots/08-approved-access-provisioning-whatif.png) | Three proposed membership changes with -WhatIf | Provisioning preview |
| [`09-approved-access-provisioning-verification.png`](../screenshots/09-approved-access-provisioning-verification.png) | Three authorized group memberships after provisioning | Provisioning verification |
| [`10-initial-aatr-access-review.png`](../screenshots/10-initial-aatr-access-review.png) | Eight users passed in-scope AATR checks | Clean AATR baseline |
| [`11-disabled-account-access-review.png`](../screenshots/11-disabled-account-access-review.png) | Nine accounts assessed for stale/unassigned direct app access | Account coverage |
| [`12-iam-security-findings-whatif.png`](../screenshots/12-iam-security-findings-whatif.png) | Three deliberately introduced exceptions previewed | Negative test preparation |
| [`13-controlled-iam-security-findings.png`](../screenshots/13-controlled-iam-security-findings.png) | Six expense group memberships including known exceptions | Negative test validation |
| [`14-automated-iam-security-findings.png`](../screenshots/14-automated-iam-security-findings.png) | Detection script flagged 3 findings | Automated detection |
| [`15-iam-security-findings-detailed-review.png`](../screenshots/15-iam-security-findings-detailed-review.png) | Actual versus expected group entitlements and corrective actions | Findings investigation |
| [`16-iam-remediation-approval-validation.png`](../screenshots/16-iam-remediation-approval-validation.png) | Three simulated remediation authorizations validated against finding records | Remediation authorization |
| [`17-iam-remediation-whatif.png`](../screenshots/17-iam-remediation-whatif.png) | Three removal commands previewed | Remediation preview |
| [`18-iam-access-remediation-verification.png`](../screenshots/18-iam-access-remediation-verification.png) | Approved memberships restored; disabled account remains disabled | Remediation verification |
| [`19-final-iam-aatr-validation.png`](../screenshots/19-final-iam-aatr-validation.png) | Preserved pre-remediation count 3 and post-remediation count 0 | CSV comparison |
| [`19b-final-iam-detection-validation.png`](../screenshots/19b-final-iam-detection-validation.png) | Fresh detection run, 3-to-0 comparison, PASSED | Final automated validation |
| [`20-iam-governance-audit-evidence-inventory.png`](../screenshots/20-iam-governance-audit-evidence-inventory.png) | 10 expected evidence files all present on DC01 | Evidence inventory |

**Provenance note:** Files `07-iam-management-approval-validation.png` and `11-disabled-account-access-review.png` were missing from the uploaded `Screenshots.zip`, so the images were recovered from screenshots provided earlier in the same project conversation. All approvals shown are simulated, not authenticated management sign-offs.

**Capture/quality note:** Screenshot 19 demonstrates the CSV counts, while Screenshot 19b also shows the fresh review execution and `Validation Status: PASSED`. Use 19b as the primary final-verification image in recruiter-facing summaries.
