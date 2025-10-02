# ddl-filter-update

## Overview 
This PowerShell script automates the update of membership rules for Dynamic Distribution List (DDL) in Exchange Online or Entra ID. It reads user-to-location mappings from a CSV and updates the 'RecipientFilter' of DDLs based on conditional attributes.

**Features:**
- Case-insensitive matching
- CSV-based batch processing
- Export of failed updates
- Easy to extend for new mappings



## Purpose:
Reduces manual updates for IT admins and improves consistency in DDL membership rules/recipient filters. The script can be customized to other recipient filters applicable to the DDL groups of your organization. It is designed to be reusable and maintainable for ongoing updates.



## Prerequistes
- Install Exchange Online Management
- Set-Execution Policy



## Usage:
### Create CSV File (Ex. Update_DDL_Groups.csv)

![Capture1](https://github.com/user-attachments/assets/df3d51b3-cae4-44d6-b02e-c71aa2a92eb3)

### Enter email inside script to connect to Exchange Online
```Powershell
#Bulk update of DDL recipient filters to replace Company with Office attribtues

# Connect to Exchange Online
Connect-ExchangeOline -UserPrincipalName EnterEmailHere@contoso.com
```

### Copy and paste folder path to CSV file created for DDL groups to be updated
```Powershell
# Set the path to your CVS file
$csvPath = "C:\Users\YourUser\Path\Update_DDL_Groups.csv"
```

### Copy and paste folder path to export CSV file to for failed updates on DDL groups
```Powershell
# Set the path to export failed DDL updates
$failLogPath = "C:\Users\YourUser\Path\Failed_DDL_Groups.csv"
```

### Review and update mapping inside the script under `$replacements`
Example attributes provided:
- Left Column: Company attributes
- Right Column: Office attributes
```Powershell
# Define Company-to-Office replacement mapping
$replacements = @{
    'New York'        = 'Queens NY'
    'Pennsylvannia'   = 'Philadelphia PA'
    'California'      = 'Los Angeles CA'
    'North Carolina'  = 'Raleigh NC'
}
```


### Run Powershell Script
```Powershell
cd "C:\Enter\Path\To\Sript\Here"
.\ddl-filter-update.ps1
```

$~$


## Sample Output Results
### DDL Successful Updates
![Capture2](https://github.com/user-attachments/assets/2a3b6e61-af1c-496d-8f71-8c240e4f3db9)

### "No changes needed" message
![Capture3](https://github.com/user-attachments/assets/486b9481-c444-4faa-aa13-f28e3bcb9529)

### Failed updates on DDL groups exported to CSV 
![Capture4](https://github.com/user-attachments/assets/d8793203-f5b7-4de5-a3bf-2c7065fe3843)


