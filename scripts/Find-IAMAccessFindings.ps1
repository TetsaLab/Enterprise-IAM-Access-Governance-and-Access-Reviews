
# Enterprise IAM Access Governance Lab
# Automated access review and security findings detection
# READ-ONLY: No Active Directory permissions are modified.

$ErrorActionPreference = "Stop"

$Root = "C:\Lab\IAM-Governance"
$Base = "OU=TetsaLab,DC=corp,DC=tetsalab,DC=test"

$Matrix = @(
    Import-Csv "$Root\role-access-matrix.csv"
)

$Assignments = @(
    Import-Csv "$Root\employee-role-assignments.csv"
)

$ExpenseGroups = @(
    "APP_Expenses_Requester",
    "APP_Expenses_Approver"
)

# Collect all lab accounts, including disabled users.

$Users = @(
    Get-ADUser -Filter * -SearchBase $Base `
        -Properties Enabled,Department
)

# Collect direct application entitlement memberships.

$Memberships = @(
    foreach ($Group in $ExpenseGroups) {

        $Members = Get-ADGroupMember -Identity $Group |
            Where-Object ObjectClass -eq "user"

        foreach ($Member in $Members) {

            [PSCustomObject]@{
                Username    = $Member.SamAccountName
                Entitlement = $Group
            }
        }
    }
)

# Compare actual access with approved role requirements.

$Findings = @(
    foreach ($User in $Users) {

        $ActualAccess = @(
            $Memberships |
                Where-Object Username -eq $User.SamAccountName |
                Select-Object -ExpandProperty Entitlement
        )

        $ActualText = if ($ActualAccess.Count -gt 0) {
            $ActualAccess -join "; "
        }
        else {
            "None"
        }

        $AssignedRole = @(
            $Assignments |
                Where-Object SamAccountName -eq $User.SamAccountName
        )

        # IAM-003: Disabled account retaining an entitlement.

        if (-not $User.Enabled) {

            if ($ActualAccess.Count -gt 0) {

                [PSCustomObject]@{
                    FindingID         = "IAM-003"
                    Username          = $User.SamAccountName
                    FindingType       = "Stale Entitlement"
                    Risk              = "Medium"
                    ActualAccess      = $ActualText
                    ExpectedAccess    = "None"
                    RecommendedAction = "Review and remove retained entitlement"
                }
            }

            continue
        }

        # An active user with no assigned role should not
        # hold these application entitlements.

        if ($AssignedRole.Count -ne 1) {

            if ($ActualAccess.Count -gt 0) {

                [PSCustomObject]@{
                    FindingID         = "IAM-001"
                    Username          = $User.SamAccountName
                    FindingType       = "Unassigned Access"
                    Risk              = "Medium"
                    ActualAccess      = $ActualText
                    ExpectedAccess    = "None"
                    RecommendedAction = "Investigate role and authorization"
                }
            }

            continue
        }

        $Policy = @(
            $Matrix |
                Where-Object JobRole -eq $AssignedRole[0].JobRole
        )

        if ($Policy.Count -ne 1) {
            throw "Missing or duplicate role policy for $($User.SamAccountName)"
        }

        $ExpectedAccess = $Policy[0].ApplicationEntitlement

        # IAM-002: Separation-of-duties conflict.

        $IsRequester = $ActualAccess -contains "APP_Expenses_Requester"
        $IsApprover  = $ActualAccess -contains "APP_Expenses_Approver"

        if ($IsRequester -and $IsApprover) {

            [PSCustomObject]@{
                FindingID         = "IAM-002"
                Username          = $User.SamAccountName
                FindingType       = "SoD Conflict"
                Risk              = "High"
                ActualAccess      = $ActualText
                ExpectedAccess    = $ExpectedAccess
                RecommendedAction = "Review and remove conflicting entitlement"
            }

            continue
        }

        # IAM-001: Access outside the approved job role.

        $Unexpected = @(
            $ActualAccess |
                Where-Object { $_ -ne $ExpectedAccess }
        )

        if ($Unexpected.Count -gt 0) {

            [PSCustomObject]@{
                FindingID         = "IAM-001"
                Username          = $User.SamAccountName
                FindingType       = "Excessive Access"
                Risk              = "Medium"
                ActualAccess      = $ActualText
                ExpectedAccess    = if ($ExpectedAccess) {
                    $ExpectedAccess
                } else {
                    "None"
                }
                RecommendedAction = "Review and remove unauthorized access"
            }
        }

        # IAM-004: Missing entitlement required by role.

        if ($ExpectedAccess -and
            $ActualAccess -notcontains $ExpectedAccess) {

            [PSCustomObject]@{
                FindingID         = "IAM-004"
                Username          = $User.SamAccountName
                FindingType       = "Missing Access"
                Risk              = "Low"
                ActualAccess      = $ActualText
                ExpectedAccess    = $ExpectedAccess
                RecommendedAction = "Review authorized provisioning request"
            }
        }
    }
)

# Save the audit report and display a concise summary.

$Findings = @($Findings | Sort-Object FindingID,Username)

$ReportPath = "$Root\access-review-findings.csv"

if ($Findings.Count -gt 0) {
    $Findings | Export-Csv `
        -Path $ReportPath `
        -NoTypeInformation -Encoding UTF8
}
else {
    "FindingID,Username,FindingType,Risk,ActualAccess,ExpectedAccess,RecommendedAction" |
        Set-Content -Path $ReportPath -Encoding UTF8
}

$Findings |
    Select-Object FindingID,Username,FindingType,Risk |
    Format-Table -AutoSize

Write-Host "Total findings detected: $($Findings.Count)"
Write-Host "Audit report: $Root\access-review-findings.csv"
