    # Disable Action Center
    Write-Output "Disabling Action Center..."
    If (!(Test-Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer")) {
    New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Type DWord -Value 0