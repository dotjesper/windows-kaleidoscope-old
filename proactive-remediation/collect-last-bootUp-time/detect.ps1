<#
.SYNOPSIS
    Detect last boot time
.DESCRIPTION
    Monitor last boot time, fails if last boot time is 7 days or above.
.PARAMETER computerMaximumUptimeThreshold

.EXAMPLE
    .\detect.ps1
.NOTES
    version: 1.2
    author: @dotjesper
    date: April 15, 2021
#>
#requires -version 5.1
[CmdletBinding()]
param (
    # Variables
    [int]$computerMaximumUptimeThreshold = 7 # days
)
begin {
    # variables :: environment
    # variables :: conditions
    [bool]$runScriptIn64bitPowerShell = $false
}
process {
    #region check conditions
    if ($runScriptIn64bitPowerShell -eq $true -and $([System.Environment]::Is64BitProcess) -eq $false) {
        Write-Output -InputObject "Windows PowerShell 64-bit is requered."
        exit 1
    }
    try {
        #region check conditions
        if ($runScriptIn64bitPowerShell -eq $true -and $([System.Environment]::Is64BitProcess) -eq $false) {
            Write-Output -InputObject "Script must be run using 64-bit PowerShell."
            exit 1
        }
        #endregion
        $computerUptime = Get-ComputerInfo -Property OSUptime
        if ($computerUptime.OsUptime.Days -ge $computerMaximumUptimeThreshold) {
            Write-Output -InputObject "Device uptime has exceeded the defined $computerMaximumUptimeThreshold days uptime threshold - last boot $($computerUptime.OsUptime.Days) days ago - a restart is recomended."
            exit 1
        }
        else {
            Write-Output -InputObject "Device uptime is within the defined $computerMaximumUptimeThreshold days uptime threshold - last boot $($computerUptime.OsUptime.Days) days ago."
            exit 0
        }
    }
    catch {
        $errMsg = $_.Exception.Message
        Write-Error -Message $errMsg
        exit 1
    }
    finally {}
}
end {}
