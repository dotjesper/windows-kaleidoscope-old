<#
.SYNOPSIS
    Collect Windows system stability index
.DESCRIPTION
    Based on the Reliability and Performance Monitor data. The Reliability Monitor will show users the System Stability Index for that day together with additional information, in case any important system events took place.
    This script will collect the Reliability and Performance Monitor data and based on the avarage systemStabilityIndex avaliable and score this from 1 to 10.
.PARAMETER reliabilityStabilityThreshold
    Defines the minimum reliability stability average value for script to report 'failed'.
.EXAMPLE
    .\detect.ps1
.NOTES
    version: 1.2
    author: @dotjesper
    date: April 22, 2021
#>
#requires -version 5.1
[CmdletBinding()]
param (
    # variables
    [int]$reliabilityStabilityThreshold = 4,
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
        [array]$ReliabilityStabilityMetrics = Get-Ciminstance -ClassName Win32_ReliabilityStabilityMetrics | Measure-Object -Average -Maximum  -Minimum -Property systemStabilityIndex
        $reliabilityStabilityAverage = [math]::Round($($reliabilityStabilityMetrics.Average), 2)
        $reliabilityStabilityMaximum = [math]::Round($($reliabilityStabilityMetrics.Maximum), 2)
        $reliabilityStabilityMinimum = [math]::Round($($reliabilityStabilityMetrics.Minimum), 2)
        if ($($reliabilityStabilityMetrics.Average) -gt $reliabilityStabilityThreshold) {
            Write-Output -InputObject "Reliability index is above the index threshold (Avr $reliabilityStabilityAverage Max $reliabilityStabilityMaximum Min $reliabilityStabilityMinimum)"
            exit 0
        }
        else {
            Write-Output -InputObject "Reliability index is below the index threshold (Avr $reliabilityStabilityAverage Max $reliabilityStabilityMaximum Min $reliabilityStabilityMinimum)"
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
