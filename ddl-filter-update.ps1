# Bulk update of DDL recipient filters to replace Company with Office attributes

# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName EnterEmailHere@contoso.com

# Set the path to your CSV file
$csvPath = "C:\Users\YourUser\Documents\Update_DDL_Groups.csv"

# Set the path to export failed DDL updates
$failLogPath = "C:\Users\YourUser\Documents\Failed_DDL_Groups.csv"

# Define Company-to-Office replacement mapping
$replacements = @{
    'New York'        = 'Queens NY'
    'Pennsylvannia'   = 'Philadelphia PA'
    'California'      = 'Los Angeles CA'
    'North Carolina'  = 'Raleigh NC'
}

# Intialize error tracking list
$failedDDLs = @()

# Import list of Dynamic Distribution Groups (DDLs) from CSV
$ddlList = Import-Csv -Path $csvPath

foreach ($row in $ddlList) {
    $ddl = $row.DDL
    Write-Host "`nProcessing: $ddl" -ForegroundColor Cyan

    # Attempt to retrieve the current DDL group and its recipient filter
    try {
        $group = Get-DynamicDistributionGroup -Identity $ddl -ErrorAction Stop
        $oldFilter = $group.RecipientFilter
    } catch {
        $errMsg = $_.Exception.Message
        Write-Host "Failed to retrieve group ${ddl}:`n$errMsg" -ForegroundColor Red
        $failedDDLs += [PSCustomObject]@{ DDL = $ddl; Error = $errMsg }
        continue
    }

    # Prepare new filter with replacements applied
    $newFilter = $oldFilter
    foreach ($company in $replacements.Keys) {
        $from    = "(Company -eq '$company')"
        $to      = "(Office -eq '$($replacements[$company])')"
        $pattern = "(?i)" + [regex]::Escape($from)  # Case-insensitive match
        $newFilter = $newFilter -replace $pattern, $to
    }

    # Determine if the filter actually changed
    if ($newFilter -ne $oldFilter) {
        Write-Host "Old Filter:`n$oldFilter" -ForegroundColor DarkGray
        Write-Host "New Filter:`n$newFilter" -ForegroundColor Green

        try {
            Set-DynamicDistributionGroup -Identity $ddl -RecipientFilter $newFilter
            Write-Host "Filter updated for $ddl." -ForegroundColor Yellow
        } catch {
            $errMsg = $_.Exception.Message
            Write-Host "Error updating ${ddl}:`n${errMsg}" -ForegroundColor Red
            $failedDDLs += [PSCustomObject]@{ DDL = $ddl; Error = $errMsg }
        }

    } else {
        Write-Host "$ddl skipped: No changes needed." -ForegroundColor Gray
        $unchangedDDLs += [PSCustomObject]@{ DDL = $ddl; Reason = "No changes needed" }
    }
}

# Export failed updates to CSV
if ($failedDDLs.Count -gt 0) {
    $failedDDLs | Export-Csv -Path $failLogPath -NoTypeInformation
    Write-Host "`nFailed updates were saved to: $failLogPath" -ForegroundColor Magenta
} else {
    Write-Host "`nAll groups updated successfully." -ForegroundColor Green
}

# Disconnect session
Disconnect-ExchangeOnline -Confirm:$false

# Optional pause if double-clicked
Read-Host -Prompt "Press Enter to exit"