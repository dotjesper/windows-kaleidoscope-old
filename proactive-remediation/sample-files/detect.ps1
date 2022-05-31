<#
.SYNOPSIS
    Hello world sample script for exploring proactive remediation
.DESCRIPTION
    Hello world sample script for exploring proactive remediation functionality
.PARAMETER doTest
    Select the test, 1 - 11
.PARAMETER doFail
    If set to $true, the script will exit with 1, equals the detection script will fail.
.EXAMPLE
    .\detect.ps1
.NOTES
    version: 1.6
    author: @dotjesper
    date: May 31, 2022
#>
#requires -version 5.1
[CmdletBinding()]
param (
    #variables
    [int]$doTest,
    [bool]$doFail = $false
)
begin {
    #variables :: environment
    [string]$fLogContentFile = "$($Env:ProgramData)\Microsoft\IntuneManagementExtension\Logs\hello-world-M$($doTest).log"

    #variables :: conditions
    [bool]$runScriptIn64bitPowerShell = $false
    #region :: functions
    function fLogContent () {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory = $true)]
            [string]$fLogContent,
            [Parameter(Mandatory = $false)]
            [string]$fLogContentComponent
        )
        begin {
            $fdate = $(Get-Date -Format "M-dd-yyyy")
            $ftime = $(Get-Date -Format "HH:mm:ss.fffffff")
        }
        process {
            if (!(Test-Path -Path "$(Split-Path -Path $fLogContentFile)")) {
                New-Item -itemType "Directory" -Path "$(Split-Path -Path $fLogContentFile)" | Out-Null
            }
            Add-Content -Path $fLogContentFile -Value "<![LOG[[$fLogContentpkg] $($fLogContent)]LOG]!><time=""$($ftime)"" date=""$($fdate)"" component=""$fLogContentComponent"" context="""" type="""" thread="""" file="""">" | Out-Null
        }
        end {}
    }
    #endregion
}
process {
    Write-Verbose -Message "Content log file: $($fLogContentFile)"
    #region :: check conditions
    if ($runScriptIn64bitPowerShell -eq $true -and $([System.Environment]::Is64BitProcess) -eq $false) {
        Write-Output -InputObject "Script must be run using 64-bit PowerShell."
        exit 1
    }
    #endregion
    try {
        #region :: doTest
        switch ($doTest) {
            1 {
                # Multiple Write-Output lines
                Write-Output -InputObject "($doTest) Hello world: Write-Output line 1"
                Write-Output -InputObject "($doTest) Hello world: Write-Output line 2"
            }
            2 {
                # Write-Output with carriage return and new line (`r`n)
                Write-Output -InputObject "($doTest) Hello world: Write-Output line 1`r`nHello world: Write-Output line 2"
            }
            3 {
                # Multiple Write-Host lines
                Write-Host "($doTest) Hello world: Write-Host line 1"
                Write-Host "($doTest) Hello world: Write-Host line 2"
            }
            4 {
                # Write-Host with carriage return and new line (`r`n)
                Write-Host " ($doTest) Hello world: Write-Output line 1`r`nHello world: Write-Output line 2"
            }
            5 {
                # Multiple Write-Host with carriage return and new line (`r`n)
                Write-Host "($doTest) Hello world: Write-Output line 1" -NoNewline
                Write-Host "`r`n($doTest) Hello world: Write-Output line 2"
            }
            6 {
                # Write-Error
                Write-Error -Message "($doTest) Error message" -Category "NotSpecified"
            }
            7 {
                # Write-Verbose
                Write-Verbose -Message "($doTest) Verbose message"
            }
            8 {
                # Multiple Write-Verbose
                Write-Verbose -Message "($doTest) Verbose message 1"
                Write-Verbose -Message "($doTest) Verbose message 2"
            }
            9 {
                # Write-Output and Write-Error
                Write-Output -InputObject "($doTest) Hello world: Write-Output line 1"
                Write-Error -Message "($doTest) Error message" -Category "NotSpecified"
            }
            10 {
                # Write-Output
                Write-Output -InputObject "($doTest) Hello world | $((Get-Culture).KeyboardLayoutId) | $($ExecutionContext.SessionState.LanguageMode) | $((Get-Culture).Name) | $($Env:USERNAME)"
            }
            11 {
                # Write-Output and add to log file
                Write-Output -InputObject "($doTest) Hello world: Write-Output line 1"
                #region :: logfile environment entries
                try {
                    fLogContent -fLogContent "## Hello world sample script for exploring proactive remediation" -fLogContentComponent ""
                    fLogContent -fLogContent "Description: Hello world sample script for exploring proactive remediation functionality" -fLogContentComponent ""
                    fLogContent -fLogContent "Log file: $($fLogContentFile)" -fLogContentComponent ""
                    fLogContent -fLogContent "Script name: $($MyInvocation.MyCommand.Name)" -fLogContentComponent ""
                    fLogContent -fLogContent "Script folder: $(Split-Path -Parent -Path $MyInvocation.MyCommand.Path)" -fLogContentComponent ""
                    fLogContent -fLogContent "Command line: $($MyInvocation.Line)" -fLogContentComponent ""
                    fLogContent -fLogContent "Run script in 64 bit PowerShell: $runScriptIn64bitPowerShell" -fLogContentComponent ""
                    fLogContent -fLogContent "Running 64 bit PowerShell: $([System.Environment]::Is64BitProcess)" -fLogContentComponent ""
                    if ($($ExecutionContext.SessionState.LanguageMode) -eq "FullLanguage") {
                        fLogContent -fLogContent "Running elevated: $(([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))" -fLogContentComponent ""
                        fLogContent -fLogContent "Detected user: $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)" -fLogContentComponent ""
                    }
                    else {
                        fLogContent -fLogContent "Detected user: $($Env:USERNAME)" -fLogContentComponent ""
                    }
                    fLogContent -fLogContent "Detected keyboard layout Id: $((Get-Culture).KeyboardLayoutId)" -fLogContentComponent ""
                    fLogContent -fLogContent "Detected language mode: $($ExecutionContext.SessionState.LanguageMode)" -fLogContentComponent ""
                    fLogContent -fLogContent "Detected culture name: $((Get-Culture).Name)" -fLogContentComponent ""
                    fLogContent -fLogContent "Detected OS build: $($([environment]::OSVersion.Version).Build)" -fLogContentComponent ""
                    fLogContent -fLogContent "($doTest) Hello world: Write-Output line 1." -fLogContentComponent "$($logfileItem.fLogContentComponent)"
                    fLogContent -fLogContent "($doTest) Hello world: Write-Output line 2." -fLogContentComponent "$($logfileItem.fLogContentComponent)"
                    fLogContent -fLogContent "($doTest) Hello world: Write-Output line 3." -fLogContentComponent "$($logfileItem.fLogContentComponent)"
                    fLogContent -fLogContent "($doTest) Hello world: Write-Output line 24." -fLogContentComponent "$($logfileItem.fLogContentComponent)"
                }
                catch {
                    $errMsg = $_.Exception.Message
                    Write-Error -Message $errMsg
                    fLogContent -fLogContent "ERROR: $errMsg" -fLogContentComponent ""
                    exit 1
                }
                finally {}
                #endregion
            }
            Default {
                Write-Output -InputObject "($doTest) No or undefined test selected."
            }
        }
        #endregion
        #region :: exit code
        if ($doFail -eq $true) {
            exit 1
        }
        else {
            exit 0
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

