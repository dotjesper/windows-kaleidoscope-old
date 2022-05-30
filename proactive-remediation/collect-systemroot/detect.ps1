<#
.SYNOPSIS
    Monitor system root
.DESCRIPTION
    Monitor %SystemRoot%, fails if different from C:\Windows
.PARAMETER computerMaximumUptimeThreshold

.EXAMPLE
    .\detect.ps1
.NOTES
    version: 1.0
    author: @dotjesper
    date: November 30, 2021
#>
#requires -version 5.1
[CmdletBinding()]
param (
    # Variables
    [string]$SystemRoot = "C:\WINDOWS",
    # variables :: conditions
    [bool]$runScriptIn64bitPowerShell = $false
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
    #endregion
    try {

        if ("$($env:SystemRoot)" -eq "$SystemRoot") {
            Write-Output -InputObject "SystemRoot: $($env:SystemRoot) [0]"
            exit 0
        }
        else {
            Write-Output -InputObject "SystemRoot: $($env:SystemRoot) [1]"
            exit 1
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
