<#
TODO:

#>

<#
    .NOTES
    .SYNOPSIS
    .DESCRIPTION
    This script will apply MarkC's mouse acceleration fix (for 100% DPI) and
    disable some accessibility features regarding keyboard input.  Additional
    some UI elements will be changed.
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
    Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

    # Stuff
    Write-Output "Elevating priviledges for this process"
    do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

    $PercentComplete = 0
    $PercentIncrement = 0
}

process {

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Applying MarkC's mouse acceleration fix" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Set-ItemProperty "HKCU:\Control Panel\Mouse" "MouseSensitivity" "10"
    Set-ItemProperty "HKCU:\Control Panel\Mouse" "MouseSet-ItemPropertyeed" "0"
    Set-ItemProperty "HKCU:\Control Panel\Mouse" "MouseThreshold1" "0"
    Set-ItemProperty "HKCU:\Control Panel\Mouse" "MouseThreshold2" "0"
    Set-ItemProperty "HKCU:\Control Panel\Mouse" "SmoothMouseXCurve" ([byte[]](0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0xCC, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x80, 0x99, 0x19, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x66, 0x26, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x33, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00))
    Set-ItemProperty "HKCU:\Control Panel\Mouse" "SmoothMouseYCurve" ([byte[]](0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA8, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0xE0, 0x00, 0x00, 0x00, 0x00, 0x00))

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Disable mouse pointer hiding" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Set-ItemProperty "HKCU:\Control Panel\Desktop" "UserPreferencesMask" ([byte[]](0x9e,
    0x1e, 0x06, 0x80, 0x12, 0x00, 0x00, 0x00))

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Disabling Game DVR and Game Bar" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    force-mkdir "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
    Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowgameDVR" 0

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Disabling easy access keyboard stuff" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Set-ItemProperty "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" "506"
    Set-ItemProperty "HKCU:\Control Panel\Accessibility\Keyboard ReSet-ItemPropertyonse" "Flags" "122"
    Set-ItemProperty "HKCU:\Control Panel\Accessibility\ToggleKeys" "Flags" "58"

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Restoring old volume slider" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    force-mkdir "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC"
    Set-ItemProperty "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC" "EnableMtcUvc" 0

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Setting folder view options" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideDrivesWithNoMedia" 0

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Setting default explorer view to This PC" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" 1

    $PercentComplete = ($PercentComplete + $PercentIncrement)
    Write-Progress -Activity "Removing user folders under This PC" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    # Remove Desktop from This PC
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"
    # Remove Documents from This PC
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}"
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{d3162b92-9365-467a-956b-92703aca08af}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{d3162b92-9365-467a-956b-92703aca08af}"
    # Remove Downloads from This PC
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{374DE290-123F-4565-9164-39C4925E467B}"
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{088e3905-0323-4b02-9826-5d99428e115f}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{374DE290-123F-4565-9164-39C4925E467B}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{088e3905-0323-4b02-9826-5d99428e115f}"
    # Remove Music from This PC
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}"
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"
    # Remove Pictures from This PC
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}"
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"
    # Remove Videos from This PC
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}"
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\Namespace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"

    # What do I want to do with this one?
    #Write-Output "Disabling tile push notification"
    #force-mkdir "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
    #Set-ItemProperty "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" "NoTileApplicationNotification" 1
}

end {}
