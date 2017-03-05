<# 
TODO:
Write-Progress 1/12'
Error action?
#>

<#
    .NOTES
    .SYNOPSIS
    .DESCRIPTION
    This script will try to fix many of the privacy settings for the user. This
    is work in progress!
    .PARAMETER 
    .INPUTS
    .OUTPUTS 
    .EXAMPLE
    .EXAMPLE
    .LINK
#>


begin{
    
    # Stuff
    Import-Module -DisableNameChecking $PSScriptRoot\..\lib\force-mkdir.psm1
    Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

    # Stuff
    Write-Output "Elevating priviledges for this process"
    do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

    # Stuff
     $groups = @(
        "Accessibility"
        "AppSync"
        "BrowserSettings"
        "Credentials"
        "DesktopTheme"
        "Language"
        "PackageState"
        "Personalization"
        "StartLayout"
        "Windows"
    )

    # Setting Varibles for Write-Progress
    $PercentComplete = 0
    $PercentIncrement = 0
}

process{

    # Look at the wording of this
    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Defuse Windows search settings" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Set-WindowsSearchSetting -EnableWebResultsSetting $false

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Setting general privacy options" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Set-ItemProperty "HKCU:\Control Panel\International\User Profile" "HttpAcceptLanguageOptOut" 1
    force-mkdir "HKCU:\Printers\Defaults"
    Set-ItemProperty "HKCU:\Printers\Defaults" "NetID" "{00000000-0000-0000-0000-000000000000}" 
    force-mkdir "HKCU:\SOFTWARE\Microsoft\Input\TIPC"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Input\TIPC" "Enabled" 0
    force-mkdir "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" "EnableWebContentEvaluation" 0

    # look at wording here too.
    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Disable synchronisation of settings" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "BackupPolicy" 0x3c
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "DeviceMetadataUploaded" 0
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "PriorLogons" 1
    <#
    Groups here previously
    #>
    foreach ($group in $groups) {
        force-mkdir "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\$group"
        Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\$group" "Enabled" 0
    }

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Set privacy policy accepted state to 0" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    force-mkdir "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Do not scan contact infoRemove-Itemations" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    force-mkdir "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" "HarvestContacts" 0

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Inking and typing settings" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    force-mkdir "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" 1
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" 1

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Microsoft Edge settings" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    force-mkdir "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main"
    Set-ItemProperty "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" "DoNotTrack" 1
    force-mkdir "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\User\Default\SearchScopes"
    Set-ItemProperty "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\User\Default\SearchScopes" "ShowSearchSuggestionsGlobal" 0
    force-mkdir "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead"
    Set-ItemProperty "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead" "FPEnabled" 0
    force-mkdir "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter"
    Set-ItemProperty "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" "EnabledV9" 0

    # Wording
    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Disable background access of default apps" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    foreach ($key in (ls "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications")) {
        Set-ItemProperty ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\" + $key.PSChildName) "Disabled" 1
    }

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Denying device access" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" "Type" "LooselyCoupled"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" "Value" "Deny"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" "InitialAppValue" "Unspecified"
    foreach ($key in (ls "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global")) {
        if ($key.PSChildName -EQ "LooselyCoupled") {
            continue
        }
        Set-ItemProperty ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\" + $key.PSChildName) "Type" "InterfaceClass"
        Set-ItemProperty ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\" + $key.PSChildName) "Value" "Deny"
        Set-ItemProperty ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\" + $key.PSChildName) "InitialAppValue" "Unspecified"
    }

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Disable location sensor" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    force-mkdir "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\PeRemove-Itemissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\PeRemove-Itemissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" "SensorPeRemove-ItemissionState" 0

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Disable submission of Windows Defender findings (w/ elevated privileges)" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Takeown-Registry("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\spynet")
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows Defender\spynet" "spyNetReporting" 0       # write-protected even after takeown ?!
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows Defender\spynet" "SubmitSamplesConsent" 0

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Do not share wifi networks" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    $user = New-Object System.Security.Principal.NTAccount($env:UserName)
    $sid = $user.Translate([System.Security.Principal.SecurityIdentifier]).value
    force-mkdir ("HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features\" + $sid)
    Set-ItemProperty ("HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features\" + $sid) "FeatureStates" 0x33c
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features" "WiFiSenseCredShared" 0
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features" "WiFiSenseOpen" 0
}

end {
}