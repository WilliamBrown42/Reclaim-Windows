
[CmdletBinding()]Param(
)

Begin{
}

Process{
    # Lower UAC level
    Write-Output "Lowering UAC level..."
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 0
    # Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 0

    # Raise UAC level
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 1

    # Enable sharing mapped drives between users
    Write-Output "Enabling sharing mapped drives between users..."
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLinkedConnections" -Type DWord -Value 1

    # Disable sharing mapped drives between users
    Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLinkedConnections"

    # Disable Windows Update automatic restart
    Write-Output "Disabling Windows Update automatic restart..."
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings" -Name "UxOption" -Type DWord -Value 1

    # Enable Windows Update automatic restart
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings" -Name "UxOption" -Type DWord -Value 0

    # Stop and disable Home Groups services
    Write-Output "Stopping and disabling Home Groups services..."
    Stop-Service "HomeGroupListener"
    Set-Service "HomeGroupListener" -StartupType Disabled
    Stop-Service "HomeGroupProvider"
    Set-Service "HomeGroupProvider" -StartupType Disabled

    # Enable and start Home Groups services
    Set-Service "HomeGroupListener" -StartupType Manual
    Set-Service "HomeGroupProvider" -StartupType Manual
    Start-Service "HomeGroupProvider"  
}

End{
}