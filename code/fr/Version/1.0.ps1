$Username = 'Username'   <#variable de connexion à l'utilisateur "Username"#>
$Password = 'Password'
$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass

$add = Get-ADComputer -Filter * -Properties 'Name' -SearchBase 'OU=Utilisateurs,OU=OrdinateursUtilisateurs,DC="",DC=fr' | Select-Object Name <#variable add attribué a la liste des utilisateurs dans l'AD#>

Foreach ($Name in $add)     <#pour chaque nom de la liste éffectue ...#>
{
    $User = $Name -replace '^@{Name=|}' <#var nécessaire afin de retirer les caractères inutiles des noms#> <#cette ligne n'est pas forcément nécessaire pour vous#>
    if ( $User -match ('EXE-PC-'))  <#si le nom pc commence par "EXE-PC-" autorise le if#>
    {
        if ($User.Length -gt 15) {  <#force le nombre de caractères a 15 maximum vire les caractères supplémentaires#>
            $User = $User.Substring(0, 15)
        }
        Write-Verbose "INFO : L'ordinateur $User n'a pas besoin de changer de nom" 
        Write-Host "INFO : L'ordinateur $User n'a pas besoin de changer de nom"

    }
    elseif ( $User -match ('POS-PC-'))  <#si le nom pc commence par "POS-PC-" autorise le if#> {

        if ($User.Length -gt 15) {      <#force le nombre de caractères a 15 maximum vire les caractères supplémentaires#>
            $User = $User.Substring(0, 15)
        }
        Write-Verbose "INFO : L'ordinateur $User n'a pas besoin de changer de nom" 
        Write-Host "INFO : L'ordinateur $User n'a pas besoin de changer de nom"
    }
    else        <#sinon remplace le "name" par EXE-PC-"name" ex= TTEMP deviens EXE-PC-TTEMP#>
    {
        $NewName = $User -replace $User,"EXE-PC-$User" 
        Rename-Computer -ComputerName $User -NewName $NewName -DomainCredential $Cred -force <#-Restart#>
        if ($NewName.Length -gt 15) {      <#force le nombre de caractères a 15 maximum vire les caractères supplémentaires#>
            $NewName = $NewName.Substring(0, 15)
        }
        Write-Host "INFO : L'ordinateur $User s'appellera $NewName après un redémarrage"
        <#Write-Host "INFO : L'ordinateur $User redémarre et s'appellera $NewName"#>        <#redémarre uniquement si le "-restart" ligne 31 est mis en place#>
    }
}
