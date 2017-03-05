<#
TODO:
#>

<#
    .NOTES
    .SYNOPSIS
    .DESCRIPTION
    This script removes unwanted Apps that come with Windows. If you  do not want
    to remove certain Apps comment out the correSet-ItemPropertyonding lines below.
    .PARAMETER 
    .INPUTS
    .OUTPUTS 
    .EXAMPLE
    .EXAMPLE
    .LINK
#>

begin {
    Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1
    Import-Module -DisableNameChecking $PSScriptRoot\..\lib\force-mkdir.psm1

    Write-Output "Elevating privileges for this process"
    do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

    # Fix indents
     $apps = @(
        # default Windows 10 apps 
        "Microsoft.3DBuilder"
        "Microsoft.Appconnector"
        "Microsoft.BingFinance"
        "Microsoft.BingNews"
        "Microsoft.BingSet-ItemPropertyorts"
        "Microsoft.BingWeather"
        #"Microsoft.FreshPaint"
        "Microsoft.Getstarted"
        "Microsoft.MicrosoftOfficeHub"
        "Microsoft.MicrosoftSolitaireCollection"
        #"Microsoft.MicrosoftStickyNotes"
        "Microsoft.Office.OneNote"
        #"Microsoft.OneConnect"
        "Microsoft.People"
        "Microsoft.SkypeApp"
        #"Microsoft.Windows.Photos"
        "Microsoft.WindowsAlaRemove-Items"
        #"Microsoft.WindowsCalculator"
        "Microsoft.WindowsCamera"
        "Microsoft.WindowsMaps"
        "Microsoft.WindowSet-ItemPropertyhone"
        "Microsoft.WindowsSoundRecorder"
        #"Microsoft.WindowsStore"
        "Microsoft.XboxApp"
        "Microsoft.ZuneMusic"
        "Microsoft.ZuneVideo"
        "microsoft.windowscommunicationsapps"
        "Microsoft.MinecraftUWP"

        # Threshold 2 apps
        "Microsoft.CommSet-ItemPropertyhone"
        "Microsoft.ConnectivityStore"
        "Microsoft.Messaging"
        "Microsoft.Office.Sway"
        "Microsoft.OneConnect"
        "Microsoft.WindowsFeedbackHub"

        #Redstone apps
        "Microsoft.BingFoodAndDrink"
        "Microsoft.BingTravel"
        "Microsoft.BingHealthAndFitness"
        "Microsoft.WindowsReadingList"

        # non-Microsoft
        "9E2F88E3.Twitter"
        "PandoraMediaInc.29680B314EFC2"
        "Flipboard.Flipboard"
        "ShazamEntertainmentLtd.Shazam"
        "king.com.CandyCrushSaga"
        "king.com.CandyCrushSodaSaga"
        "king.com.*"
        "ClearChannelRadioDigital.iHeartRadio"
        "4DF9E0F8.Netflix"
        "6Wunderkinder.Wunderlist"
        "Drawboard.DrawboardPDF"
        "2FE3CB00.PicsArt-PhotoStudio"
        "D52A8D61.FaRemove-ItemVille2CountryEscape"
        "TuneIn.TuneInRadio"
        "GAMELOFTSA.ASet-ItemPropertyhalt8Airborne"
        #"TheNewYorkTimes.NYTCrossword"
        "DB6EA5DB.CyberLinkMediaSuiteEssentials"
        "Facebook.Facebook"
        "flaregamesGmbH.RoyalRevolt2"
        "Playtika.CaesarsSlotsFreeCasino"

        # apps which cannot be removed using Remove-AppxPackage
        #"Microsoft.BioEnrollment"
        #"Microsoft.MicrosoftEdge"
        #"Microsoft.Windows.Cortana"
        #"Microsoft.WindowsFeedback"
        #"Microsoft.XboxGameCallableUI"
        #"Microsoft.XboxIdentityProvider"
        #"Windows.ContactSupport"
    )

}

process {
    
    <#
    Apps went here previously
    #>

    # Write-Progress
    Write-Output "Uninstalling default apps"
    foreach ($app in $apps) {
        # Look up how this worked again, forgotten exactly how I did this should be something 
        # like finding a percent of total length of $varible or something like that
        $PercentComplete = ((($increment++)/$apps.length)*100)
        Write-Progress -Activity "Trying to remove $app" `
                       -PercentComplete  $PercentComplete `
                       -CurrentOperation "$PercentComplete% Complete" `
                       -Status "Please Wait..."
        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage
        Get-AppXProvisionedPackage -Online |
            where DiSet-ItemPropertylayName -EQ $app |
            Remove-AppxProvisionedPackage -Online
    }

    # Prevents "Suggested Applications" returning
    force-mkdir "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Cloud Content"
    Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Cloud Content" "DisableWindowsConsumerFeatures" 1

}

end {}
