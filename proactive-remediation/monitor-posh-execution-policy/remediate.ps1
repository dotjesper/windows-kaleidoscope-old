<#
.SYNOPSIS
    Check Powershell Execution Policy
.DESCRIPTION
    Check Powershell Execution Policy, validating Powershell Execution Policy is configured to Restricted
    Default: Restricted for Windows clients or RemoteSigned for Windows servers.
.PARAMETER requiredExecutionPolicy

.EXAMPLE
    .\remediation-script.ps1
.EXAMPLE
    powershell.exe -NoLogo -ExecutionPolicy Bypass -File .\remediate.ps1
.NOTES
    version: 1.2
    author: @dotjesper
    date: April 15, 2021
.LINK
    https://oofhours.com/2020/02/04/powershell-on-windows-10-arm64/
#>
#requires -version 5.1
[CmdletBinding()]
param (
    # Variables
    [string]$requiredExecutionPolicy = "Restricted",
    # variables :: conditions
    [bool]$runScriptIn64bitPowerShell = $false
)
begin {
    # variables :: environment
}
process {
    #region check conditions
    if ($runScriptIn64bitPowerShell -eq $true -and $([System.Environment]::Is64BitProcess) -eq $false) {
        Write-Output -InputObject "Windows PowerShell 64-bit is requered."
        exit 1
    }
    try {
        if ([Environment]::Is64BitOperatingSystem) {
            #Windows PowerShell (x64) Execution Policy
            [string]$64BitExecutionPolicy = Invoke-Expression -Command "$($env:SystemRoot)\System32\WindowsPowerShell\v1.0\powershell.exe -Command 'Get-ExecutionPolicy -Scope 'LocalMachine''"
            #Windows PowerShell (x86) Execution Policy
            [string]$32BitExecutionPolicy = Invoke-Expression -Command "$($env:SystemRoot)\Syswow64\WindowsPowerShell\v1.0\powershell.exe -Command 'Get-ExecutionPolicy -Scope 'LocalMachine''"
            #
            if (($64BitExecutionPolicy -eq $requiredExecutionPolicy) -and ($32BitExecutionPolicy -eq $requiredExecutionPolicy)) {
                Write-Output -InputObject "Powershell Execution Policy $requiredExecutionPolicy (64-bit $64BitExecutionPolicy, 32-bit $32BitExecutionPolicy)"
                exit 0
            }
            else {
                Write-Output -InputObject "Powershell Execution Policy not $requiredExecutionPolicy (64-bit $64BitExecutionPolicy, 32-bit $32BitExecutionPolicy)"
                $null = Invoke-Expression -Command "$($env:SystemRoot)\System32\WindowsPowerShell\v1.0\powershell.exe -Command 'Set-ExecutionPolicy -ExecutionPolicy $requiredExecutionPolicy -Scope 'LocalMachine' -Force'"
                $null = Invoke-Expression -Command "$($env:SystemRoot)\Syswow64\WindowsPowerShell\v1.0\powershell.exe -Command 'Set-ExecutionPolicy -ExecutionPolicy $requiredExecutionPolicy -Scope 'LocalMachine' -Force'"
                exit 0
            }
        }
        else {
            #Windows PowerShell (x86) Execution Policy
            [string]$32BitExecutionPolicy = Invoke-Expression -Command "$($env:SystemRoot)\System32\WindowsPowerShell\v1.0\powershell.exe -Command 'Get-ExecutionPolicy -Scope 'LocalMachine''"
            #
            if ([string]$32BitExecutionPolicy -eq $requiredExecutionPolicy) {
                Write-Output -InputObject "Powershell Execution Policy $requiredExecutionPolicy (32-bit $32BitExecutionPolicy)"
                exit 0
            }
            else {
                Write-Output -InputObject "Powershell Execution Policy not $requiredExecutionPolicy (32-bit $32BitExecutionPolicy)"
                $null = Invoke-Expression -Command "$($env:SystemRoot)\System32\WindowsPowerShell\v1.0\powershell.exe -Command 'Set-ExecutionPolicy -ExecutionPolicy $requiredExecutionPolicy -Scope 'LocalMachine' -Force'"
                exit 0
            }
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
