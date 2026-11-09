# Enterprise IAM Access Governance & Role-Based Access Review

## Final Lab Audit Report

[← Back to project README](../README.md) · [Evidence index](Evidence-Index.md)

**Assessment type:** Controlled home-lab IAM governance exercise  
**Environment:** VMware Workstation, Windows Server 2025, Active Directory Domain Services, PowerShell  
**Domain:** `corp.tetsalab.test`  
**Assessment scope:** Nine lab user accounts, five defined job roles, four departmental security groups, and two simulated expense-application entitlements  
**Status:** Completed — in-scope findings remediated and validation passed  
**Important qualification:** All employee identities, manager decisions, access requests, and application entitlements in this exercise are fictional. The expense entitlements are represented by Active Directory security groups, not a connected expense application.

---

## 1. Executive Summary

This project simulated an enterprise Identity and Access Management (IAM) governance review, emphasizing Access Appropriate to Role (AATR), role-based access control (RBAC), least privilege, separation of duties (SoD), offboarding, and audit evidence.

A clean access baseline was established for eight enabled employees and one disabled employee. The exercise then deliberately introduced three known access-control exceptions into the isolated Active Directory lab. A PowerShell detection script identified all three exceptions. Following fictional, explicitly labelled *simulated* remediation approvals, the three unauthorized or conflicting memberships were removed. The script was rerun and reported zero remaining findings within the defined scope.

| Metric | Verified lab result |
|---|---:|
| Accounts in lab inventory | 9 |
| Enabled accounts with role assignments | 8 |
| Disabled accounts | 1 |
| Simulated expense application entitlement groups | 2 |
| Intentionally introduced findings | 3 |
| Findings after remediation | 0 |
| Remediation of deliberately introduced findings | 3 of 3 (100%) |

**Overall conclusion:** The defined review and remediation workflow successfully detected and resolved all three deliberately introduced direct-membership exceptions. This result is **not** a certification of enterprise-wide access compliance or proof that a real application's authorization controls were tested.

## 2. Scope and Environment

The assessment used the existing `corp.tetsalab.test` domain on domain controller `DC01`. The established organizational structure included departmental OUs and security groups for IT, HR, Finance, and Sales; a separate `DisabledUsers` OU; and a domain-joined Windows 11 test workstation, `CLIENT01`.

The two new security groups were:

- `APP_Expenses_Requester` — simulated expense submission entitlement.
- `APP_Expenses_Approver` — simulated expense approval entitlement.

The approved role-access matrix documented five roles: IT-Support, HR-Generalist, Finance-Requester, Finance-Approver, and Sales-Representative. Eight active users were mapped to job roles; the disabled user, `cameron.davis`, was deliberately excluded from active role assignments.

**Scope boundaries:** The automated check examines direct user memberships in these two simulated application groups and compares them with the CSV role assignments. It does not calculate nested/effective access, enumerate all AD groups or other applications, prove application-layer authorization, or validate real managerial identities or approvals.

## 3. Governance Review Methodology

1. **Identity inventory:** Queried the full TetsaLab OU and verified eight enabled accounts and one disabled account.
2. **Role definition:** Created `role-access-matrix.csv`, specifying departmental groups, simulated application entitlements, and designated approval-owner roles.
3. **Role assignment:** Created `employee-role-assignments.csv` for all eight active employees and validated their policy mapping.
4. **Request and approval separation:** Recorded three fictional access requests and validated separate simulated approval records. Policy eligibility was distinguished from approval.
5. **Provisioning:** Previewed group additions using `-WhatIf`, added approved lab memberships, and independently verified the three authorized user-to-group assignments.
6. **Initial AATR review:** Verified the assigned users' enabled status, department, required departmental group, simulated application entitlement, and SoD rule. All eight passed those defined checks.
7. **Account coverage review:** Examined all nine accounts for disabled-user entitlement retention and expense-group membership without a role assignment. The initial baseline had no such direct memberships.
8. **Controlled negative tests:** Deliberately introduced three known direct-membership exceptions, then independently confirmed the resulting group membership state.
9. **Detection:** Executed `Find-IAMAccessFindings.ps1` to compare observed expense-group memberships with the approved role model and export a findings report.
10. **Simulated authorization and remediation:** Recorded fictional remediation-approval decisions, validated their correspondence to findings and group memberships, previewed removals with `-WhatIf`, then removed the three test exceptions.
11. **Retest:** Verified the restored group memberships and disabled account status, reran the script, and compared preserved pre-remediation findings with post-remediation results.

## 4. Findings and Risk Assessment

| Finding | User | Observed condition | Expected condition | Illustrative lab risk |
|---|---|---|---|---|
| **IAM-001 — Excessive Access** | `jordan.lee` | IT user directly assigned `APP_Expenses_Approver` | No expense entitlement | Medium |
| **IAM-002 — SoD Conflict** | `morgan.patel` | Finance user held both Requester and Approver | Approver only | High |
| **IAM-003 — Stale Entitlement** | `cameron.davis` | Disabled Sales account retained `APP_Expenses_Requester` | No expense entitlement; account disabled | Medium |

### IAM-001 — Inappropriate cross-department access

The approved `IT-Support` role required `GG_IT_Users` but no expense-application group. Direct membership in `APP_Expenses_Approver` was inconsistent with the approved role matrix. **Lab response:** Record a fictional Finance Director authorization, remove the expense approval group membership, and verify absence from that group.

### IAM-002 — Separation-of-duties conflict

The approved `Finance-Approver` role required the Approver entitlement only. Concurrent Requester and Approver memberships conflicted with the lab's simulated SoD rule. **Lab response:** Record fictional Finance Manager authorization; remove the Requester membership while retaining the approved Approver membership.

