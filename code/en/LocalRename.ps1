<# This script is useful for testing locally from your PowerShell PC as an administrator. #>

$ComputerName = $env:COMPUTERNAME
$add = $ComputerName

foreach ($Name in $add)     # For each name in the list, do...
{
    $User = $Name -replace '^@{Name=|}' # Variable necessary to remove unnecessary characters from the names (This line may not be necessary for you)

    if ($User -match 'EXE-PC-' -or $User -match 'POS-PC-')  # If the computer name starts with "EXE-PC-" or "POS-PC-", execute the if block
    {
        if ($User.Length -gt 15) {  # Restrict the number of characters to a maximum of 15 and remove additional characters
            $User = $User.Substring(0, 15)
            Rename-Computer -ComputerName $User -NewName $NewName -DomainCredential $Cred -Force #-Restart
            Write-Verbose "INFO: The computer $User doesn't need to change its name but is reduced to 15 characters"
            Write-Host "INFO: The computer $User doesn't need to change its name but is reduced to 15 characters"
        }
        else {
            Write-Verbose "INFO: The computer $User doesn't need to change its name"
            Write-Host "INFO: The computer $User doesn't need to change its name"
        }
    }
    else  # Otherwise, prepend "EXE-PC-" to the computer name (e.g., TTEMP becomes EXE-PC-TTEMP)
    {
        $NewName = $User -replace $User, "EXE-PC-$User"

        if ($NewName.Length -gt 15) {  # Restrict the number of characters to a maximum of 15 and remove additional characters
            $NewName = $NewName.Substring(0, 15)
            Rename-Computer -ComputerName $User -NewName $NewName -DomainCredential $Cred -Force #-Restart
            Write-Host "INFO: The computer $User will restart and be named $NewName"  # Restart only if the "-Restart" on line 32 is implemented
            }
        else {
            Rename-Computer -ComputerName $User -NewName $NewName -DomainCredential $Cred -Force #-Restart
            Write-Host "INFO: The computer $User will restart and be named $NewName"  # Restart only if the "-Restart" on line 36 is implemented
        }
    }
}

