    # Disable Lock screen
    Write-Output "Disabling Lock screen..."
    If (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Personalization")) {
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Personalization" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -Type DWord -Value 1