# Add increment value for percent complete in write progress

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
        [switch]$OneDrive
)

<#
#>
Begin{
# Test for permissions
# Grab input / need to make the params 
# Put interactive part in begin
# $APP 
# ENABLE
# DISABLE
# INSTALL 
# UNINSTALL
}
    
Process{
    # All of the code for this I need to look at and figure out what it does before making significant changes.
    if ($OneDrive){
        switch ($OneDrive.state){
            "install" {
                # This should test to see if it is already installed?
                # Install OneDrive
                $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
                If (!(Test-Path $onedrive)) {
                    $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
                }
            }
            "uninstall" {
                # Uninstall OneDrive
                Write-Progress -Activity "Uninstalling OneDrive..." `
                               -PercentComplete  $PercentComplete `
                               -CurrentOperation "$PercentComplete% Complete" `
                               -Status "Please Wait..."
                Stop-Process -Name OneDrive -ErrorAction SilentlyContinue
                Start-Sleep -s 3
                $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
                If (!(Test-Path $onedrive)) {
                    $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
                }
                Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
                Start-Sleep -s 3
                Stop-Process -Name explorer -ErrorAction SilentlyContinue
                Start-Sleep -s 3
                Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
                Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
                Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
                If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") {
                    Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
                }
                If (!(Test-Path "HKCR:")) {
                    New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
                }
                Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
                Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
                }
            "enable" {
                # Enable OneDrive
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC"
                Start-Process $onedrive -NoNewWindow
            }
            "disable" {
                # Disable OneDrive
                Write-Progress -Activity "Disabling OneDrive..." `
                               -PercentComplete  $PercentComplete `
                               -CurrentOperation "$PercentComplete% Complete" `
                               -Status "Please Wait..."
                
                If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
                    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
                }
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1
            }
        } 
    }

    # The logic for this might need some explaining, that being enable will install it if it is not and so on and so forth. 
    foreach ($APP in $STUFF){
        switch ($APP.state){
            "uninstall" { 
                # increment percent 
                Write-Progress -Activity "Uninstalling $($APP.name)" `
                               -PercentComplete  $PercentComplete `
                               -CurrentOperation "$PercentComplete% Complete" `
                               -Status "Please Wait..." 
                Get-AppxPackage "$($APP.NAME)" | Remove-AppxPackage 
            }
            "install" {
                Write-Progress -Activity "Installing $($APP.name)" `
                               -PercentComplete  $PercentComplete `
                               -CurrentOperation "$PercentComplete% Complete" `
                               -Status "Please Wait..." 
                # Need to look at what this does a little closer.
                Add-AppxPackage -DisableDevelopmentMode -Register "$($(Get-AppXPackage -AllUsers "$($APP.name)").InstallLocation)\AppXManifest.xml"
                # Test if already installed? 
                # Install if not
                # enable?
            }
       }
    }

    # Uninstall Windows Media Player
    Write-Output "Uninstalling Windows Media Player..."
    dism /online /Disable-Feature /FeatureName:MediaPlayback /Quiet /NoRestart

    # Install Windows Media Player
    dism /online /Enable-Feature /FeatureName:MediaPlayback /Quiet /NoRestart

    # Uninstall Work Folders Client
    Write-Output "Uninstalling Work Folders Client..."
    dism /online /Disable-Feature /FeatureName:WorkFolders-Client /Quiet /NoRestart

    # Install Work Folders Client
    dism /online /Enable-Feature /FeatureName:WorkFolders-Client /Quiet /NoRestart

    # Set Photo Viewer as default for bmp, gif, jpg and png
    Write-Output "Setting Photo Viewer as default for bmp, gif, jpg, png and tif..."
    If (!(Test-Path "HKCR:")) {
    New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
    }
    ForEach ($type in @("Paint.Picture", "giffile", "jpegfile", "pngfile")) {
    New-Item -Path $("HKCR:\$type\shell\open") -Force | Out-Null
    New-Item -Path $("HKCR:\$type\shell\open\command") | Out-Null
    Set-ItemProperty -Path $("HKCR:\$type\shell\open") -Name "MuiVerb" -Type ExpandString -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
    Set-ItemProperty -Path $("HKCR:\$type\shell\open\command") -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
    }

    # Remove or reset default open action for bmp, gif, jpg and png
    If (!(Test-Path "HKCR:")) {
        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
    }
    Remove-Item -Path "HKCR:\Paint.Picture\shell\open" -Recurse
    Remove-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "MuiVerb"
    Set-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "CommandId" -Type String -Value "IE.File"
    Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "(Default)" -Type String -Value "`"$env:SystemDrive\Program Files\Internet Explorer\iexplore.exe`" %1"
    Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "DelegateExecute" -Type String -Value "{17FE9752-0B5A-4665-84CD-569794602F5C}"
    Remove-Item -Path "HKCR:\jpegfile\shell\open" -Recurse
    Remove-Item -Path "HKCR:\pngfile\shell\open" -Recurse

    # Show Photo Viewer in "Open with..."
    Write-Output "Showing Photo Viewer in `"Open with...`""
    If (!(Test-Path "HKCR:")) {
        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
    }
    New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open\command" -Force | Out-Null
    New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" -Force | Out-Null
    Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open" -Name "MuiVerb" -Type String -Value "@photoviewer.dll,-3043"
    Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open\command" -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
    Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" -Name "Clsid" -Type String -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

    Remove Photo Viewer from "Open with..."
    If (!(Test-Path "HKCR:")) {
        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
    }
    Remove-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open" -Recurse
}

End{
}




































