<# Ce script est utile pour tester en local de puis votre powershell PC en administrateur #>

$ComputerName = $env:COMPUTERNAME
$add = $ComputerName

Foreach ($Name in $add)     <#pour chaque nom de la liste éffectue ...#>
{
    $User = $Name -replace '^@{Name=|}' <#var nécessaire afin de retirer les caractères inutiles des noms#> <#cette ligne n'est pas forcément nécessaire pour vous#>
    if ( $User -match 'EXE-PC-' -or $User -match 'POS-PC-')  <#si le nom pc commence par "EXE-PC-" ou "POS-PC-" autorise le if#>
    {
        if ($User.Length -gt 15) {  <#force le nombre de caractères a 15 maximum vire les caractères supplémentaires#>
            $User = $User.Substring(0, 15)
            Rename-Computer -ComputerName $User -NewName $NewName -DomainCredential $Cred -Force <#-Restart#>
            Write-Verbose "INFO : L'ordinateur $User n'a pas besoin de changer de nom mais est réduit à 15 caractères" 
            Write-Host "INFO : L'ordinateur $User n'a pas besoin de changer de nom mais est réduit à 15 caractères"
        }
        else {
            Write-Verbose "INFO : L'ordinateur $User n'a pas besoin de changer de nom" 
            Write-Host "INFO : L'ordinateur $User n'a pas besoin de changer de nom"
        }    
    else        <#sinon remplace le "name" par EXE-PC-"name" ex= TTEMP deviens EXE-PC-TTEMP#>
    {
        $NewName = $User -replace $User,"EXE-PC-$User" 
        if ($NewName.Length -gt 15) {      <#force le nombre de caractères a 15 maximum vire les caractères supplémentaires#>
            $NewName = $NewName.Substring(0, 15)
            Rename-Computer -ComputerName $User -NewName $NewName -DomainCredential $Cred -force <#-Restart#>
            Write-Host "INFO : L'ordinateur $User redémarre et s'appellera $NewName"        <#redémarre uniquement si le "-restart" ligne 28 est mis en place#>
        }
        else {
            Rename-Computer -ComputerName $User -NewName $NewName -DomainCredential $Cred -Force <#-Restart#>
            Write-Host "INFO : L'ordinateur $User redémarre et s'appellera $NewName"        <#redémarre uniquement si le "-restart" ligne 31 est mis en place#>
        }
    }
  }
}
