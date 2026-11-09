# Reproduction Guide & Operational Safety

[← Back to README](../README.md) · [Evidence index](Evidence-Index.md)

## Scope

This repository is a **record of a completed lab**, not a deployment package for a real IAM program. The retained script is the exact user-provided version from `IAM-Governance-Portfolio.zip`. The provided CSV files capture the exercise's original role model, simulated approval evidence, and before/after reports.

## Prerequisites

- An **isolated, disposable test Active Directory domain**, with domain administration permissions as appropriate for the lab.
- Windows PowerShell and the ActiveDirectory module available on the test host.
- A test OU equivalent to `OU=TetsaLab,DC=corp,DC=tetsalab,DC=test`, containing fictional enabled and disabled users.
- Existing AD test groups named `APP_Expenses_Requester` and `APP_Expenses_Approver`.
- A local test directory `C:\Lab\IAM-Governance` containing the two role CSV files and `Find-IAMAccessFindings.ps1`.

## Important setup note

The script has a hard-coded `$Root` and AD `$Base` at the top and queries AD live. It cannot produce authentic new results from the bundled CSVs alone. To run against a different disposable lab domain, **review and edit both variables**, ensuring all users and groups belong to your test environment. Do not execute it against a production domain without an independent technical and authorization review.

```powershell
# Read-only with respect to Active Directory.
# Replaces local access-review-findings.csv each run.
& "C:\Lab\IAM-Governance\Find-IAMAccessFindings.ps1"
```

## Demonstrated workflow

| Stage | Captured artifact |
|---|---|
| Define access policy | `data/policy/role-access-matrix.csv` |
| Map employees | `data/policy/employee-role-assignments.csv` |
| Validate requests and simulated approvals | `data/requests/` |
| Establish clean AATR baselines | `data/reviews/` |
| Introduce controlled test exceptions | Screenshot 13 |
| Detect exceptions | `data/findings/pre-remediation-findings.csv` |
| Record fictional remediation decisions | `data/requests/remediation-approvals.csv` |
| Preview and perform test remediation | Screenshots 17 and 18 |
| Retest | `data/findings/post-remediation-findings.csv`, Screenshot 19b |

## Technical limits of original detector

- Enumerates **direct** user membership only; does not expand nested groups or evaluate effective access.
- Checks two simulated expense entitlement groups, not every application, share, privileged account, or AD group.
- Detects in-scope unexpected/missing expense membership; it does not comprehensively flag unexpected membership in other departmental security groups.
- Matches roles by local CSV data; there is no HRIS truth source, cryptographic approvals, timestamp-based audit trail, or immutable event evidence.
- Risk ratings are fixed demonstration labels; they are not derived from a formal risk scoring model.
- An SoD finding records conflicting group membership **under the fictional policy**; no expense approval workflow was exercised in a real application.
- On an empty finding set, the script deliberately writes a header-only CSV; `Import-Csv` correctly reads zero data rows.

## Production-oriented extensions (not implemented)

1. Enumerate effective and nested group access, cross-domain groups, and privileged group membership.
2. Validate employee role, enabled state, department, and OU against an authoritative HR identity source.
3. Store authenticated approvals, time stamps, request identifiers, and execution events in an approved ITSM/IAM system.
4. Add deterministic IDs and formal per-finding closure state; support multiple simultaneous finding types for a single user.
5. Add Pester tests and safer script parameters for paths, search scope, fail-closed behavior, and noninteractive execution.
6. Implement recurring reviews and access owner recertification with documented exceptions.

## Publication and privacy

All account names, group names, request IDs, and approver roles in these files are fictional. Do not add real credentials, tokens, personal records, internal employee data, or private client configurations. This packaged version contains no VM disks or service secrets. Before using any command in another environment, confirm which domain is connected and the effects of the command.
