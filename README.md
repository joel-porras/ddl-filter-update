# ddl-filter-update

## Overview 
This PowerShell script automates the update of membership rules for Dynamic Distribution List (DDL) in Exchange Online or Entra ID. It reads user-to-location mappings from a CSV and updates the 'RecipientFilter' of DDLs based on condition attributes.

**Features:**
- Case-insensitive matching
- CSV-based batch processing
- Export of failed updates
- Easy to extend for new mappings

$~$

## Purpose:
Reduces manual updates for IT admins and improves consistency in DDL membership rules/recipient filters. The script can be customized to other recipient filters applicable to the DDL groups of your organization. It is designed to be reusable and maintainable for ongoing updates.

$~$

## Prerequistes
- Install Exchange Online Management
- Set-Execution Policy

$~$

## Usage:
**Create CSV File (Ex. Update_DDL_Groups.csv)**

![Capture1](https://github.com/user-attachments/assets/df3d51b3-cae4-44d6-b02e-c71aa2a92eb3)

**Enter email inside script to connect to Exchange Online**

```powershell
# DDL-filter-update.ps1
# ----------------------
#Bulk update of DDL recipient filters to replace Company with Office attribtues

# Connect to Exchange Online
Connect-ExchangeOline -UserPrincipalName EnterEmailHere@contoso.com
```




