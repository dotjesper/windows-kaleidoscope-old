<#
.SYNOPSIS
    Collect Microsoft Defender BitLocker encryption method
.DESCRIPTION
    Collect Microsoft Defender BitLocker encryption method for System drive, fails if encryption differ fom requerements.
    Ref.: https://docs.microsoft.com/en-us/powershell/module/bitlocker/enable-bitlocker/
    Ref.: https://devblogs.microsoft.com/scripting/powershell-and-bitlocker-part-2/
.PARAMETER requiredEncryptionMethod
    3: AES-CBC 128-bit
    4: AES-CBC 256-bit
    6: XTS-AES 128-bit (default)
    7: XTS-AES 256-bit

.EXAMPLE
    .\detect.ps1
.NOTES
    version: 1.0
    author: @dotjesper
    date: June 3, 2021
#>
#requires -version 5.1
[CmdletBinding()]
param (
    # variables
    [int]$requiredEncryptionMethod = 6,
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
        [array]$encryptionMethod = Get-CimInstance -namespace "Root\cimv2\security\MicrosoftVolumeEncryption" -ClassName "Win32_Encryptablevolume" -Filter "DriveLetter = '$($env:SystemDrive)'"
        if ($($encryptionMethod.EncryptionMethod) -eq $requiredEncryptionMethod) {
            Write-Output -InputObject "Microsoft Defender BitLocker Drive encryption method for System drive compliant ($($encryptionMethod.EncryptionMethod))"
            exit 0
        }
        else {
            Write-Output -InputObject "Microsoft Defender BitLocker Drive encryption method for System drive non-compliant ($($encryptionMethod.EncryptionMethod))"
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