### IAM-003 — Incomplete offboarding entitlement cleanup

The account was disabled but retained direct membership in `APP_Expenses_Requester`. Although account disablement ordinarily prevents new domain authentication, retained membership represented incomplete entitlement cleanup under the lab policy. **Lab response:** Record fictional Finance Manager authorization; remove the expense-group membership and confirm the account remains disabled.

**Risk rating note:** Medium/High classifications were illustrative learning assumptions. They are not enterprise-approved risk scores and were not calculated using a formal likelihood/impact model.

## 5. Remediation and Independent Validation

The three remediation commands removed only the specific excess memberships. Post-change verification showed:

- `APP_Expenses_Requester`: `avery.johnson`, `casey.brooks`.
- `APP_Expenses_Approver`: `morgan.patel`.
- `jordan.lee`: no longer in the expense Approver group.
- `morgan.patel`: no longer in the Requester group, while remaining an Approver.
- `cameron.davis`: absent from the expense Requester group and still `Enabled = False`.

The automated PowerShell review subsequently returned **`Total findings detected: 0`**. The preserved pre-remediation CSV contained **3 findings**, and the final report contained **0 finding rows**. The final verification output displayed **`Validation Status: PASSED`**.

**Result:** 3 of 3 intentionally introduced findings remediated in the scope tested. No claim is made about permissions outside the two simulated expense entitlement groups.

## 6. Control Observations

| Control area | What the lab demonstrated | Limitation |
|---|---|---|
| RBAC / AATR | Compared direct group memberships to approved role-entitlement requirements | CSV role model is a simulation, not an organizational source of truth |
| Least privilege | Detected and removed cross-role excess access | Other groups and inherited/nested access not assessed |
| SoD | Flagged simultaneous Requester and Approver memberships | No real expense transaction workflow or application enforcement tested |
| Joiner–mover–leaver | Used existing account lifecycle outcomes and validated disabled-user entitlement cleanup | No production HRIS/ITSM integration |
| Authorization | Separated request eligibility, fictional approver decisions, provisioning, and remediation | Simulated approvals were not authenticated decisions by real managers |
| Audit readiness | Retained policies, access review results, findings, approval records, script, and before/after evidence | Files prove a lab workflow, not an independent external audit |

## 7. Recommendations and Lessons Learned

1. Maintain a version-controlled owner-approved role and entitlement catalog, including explicit exceptions.
2. Review both missing and excessive access; a role-based review should not only check that required permissions are present.
3. Assess nested group memberships, privileged groups, and effective application permissions in a future lab extension.
4. Use immutable or centrally managed approval/audit records in a production process; a locally editable CSV is suitable only for simulation.
5. Include approval identity, timestamps, request IDs, evidence of change execution, and post-change verification for production-grade audit trails.
6. Review disabled and unassigned accounts separately so they are not omitted by active-user-focused reports.
7. Preserve baseline and pre-remediation reports before rerunning scripts that overwrite current output.
8. Add a repeatable exception-remediation checklist and periodic recertification cadence to improve consistency.

## 8. Evidence Inventory

The final evidence check reported **`Exists = True` for all ten expected files** on `DC01` under `C:\Lab\IAM-Governance`:

| File | Role |
|---|---|
| `role-access-matrix.csv` | Approved fictional role-to-access policy |
| `employee-role-assignments.csv` | Eight active employee job-role assignments |
| `access-requests.csv` | Fictional access requests |
| `approval-decisions.csv` | Simulated initial provisioning approvals |
| `initial-access-review.csv` | Initial active-user AATR baseline |
| `initial-account-coverage.csv` | Initial all-account coverage baseline |
| `pre-remediation-findings.csv` | Preserved three-finding report |
| `remediation-approvals.csv` | Simulated remediation approvals |
| `post-remediation-findings.csv` | Header-only CSV indicating zero findings rows |
| `Find-IAMAccessFindings.ps1` | Read-only AD detection logic; generates local CSV evidence |

**Key screenshots:** `10-initial-aatr-access-review.png`, `11-disabled-account-access-review.png`, `13-controlled-iam-security-findings.png`, `14-automated-iam-security-findings.png`, `15-iam-security-findings-detailed-review.png`, `16-iam-remediation-approval-validation.png`, `17-iam-remediation-whatif.png`, `18-iam-access-remediation-verification.png`, `19b-final-iam-detection-validation.png`, and `20-iam-governance-audit-evidence-inventory.png`. Earlier screenshots `01`–`09` document preparation, policy and role design, access requests, approvals, and provisioning.

*Before publication, transfer the original evidence files from the VM, review for sensitive data, and confirm that each screenshot filename matches the actual exported file. The inventory screenshot verifies existence, not the integrity or completeness of every file's contents.*

## 9. Final Conclusion

The controlled exercise completed a full lab IAM governance cycle: **inventory → role mapping → fictional request and approval → provisioning → access review → controlled exception detection → simulated remediation authorization → group remediation → independent validation → evidence retention**.

The PowerShell process identified the three known direct-membership violations, and the final validation showed zero remaining in-scope findings. The work demonstrates practical IAM governance concepts relevant to junior IAM operations, IT controls, and access-review support roles, while clearly distinguishing simulated controls from enterprise production experience.


---

**Source and integrity note:** The CSVs and PowerShell script in this repository were transferred from the lab VM. Screenshot 07 and Screenshot 11 were recovered from prior screenshots shared in the project conversation because they were absent from the supplied screenshots ZIP. The summary and report are explanatory documentation created after the lab; no production access approvals were obtained.
