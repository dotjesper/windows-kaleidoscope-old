<#
.SYNOPSIS
    Monitor Additional LSA Protection settings
.DESCRIPTION
    Monitor whatever Additional LSA Protection is configured.
    The LSA, which includes the Local Security Authority Server Service (LSASS) process, validates users for local and remote sign-ins and enforces local security policies.
    https://docs.microsoft.com/en-us/windows-server/security/credentials-protection-and-management/configuring-additional-lsa-protection.
.EXAMPLE
    .\detect.ps1
.NOTES
    version: 1.3.0.2
    author: @dotjesper
    date: May 4, 2021
#>
#requires -version 5.1
[CmdletBinding()]
param (
    # Variables
    # variables :: conditions
    [bool]$runScriptIn64bitPowerShell = $false
)
begin {
    # variables :: environment
    [string]$regRoot = "HKLM"
    [string]$regPath = "SYSTEM\CurrentControlSet\Control\Lsa"
}
process {
    #region check conditions
    if ($runScriptIn64bitPowerShell -eq $true -and $([System.Environment]::Is64BitProcess) -eq $false) {
        Write-Output -InputObject "Windows PowerShell 64-bit is requered."
        exit 1
    }
    try {
        if (Test-Path -Path $($regRoot + ":\" + $regPath)) {
            [array]$regValues = Get-ItemProperty -Path "Registry::$regRoot\$regPath"
            if (($regValues.RunAsPPL -eq 1) -and ($regValues.DisableDomainCreds -eq 1)) {
                Write-Output -InputObject "Additional LSA Protection proberly configured ($($regValues.RunAsPPL)$($regValues.DisableDomainCreds))"
                exit 0
            }
            else {
                Write-Output -InputObject "Additional LSA Protection misconfigured ($($regValues.RunAsPPL)$($regValues.DisableDomainCreds))"
                exit 1
            }
        }
        else {
            Write-Output -InputObject "Additional LSA Protection not avaliable ($((Get-CimInstance -ClassName WIn32_OperatingSystem).OSArchitecture))"
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
