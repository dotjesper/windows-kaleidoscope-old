<#
.SYNOPSIS
    Monitor the status of Microsoft OneDrive for Business Known Folder Move (KFM).
.DESCRIPTION
    Today, organizations, can benefit from monitoring the use of Microsoft OneDrive for Business, and in particular the status of Known Folder Move (KFM), enabling OneDrive Health monitoring using https://config.office.com/officeSettings/onedrive/.
    However; in the case where a devices have issues, moving one or more folder to Microsoft OneDrive for Business, this script will monitor and remidiate (re-initilize) the Known Folder Move (KFM) process.
.EXAMPLE
    .\detect.ps1
.NOTES
    version: 1.0
    author: @dotjesper
    date: May 28, 2022
#>
#requires -version 5.1
[CmdletBinding()]
param (
    # variables
)
begin {
    # variables :: environment
    # variables :: conditions
    [bool]$runScriptIn64bitPowerShell = $true
}
process {
    #region check conditions
    if ($runScriptIn64bitPowerShell -eq $true -and $([System.Environment]::Is64BitProcess) -eq $false) {
        Write-Output -InputObject "Windows PowerShell 64-bit is requered."
        exit 1
    }
    #endregion
    try {
        [string]$regRoot = "HKCU"
        [string]$regPath = "SOFTWARE\Microsoft\OneDrive\Accounts\Business1"
        [array]$regValues = Get-ItemProperty -Path "Registry::$regRoot\$regPath"
        if ($regValues.KfmFoldersProtectedNow -eq $regValues.KfmSilentAttemptedFolders) {
            Write-Output -InputObject "OneDrive Known Folder Move for Business1 is moved correctly [$($regValues.KfmFoldersProtectedNow)]."
            exit 0
        }
        else {
            Remove-ItemProperty -Path "Registry::$regRoot\$regPath" -Name "KfmIsDoneSilentOptIn"
            if ($stopProcess) {
                $onedriveProcesses = Get-Process -Name "OneDrive"
                foreach ($onedriveProcess in $onedriveProcesses) {
                    Stop-Process -Id $($onedriveProcess.Id) -Force
                }
            }
            Write-Output -InputObject "OneDrive Known Folder Move for Business1 has been reinitiated."
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
