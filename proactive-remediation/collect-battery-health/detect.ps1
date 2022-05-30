<#
.SYNOPSIS
    Detect presence of battery and collect battery health
.DESCRIPTION
    Actively monitoring the battery health throughout your Windows devices, allowing proactive battery replacement prior to have to remediate battery issues reactively.
.PARAMETER batteryHealthThreshold
    Define mminimum battery health threshold. Valid range 0-100
.EXAMPLE
    .\detect.ps1
.NOTES
    version: 1.2.0.2
    author: @dotjesper
    date: April 15, 2021
#>
#requires -version 5.1
[CmdletBinding()]
param (
    # Variables
    [ValidateRange(0, 100)]
    [int]$batteryHealthThreshold = 40,
    [bool]$runScriptIn64bitPowerShell = $false
)
begin {
    # variables :: environment
    [int]$batteryReplaceCounter = 0
}
process {
    #region check conditions
    if ($runScriptIn64bitPowerShell -eq $true -and $([System.Environment]::Is64BitProcess) -eq $false) {
        Write-Output -InputObject "Windows PowerShell 64-bit is requered."
        exit 1
    }
    #endregion
    try {
        if (Get-CimInstance -ClassName win32_battery) {
            $win32_batteryDeviceIDs = Get-CimInstance -ClassName win32_battery -Namespace ROOT/CIMV2:CIM_Battery | Select-Object -ExpandProperty DeviceID
            $batteryReplaceText = "Batteries found: $($win32_batteryDeviceIDs.Count)"
            foreach ($win32_batteryDeviceID in $win32_batteryDeviceIDs) {
                $batteryInstanceName = Get-WmiObject -Class "BatteryStaticData" -Namespace "ROOT\WMI" | Where-Object { $_.UniqueID -eq $win32_batteryDeviceID } | Select-Object -ExpandProperty InstanceName
                $batteryDesignedCapacity = Get-WmiObject -Class "BatteryStaticData" -Namespace "ROOT\WMI" | Where-Object { $_.InstanceName -eq $batteryInstanceName } | Select-Object -ExpandProperty DesignedCapacity
                $batteryFullChargedCapacity = Get-WmiObject -Class "BatteryFullChargedCapacity" -Namespace "ROOT\WMI" | Where-Object { $_.InstanceName -eq $batteryInstanceName } | Select-Object -ExpandProperty FullChargedCapacity
                # determine battery status percentage
                [int]$batteryHealth = ($batteryFullChargedCapacity / $batteryDesignedCapacity) * 100
                if ($batteryHealth -le $batteryHealthThreshold) {
                    [int]$batteryReplaceCounter = $batteryReplaceCounter + 1
                }
                [string]$batteryReplaceText = "$batteryReplaceText" + ", " + "$batteryHealth" + "%"
            }
            if ($batteryReplaceCounter -gt 0) {
                Write-Output -InputObject "Battery replacement required ($batteryReplaceText)"
                exit 1
            }
            else {
                Write-Output -InputObject "Battery replacement not required ($batteryReplaceText)"
                exit 0
            }
        }
        else {
            Write-Output -InputObject "Battery not found or unable to obtain battery information from WMI!"
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
