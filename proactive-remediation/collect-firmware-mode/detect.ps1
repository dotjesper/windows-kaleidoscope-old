<#
.SYNOPSIS
    Collect firmware mode (UEFI ir BIOS)
.DESCRIPTION
    This PowerShell script determine the underlying system firmware (BIOS) mode - either UEFI or Legacy BIOS.
    1: Legacy BIOS
    2: UEFI
.PARAMETER requiredBIOSmode

.EXAMPLE
    .\detect.ps1
.NOTES
    version: 1.2
    author: @dotjesper
    date: April 18, 2021
#>
#requires -version 5.1
[CmdletBinding()]
param (
    # variables
    [int]$requiredBIOSmode = 2, # [1] BIOS, [2] UEFI
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
    #endregion
    try {
        # detected BIOS mode
        Add-Type -Language CSharp -TypeDefinition @'
        using System;
        using System.Runtime.InteropServices;

        public class FirmwareType
        {
            [DllImport("kernel32.dll")]
            static extern bool GetFirmwareType(ref uint FirmwareType);

            public static uint GetFirmwareType()
            {
                uint firmwaretype = 0;
                if (GetFirmwareType(ref firmwaretype))
                    return firmwaretype;
                else
                    return 0;   // API call failed, just return 'unknown'
            }
        }
'@
        # validate BIOS mode
        [int]$detectedBIOSmode = [FirmwareType]::GetFirmwareType()
        switch ($detectedBIOSmode) {
            1 {
                Write-Output -InputObject "Detected BIOS mode: Legacy BIOS ($detectedBIOSmode)"
            }
            2 {
                Write-Output -InputObject "Detected BIOS mode: UEFI ($detectedBIOSmode)"
            }
            default {
                Write-Output -InputObject "Detected BIOS mode: Unknown ($detectedBIOSmode)"
            }
        }
        if ($detectedBIOSmode -eq $requiredBIOSmode) {
            exit 0
        }
        else {
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
