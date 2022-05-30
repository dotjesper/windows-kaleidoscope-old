---
Title: README
Date: April 15, 2021
Author: dotjesper
Status: In development
---

[![Built for Windows 11](https://img.shields.io/badge/Built%20for%20Windows%2011-Yes-blue?style=flat)](https://windows.com/ "Built for Windows 11")
[![Built for Windows 10](https://img.shields.io/badge/Built%20for%20Windows%2010-Yes-blue?style=flat)](https://windows.com/ "Built for Windows 10")
[![Built for Windows Autopilot](https://img.shields.io/badge/Built%20for%20Windows%20Autopilot-Yes-blue?style=flat)](https://docs.microsoft.com/en-us/mem/autopilot/windows-autopilot/ "Windows Autopilot")

[![PSScriptAnalyzer verified](https://img.shields.io/badge/PowerShell%20Script%20Analyzer%20verified-Yes-green?style=flat)](https://docs.microsoft.com/en-us/powershell/module/psscriptanalyzer/ "PowerShell Script Analyzer")
[![PowerShell Constrained Language mode verified](https://img.shields.io/badge/PowerShell%20Constrained%20Language%20mode%20verified-No-green?style=flat)](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_modes/ "PowerShell Language mode")

# Proactive remediation: Collect firmware mode (UEFI or BIOS)

Collect firmware mode (UEFI or BIOS), fails is Firmware mode if not configured for UEFI

## Script package information

Required BIO Smode: **UEFI**

External logging: **No**

## Script package properties

### Basic

Name: **Collect firmware mode (UEFI or BIOS)**

Description: **Collect Firmware mode (UEFI or BIOS), fails is firmware mode if not configured for UEFI.**

Publisher: **Jesper Nielsen**

### Settings

Detection script: **Yes**

Remediation script: **No**

Run this script using the logged-on credentials: **No**

Enforce script signature check: **No**

Run script in 64-bit PowerShell: **No**

### Assignments

Schedule: **Weekly**

<details>
<summary>Click to expand notes</summary>

---

https://gallery.technet.microsoft.com/scriptcenter/Determine-UEFI-or-Legacy-7dc79488

#wmic /namespace:\\root\CIMV2\Security\MicrosoftTpm path Win32_Tpm get /value

#wmic /namespace:\\root\cimv2\security\microsofttpm path win32_tpm get IsEnabled_InitialValue

#wmic /namespace:\\root\cimv2\security\microsofttpm path win32_tpm get IsActivated_InitialValue

#wmic /namespace:\\root\cimv2\security\microsofttpm path win32_tpm get IsOwned

https://www.prajwaldesai.com/check-tpm-status-command-line/

$myBIOS = Get-WmiObject -Namespace "root\cimv2\security\microsofttpm" -Query "Select * from win32_tpm"

$myBIOS = Get-WmiObject -Namespace "root\cimv2\security\microsofttpm" -Query "Select SpecVersion from win32_tpm"

---

</details>