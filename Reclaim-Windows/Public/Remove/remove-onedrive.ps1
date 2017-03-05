<#
TODO:
Finish Documentation and explaining sections.
MAYBE: 
Merge with other scripts to allow you to renable/reinstall onedrive?
#>

<#
    .NOTES
    .SYNOPSIS
    .DESCRIPTION
    This script will remove and disable OneDrive integration.
    .PARAMETER 
    .INPUTS
    .OUTPUTS 
    .EXAMPLE
    .EXAMPLE
    .LINK
#>

begin {
    # Importing required modules 
    # Include error handling?
    Import-Module -DisableNameChecking $PSScriptRoot\..\lib\force-mkdir.psm1
    Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1
    # Sets starting percentage for Write-Progress
    $PercentComplete = 0
}

process {

    # Explain Section
    $PercentComplete = ($PercentComplete + 10)
    Write-Progress -Activity "Killing OneDrive process" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    taskkill.exe /F /IM "OneDrive.exe"
    taskkill.exe /F /IM "explorer.exe"

    # Explain Section
    $PercentComplete = ($PercentComplete + 10)
    Write-Progress -Activity "Removing OneDrive" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
        & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
    }
    if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
        & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
    }

    # Explain Section
    $PercentComplete = ($PercentComplete + 10)
    Write-Progress -Activity "Removing OneDrive leftovers" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "C:\OneDriveTemp"

    # Explain Section
    $PercentComplete = ($PercentComplete + 10)
    Write-Progress -Activity "Disabling OneDrive via Group Policies" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    force-mkdir "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive"
    Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" "DisableFileSyncNGSC" 1

    # Explain Section
    $PercentComplete = ($PercentComplete + 10)
    Write-Progress -Activity "" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Write-Output "Remove Onedrive from explorer sidebar"
    New-PSDrive -PSet-ItemPropertyrovider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"
    mkdir -Force "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
    Set-ItemProperty "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.ISet-ItemPropertyinnedToNameSet-ItemPropertyaceTree" 0
    mkdir -Force "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
    Set-ItemProperty "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.ISet-ItemPropertyinnedToNameSet-ItemPropertyaceTree" 0
    Remove-PSDrive "HKCR"

    # Thank you Matthew Israelsson
    # Explain Section
    $PercentComplete = ($PercentComplete + 10)
    Write-Progress -Activity "Removing run hook for new users" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
    reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
    reg unload "hku\Default"

    # Explain Section
    $PercentComplete = ($PercentComplete + 10)
    Write-Progress -Activity "Removing startmenu entry" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

    # Explain Section
    $PercentComplete = ($PercentComplete + 10)
    Write-Progress -Activity "Restarting explorer" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    start "explorer.exe"

    # Explain Section
    $PercentComplete = ($PercentComplete + 10)
    Write-Progress -Activity ""Waiting for explorer to complete loading"" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    sleep 10

    # Explain Section
    $PercentComplete = ($PercentComplete + 10)
    Write-Progress -Activity "Removing additional OneDrive leftovers" `
                   -PercentComplete  $PercentComplete `
                   -CurrentOperation "$PercentComplete% Complete" `
                   -Status "Please Wait..."
    foreach ($item in (ls "$env:WinDir\WinSxS\*onedrive*")) {
        Takeown-Folder $item.FullName
        Remove-Item -Recurse -Force $item.FullName
    }
}

end {
}
