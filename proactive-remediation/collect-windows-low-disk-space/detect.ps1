<#
.SYNOPSIS
    Collect low disk space inventory.
.DESCRIPTION
    Collect Windows disk usage, fails if system disk space usage is above defined disk space usage threshold.
.PARAMETER diskSpaceUsageThreshold
    Windows disk usage threshold in percentages (0-100).
.PARAMETER diskSpaceUsageMeasureMethod
    Disk space usage measure method. 1. Class: Win32_logicaldisk 2. Class: win32_volume
.EXAMPLE
    .\detect.ps1
.EXAMPLE
    .\detect.ps1 -diskSpaceUsageThreshold 80 -diskSpaceUsageMeasureMethod 2 -Verbose
.NOTES
    version: 1.1
    author: @dotjesper
    date: May 6, 2021
#>
#requires -version 5.1
[CmdletBinding()]
param (
    # variables
    [int]$diskSpaceUsageThreshold = 80,
    [int]$diskSpaceUsageMeasureMethod = 1,
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
        switch ($diskSpaceUsageMeasureMethod) {
            1 {
                $SystemDrive = Get-CimInstance -ClassName "Win32_LogicalDisk" -Filter "DeviceID = '$($Env:SystemDrive)'"
                [int]$systemDriveSize = ([math]::truncate($SystemDrive.Size / 1GB))
                [int]$systemDriveSizeRemaining = ([math]::truncate($SystemDrive.FreeSpace / 1GB))
            }
            2 {
                $SystemDrive = Get-CimInstance -ClassName "Win32_Volume" -Filter "DriveLetter = '$($Env:SystemDrive)'"
                [int]$systemDriveSize = ([math]::truncate($SystemDrive.Capacity / 1GB))
                [int]$systemDriveSizeRemaining = ([math]::truncate($SystemDrive.FreeSpace / 1GB))
            }
        }
        Write-Verbose -Message "System drive size: $systemDriveSize GB ($($SystemDrive.DriveLetter))"
        Write-Verbose -Message "System drive size remaining: $systemDriveSizeRemaining GB ($($SystemDrive.DriveLetter))"
        [int]$diskSpaceUsage = $systemDriveSize - $systemDriveSizeRemaining
        Write-Verbose -Message "$diskSpaceUsage GB used"
        [int]$diskSpaceUsage = ([math]::truncate((($systemDriveSize - $systemDriveSizeRemaining) * 100) / $systemDriveSize))
        Write-Verbose -Message "$diskSpaceUsage% used"
        if ($diskSpaceUsage -gt $diskSpaceUsageThreshold) {
            Write-Output -InputObject "Disk usage on $($SystemDrive.DriveLetter) drive is abowe the threshold ($diskSpaceUsage% used | size: $systemDriveSize GB)"
            exit 1
        }
        else {
            Write-Output -InputObject "Disk usage on $($SystemDrive.DriveLetter) drive is below the threshold ($diskSpaceUsage% used | size: $systemDriveSize GB)"
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
