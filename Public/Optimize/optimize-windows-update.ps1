#   Description:
# This script optimizes Windows updates by disabling automatic download and
# seeding updates to other computers.
#

<#
    .NOTES
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER 
    .INPUTS
    .OUTPUTS 
    .EXAMPLE
    .EXAMPLE
    .LINK
#>

begin {

    # Stuff
    Import-Module -DisableNameChecking $PSScriptRoot\..\lib\force-mkdir.psm1

}

process {

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Disable automatic download and installation of Windows updates" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
force-mkdir "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU"
Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate" 0
Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" 2
Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" "ScheduledInstallDay" 0
Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" "ScheduledInstallTime" 3

   $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Disable seeding of updates to other computers via Group Policies" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
force-mkdir "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0

#Write-Output "Disabling automatic driver update"
#Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" "SearchOrderConfig" 0

$PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Disable 'Updates are available' message" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
takeown /F "$env:WinDIR\System32\MusNotification.exe"
icacls "$env:WinDIR\System32\MusNotification.exe" /deny "Everyone:(X)"
takeown /F "$env:WinDIR\System32\MusNotificationUx.exe"
icacls "$env:WinDIR\System32\MusNotificationUx.exe" /deny "Everyone:(X)"

}

end {}
