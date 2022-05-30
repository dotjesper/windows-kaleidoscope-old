<#
.SYNOPSIS
    Monitor Additional LSA Protection settings
.DESCRIPTION
    Monitor whatever Additional LSA Protection is configured.
    The LSA, which includes the Local Security Authority Server Service (LSASS) process, validates users for local and remote sign-ins and enforces local security policies.
    https://docs.microsoft.com/en-us/windows-server/security/credentials-protection-and-management/configuring-additional-lsa-protection.
.EXAMPLE
    .\remediate.ps1
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
            }
            else {
                Write-Output -InputObject "Configure Additional LSA Protection settings ($($regValues.RunAsPPL)$($regValues.DisableDomainCreds))"
                if ($regValues.RunAsPPL -ne 1) {
                    $null = New-ItemProperty -Path "Registry::$regRoot\$regPath" -Name "RunAsPPL" -Value 1 -PropertyType "DWORD" -Force
                }
                if ($regValues.DisableDomainCreds -ne 1) {
                    $null = New-ItemProperty -Path "Registry::$regRoot\$regPath" -Name "DisableDomainCreds" -Value 1 -PropertyType "DWORD" -Force
                }
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
