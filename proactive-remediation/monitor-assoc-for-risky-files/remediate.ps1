<#
.SYNOPSIS
    Monitor Windows default action for list of potentially Malicious file types.
.DESCRIPTION
    Monitor Windows default action for list of potentially Malicious file types.
    When looking at file names in Explorer, be aware Windows might hide the file extension for known file types.
    Please notice, changing default bahaviour to EDIT will cause scripts to open on e.g. Notepad if not properly prefixed with target executable.
    Potentially dangerous extensions: JSEFile, JSFile, regfile, VBEFile, VBSFile, WSFFile, batfile, cmdfile, htafile
.EXAMPLE
    .\detect.ps1
.NOTES
    version: 1.0
    author: @dotjesper
    date: December 21, 2020
#>
#requires -version 5.1
[CmdletBinding()]
param (
    # Variables
    [array]$fileTypes = @('JSEFile', 'JSFile', 'regfile', 'VBEFile', 'VBSFile', 'WSFFile', 'batfile', 'cmdfile', 'htafile'),
    [string]$fileAction = "edit"
)
begin {
    # variables :: environment
    [string]$regRoot = "HKLM"
    [string]$regPath = "SOFTWARE\Classes"
    [int]$scriptCounter = 0
    [string]$scriptOutput = "Output"
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
        foreach ($fileType in $fileTypes) {
            if (Test-Path -LiteralPath $($regRoot + ":\" + $regPath + "\" + $fileType)) {
                [string]$regValue = (Get-ItemProperty -LiteralPath "Registry::$regRoot\$regPath\$fileType\Shell")."(default)"
                if ($regValue -eq $fileAction) {
                    $scriptOutput = "$scriptOutput $fileType;$regValue"
                }
                elseif ([string]::IsNullOrEmpty($regValue)) {
                    $regValue = "null"
                    $scriptOutput = "$scriptOutput $fileType;$regValue"
                    [int]$scriptCounter = $scriptCounter + 1
                    $null = New-ItemProperty -LiteralPath "Registry::$regRoot\$regPath\$fileType\Shell" -Name "(default)" -Value $fileAction -PropertyType "String" -Force
                }
                else {
                    $scriptOutput = "$scriptOutput $fileType;$regValue"
                    [int]$scriptCounter = $scriptCounter + 1
                    $null = New-ItemProperty -LiteralPath "Registry::$regRoot\$regPath\$fileType\Shell" -Name "(default)" -Value $fileAction -PropertyType "String" -Force
                }
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
end {
    if ($scriptCounter -eq 0) {
        Write-Output -InputObject "File extension properly configured ($scriptOutput)"
        exit 0
    }
    else {
        Write-Output -InputObject "$scriptCounter file extension re-configured ($scriptOutput)"
        exit 1
    }
}
