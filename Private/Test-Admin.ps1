function Test-Admin(){
    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] “Administrator”)){
        Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!`nPress any key to continue..."
        $trigger = $true
    } 
    # Better way to do this? #
    if ($trigger -eq $true){
        [void][System.Console]::ReadKey($true)
        Break
    }
    <#
        Exception calling "ReadKey" with "1" argument(s): "Cannot read keys when either application does not have a console or when console input has been redirected from a file. Try Console.Read."
        At line:9 char:9
        +         [void][System.Console]::ReadKey($true)
        +         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : NotSpecified: (:) [], MethodInvocationException
        + FullyQualifiedErrorId : InvalidOperationException
    #>

    <#
    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
    }
    #>
}

