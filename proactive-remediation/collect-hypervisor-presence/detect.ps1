<#
.SYNOPSIS
    Monitor if hypervisor is present
.DESCRIPTION
    Monitor if hypervisor is present, fails if false.
.EXAMPLE
    .\detect.ps1
.NOTES
    version: 1.1
    author: @dotjesper
    date: November 30, 2021
#>
#requires -version 5.1
[CmdletBinding()]
param (
    # Variables
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
        #region Check Virtualization is present
        [bool]$VMMonitorModeExtensions = $(Get-CimInstance -ClassName Win32_processor).VMMonitorModeExtensions
        [bool]$VirtualizationFirmwareEnabled = $(Get-CimInstance -ClassName Win32_processor).VirtualizationFirmwareEnabled
        [bool]$HypervisorPresent = (Get-CimInstance -Class Win32_ComputerSystem).HypervisorPresent
        #success if either processor supports and enabled or if hyper-v is present
        if (($VMMonitorModeExtensions -and $VirtualizationFirmwareEnabled) -or $HypervisorPresent) {
            Write-Output -InputObject "Virtualization firmware check passed."
            exit 0
        }
        else {
            Write-Output -InputObject "Virtualization firmware check failed."
            exit 1
        }
        #endregion
    }
    catch {
        $errMsg = $_.Exception.Message
        Write-Error -Message $errMsg
        exit 1
    }
    finally {}
}
end {}
