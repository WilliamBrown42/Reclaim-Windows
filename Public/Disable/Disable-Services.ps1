<#
READFORMERGESTATUS: NO
#>

<#
    .NOTES
    .SYNOPSIS
    .DESCRIPTION
    This script disables unwanted Windows services. If you do not want to disable
    certain services comment out the correSet-ItemPropertyonding lines below.
    .PARAMETER 
    .INPUTS
    .OUTPUTS 
    .EXAMPLE
    .EXAMPLE
    .LINK
#>

begin {

$services = @(
    "diagnosticshub.standardcollector.service" # Microsoft (R) Diagnostics Hub Standard Collector Service
    "DiagTrack"                                # Diagnostics Tracking Service
    "dmwappushservice"                         # WAP Push Message Routing Service (see known issues)
    "HomeGroupListener"                        # HomeGroup Listener
    "HomeGroupProvider"                        # HomeGroup Provider
    "lfsvc"                                    # Geolocation Service
    "MapsBroker"                               # Downloaded Maps Manager
    "NetTcpPortSharing"                        # Net.Tcp Port Sharing Service
    "RemoteAccess"                             # Routing and Remote Access
    "RemoteRegistry"                           # Remote Registry
    "SharedAccess"                             # Internet Connection Sharing (ICS)
    "TrkWks"                                   # Distributed Link Tracking Client
    "WbioSrvc"                                 # Windows Biometric Service
    #"WlanSvc"                                 # WLAN AutoConfig
    "WMPNetworkSvc"                            # Windows Media Player Network Sharing Service
    "wscsvc"                                   # Windows Security Center Service
    #"WSearch"                                 # Windows Search
    "XblAuthManager"                           # Xbox Live Auth Manager
    "XblGameSave"                              # Xbox Live Game Save Service
    "XboxNetApiSvc"                            # Xbox Live Networking Service

    # Services which cannot be disabled
    #"WdNisSvc"
)

}

process {

    foreach ($service in $services) {
        $PercentComplete = ((($increment++)/$services.length)*100)
        Write-Progress -Activity "Trying to disable $service" `
                       -PercentComplete  $PercentComplete `
                       -CurrentOperation "$PercentComplete% Complete" `
                       -Status "Please Wait..."
        Start-Sleep 3
        Get-Service -Name $service | Set-Service -StartupType Disabled
    }

}

end {
}

<#
# Disable services
function Disable-Services($isenable)
{
    if ($isenable -eq $true)
    {
        Write-Progress -Activity "Disabling services" -Status "Progress:" -PercentComplete 4
        # Disable DiagTrack
        cmd /c sc config DiagTrack start= disabled | out-null
        cmd /c sc config dmwappushservice start= disabled | out-null
        cmd /c sc config diagnosticshub.standardcollector.service start= disabled | out-null
        cmd /c sc config TrkWks start= disabled | out-null
        cmd /c sc config WMPNetworkSvc start= disabled | out-null # Shouldn't exist but just making sure ...
        # Making sure the DiagTrack log is empty (tinfoil)
        Set-Content C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl -Value "" -Force
        Write-Progress -Activity "Disabling services" -Status "Progress:" -PercentComplete 7
    }
}
#>
