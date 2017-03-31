Function GetWinKey
{
    $Hklm = 2147483650
    $Target = $env:COMPUTERNAME
    $RegPath = "Software\Microsoft\Windows NT\CurrentVersion"
    $DigitalID = "DigitalProductId"
    $Wmi = [WMIClass]"\\$Target\root\default:stdRegProv"
    $Object = $Wmi.GetBinaryValue($Hklm,$RegPath,$DigitalID)
    [Array]$DigitalIDvalue = $Object.uValue
    $ProductName = (Get-itemproperty -Path "HKLM:Software\Microsoft\Windows NT\CurrentVersion" -Name "ProductName").ProductName
# $CurrentVersion = (Get-itemproperty -Path "HKLM:Software\Microsoft\Windows NT\CurrentVersion" -Name "CurrentVersion").CurrentVersion
    $CurrentBuild = (Get-itemproperty -Path "HKLM:Software\Microsoft\Windows NT\CurrentVersion" -Name "CurrentBuildNumber").CurrentBuildNumber
    $PROCESSOR_ARCHITECTURE = (Get-itemproperty -Path "HKLM:SYSTEM\ControlSet001\Control\Session Manager\Environment" -Name "PROCESSOR_ARCHITECTURE").PROCESSOR_ARCHITECTURE
    $RegisteredOwner = (Get-itemproperty -Path "HKLM:Software\Microsoft\Windows NT\CurrentVersion" -Name "RegisteredOwner").RegisteredOwner
if($CurrentVersion -ge 6.0) {
    $USERDOMAIN = (Get-itemproperty -Path "HKCU:Volatile Environment" -Name "USERDOMAIN").USERDOMAIN
} else {
    $USERDOMAIN = (Get-itemproperty -Path "HKLM:SYSTEM\controlset001\control\computername\ComputerName" -Name "Computername").Computername
}

    $ProductID = (Get-itemproperty -Path "HKLM:Software\Microsoft\Windows NT\CurrentVersion" -Name "ProductId").ProductId
    $DigiID = ConvertTokey $DigitalIDvalue
    $OSInfo = (Get-WmiObject "Win32_OperatingSystem" | Select Caption).Caption
    $CSDVersion = ""
If($PROCESSOR_ARCHITECTURE -eq "x86") {
    $OsType = "32 Bit"
}
Elseif($PROCESSOR_ARCHITECTURE -eq "AMD64") {
    $OsType = "64 Bit"
}
If($CurrentVersion -le 6.1) {
#    $CSDVersion = (Get-itemproperty -Path "HKLM:Software\Microsoft\Windows NT\CurrentVersion" -Name "CSDVersion").CSDVersion
}
    [string]$Value = "Windows-Edition       : $ProductName $OsType $CSDVersion `r`n" `
    + "Windows-Build-ID      : $CurrentBuild `r`n" `
    + "Windows-Versions-ID   : $CurrentVersion `r`n" `
    + "Prozessor-Architektur : $PROCESSOR_ARCHITECTURE `r`n" `
    + "Produkt-ID            : $ProductID `r`n" `
    + "Windows-ProduktKey    : $DigiID `r`n`r`n" `
    + "Registrierter Benutzer: $RegisteredOwner `r`n" `
    + "Computername          : $USERDOMAIN `r`n"
    $Value
    $Txtpath = "."

#New-Item -Path $Txtpath -Name $FName -Value $Value -ItemType File -Force | Out-Null
}

Function ConvertToKey($Key)
{

    [String]$Chars = "BCDFGHJKMPQRTVWXY2346789"
    if($CurrentVersion -le 6.1) {
        For ($i = 24; $i -ge 0; $i--) {
            $k = 0
            For ($j = 66; $j -ge 52; $j--) {
                $k = $k * 256 -bxor $Key[$j]
                $Key[$j] = [math]::truncate($k / 24)
                $k = $k % 24
            }
            $KeyProduct = $Chars[$k] + $KeyProduct

            If (($i % 5 -eq 0) -and ($i -ne 0)) {
               $KeyProduct = "-" + $KeyProduct
            }
        }

} else {
    $Keyoffset = 52
    $IsWin8 = [int]($Key[66]/6) -band 1
    $HF7 = 0xF7
    $Key[66] = ($Key[66] -band $HF7) -bOr (($IsWin8 -band 2) * 4)
    $i = 24
# [String]$Chars = "BCDFGHJKMPQRTVWXY2346789"
    Do {
        $Cur = 0
        $X = 14
        Do {
            $Cur = $Cur * 256
            $Cur = $Key[$X + $Keyoffset] + $Cur
            $Key[$X + $Keyoffset] = [math]::Floor([double]($Cur/24))
            $Cur = $Cur % 24
            $X = $X – 1
        } While($X -ge 0)
        $i = $i- 1
        $KeyOutput = $Chars.SubString($Cur,1) + $KeyOutput
        $Last = $Cur
    }While($i -ge 0)
    $Keypart1 = $KeyOutput.SubString(1,$Last)
    $Keypart2 = $KeyOutput.Substring(1,$KeyOutput.length-1)

    If($Last -eq 0 ) {
        $KeyOutput = "N" + $Keypart2
    } Else {
        $KeyOutput = $Keypart2.Insert($Keypart2.IndexOf($Keypart1)+$Keypart1.length,"N")
    }

    $KeyProduct = ""
    For ($i = 0; $i -le 24; $i++)  {
        $KeyProduct = $KeyProduct + $KeyOutput[$i] 
        If ((($i+1) % 5 -eq 0) -and ($i -ne 0) -and ($i -le 20) ) {
            $KeyProduct = $KeyProduct + "-"
        }
    }

}

$KeyProduct
}



GetWinKey

