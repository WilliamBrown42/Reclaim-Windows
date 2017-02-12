<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
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

    # Disable Firewall
    Write-Output "Disabling Firewall..."
    Set-NetFirewallProfile -Profile * -Enabled False

    # Enable Firewall
    Set-NetFirewallProfile -Profile * -Enabled True

    # Disable Windows Defender
    Write-Output "Disabling Windows Defender..."
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWord -Value 1

    # Enable Windows Defender
    Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware"

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

    # Disable Remote Assistance
    Write-Output "Disabling Remote Assistance..."
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0

    # Enable Remote Assistance
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 1

    # Enable Remote Desktop w/o Network Level Authentication
    Write-Output "Enabling Remote Desktop w/o Network Level Authentication..."
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Type DWord -Value 0

    # Disable Remote Desktop
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Type DWord -Value 1
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Type DWord -Value 1
}

End{
}