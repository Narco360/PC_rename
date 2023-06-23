$Username = 'Username'     <# Variable to store the username for the user #>
$Password = 'Password'
$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $pass

$add = Get-ADComputer -Filter * -Properties 'Name' -SearchBase 'OU=Utilisateurs,OU=OrdinateursUtilisateurs,DC="",DC=fr' | Select-Object Name   <# Variable $add stores the list of users in the AD #>

Foreach ($Name in $add) {    <# For each name in the list, perform the following actions #>
    $User = $Name -replace '^@{Name=|}'   <# Variable required to remove unnecessary characters from the names #>   <# This line may not be necessary for you #>
    if ($User -match 'EXE-PC-') {   <# If the PC name starts with "EXE-PC-", execute the following code #>
        if ($User.Length -gt 15) {    <# Force the maximum character limit to 15 and remove any additional characters #>
            $User = $User.Substring(0, 15)
        }
        Write-Verbose "INFO: Computer $User does not need to be renamed" 
        Write-Host "INFO: Computer $User does not need to be renamed"
    }
    elseif ($User -match 'POS-PC-') {   <# If the PC name starts with "POS-PC-", execute the following code #>
        if ($User.Length -gt 15) {    <# Force the maximum character limit to 15 and remove any additional characters #>
            $User = $User.Substring(0, 15)
        }
        Write-Verbose "INFO: Computer $User does not need to be renamed" 
        Write-Host "INFO: Computer $User does not need to be renamed"
    }
    else {    <# Otherwise, replace "name" with "EXE-PC-name". For example, TTEMP becomes EXE-PC-TTEMP #>
        $NewName = $User -replace $User, "EXE-PC-$User" 
        Rename-Computer -ComputerName $User -NewName $NewName -DomainCredential $Cred -force   <# -Restart #>
        if ($NewName.Length -gt 15) {    <# Force the maximum character limit to 15 and remove any additional characters #>
            $NewName = $NewName.Substring(0, 15)
        }
        Write-Host "INFO: Computer $User will be named $NewName after a restart"
        <#Write-Host "INFO: Computer $User is restarting and will be named $NewName"#>   <# Restart only if the "-restart" on line 31 is enabled #>
    }
}
