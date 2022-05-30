---
Title: README
Date: May 30, 2022
Author: dotjesper
Status: In development
---

# Windows kaleidoscope

[![Built for Windows 11](https://img.shields.io/badge/Built%20for%20Windows%2011-Yes-blue?style=flat)](https://windows.com/ "Built for Windows 11")
[![Built for Windows 10](https://img.shields.io/badge/Built%20for%20Windows%2010-Yes-blue?style=flat)](https://windows.com/ "Built for Windows 10")
[![Built for Windows Autopilot](https://img.shields.io/badge/Built%20for%20Windows%20Autopilot-Yes-blue?style=flat)](https://docs.microsoft.com/en-us/mem/autopilot/windows-autopilot/ "Windows Autopilot")

[![PSScriptAnalyzer verified](https://img.shields.io/badge/PowerShell%20Script%20Analyzer%20verified-Yes-green?style=flat)](https://docs.microsoft.com/en-us/powershell/module/psscriptanalyzer/ "PowerShell Script Analyzer")
[![PowerShell Constrained Language mode verified](https://img.shields.io/badge/PowerShell%20Constrained%20Language%20mode%20verified-Yes-green?style=flat)](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_modes/ "PowerShell Language mode")

This repository contains the source code for the Windows kaleidoscope project.

According to Wikipedia, kaleidoscope is an optical instrument with two or more reflecting surfaces (or mirrors) tilted to each other at an angle, so that one or more (parts of) objects on one end of these mirrors are shown as a regular symmetrical pattern when viewed from the other end, due to repeated reflection

> A kaleidoscope is used for observation of beautiful forms.

The **Windows kaleidoscope** project is exactly that, an optical instrument, to shown device insights as a regular symmetrical pattern adding beautiful forms.

This repository is under development and alive and for the most, kicking - I welcome any feedback or suggestions for improvement. Reach out on [Twitter](https://twitter.com/dotjesper "dotjesper"), I read Direct Messages (DMs) and allow them from people I do not follow. For other means of contact, please visit [https://dotjesper.com/contact/](https://dotjesper.com/contact/ "Contact")

Do not hesitate to reach out if issues arise or new functionality and improvement comes to mind.

Feel free to fork and build.

This is a personal development, please respect the community sharing philosophy and be nice!

## Goal

The goal of Windows kaleidoscope is primarily to host, and share, detection and remediation scripts, used for **Endpoint Analytics | Proactive Remediation**. Furthermore, this repository contains scripts used to extract Endpoint Analytics information.

Windows kaleidoscope scripts can easily be implemented using more traditionally deployment methods, e.g., Operating System Deployment Task Sequence deployment or similar methods utilized.

## Synopsis

Endpoint analytics is part of the Microsoft Productivity Score. These analytics give you insights for measuring how your organization is working and the quality of the experience you're delivering to your users. Endpoint analytics can help identify policies or hardware issues that may be slowing down devices and help you proactively make improvements before end-users generate a help desk ticket.

Endpoint analytics aims to improve user productivity and reduce IT support costs by providing insights into the user experience. The insights enable IT to optimize the end-user experience with proactive support and to detect regressions to the user experience by assessing user impact of configuration changes.

## Prerequisites

Devices must be Azure AD joined or hybrid Azure AD joined and enrolled in Microsoft Intune.

### Proactive remediation scripting prerequisites:

Whether enrolling devices via Microsoft Intune or Configuration Manager, Proactive remediation scripting has the following requirements:
- Is managed by Intune and runs an Enterprise, Professional, or Education edition of Windows 10 or later.
- A co-managed device running Windows 10, version 1903 or later. Co-managed devices on preceding versions of Windows 10 will need the Client apps workload pointed to Intune (only applicable up to version 1607).

## Licensing Prerequisites

Devices enrolled in Endpoint analytics need a valid license for the use of Microsoft Endpoint Manager. For more information, see Microsoft Intune licensing or Microsoft Endpoint Configuration Manager licensing.

Proactive remediations also requires users of the devices to have one of the following licenses:

- Windows 10/11 Enterprise E3 or E5 (included in Microsoft 365 F3, E3, or E5)
- Windows 10/11 Education A3 or A5 (included in Microsoft 365 A3 or A5)
- Windows 10/11 Virtual Desktop Access (VDA) per user

Read more [here](https://docs.microsoft.com/en-us/mem/analytics/overview "What is Endpoint analytics?").

## Requirements

Windows kaleidoscope is developed and tested for Windows 10 21H1 Pro and Enterprise 64-bit and newer and require PowerShell 5.1.

## Repository content

```
├── proactive-remediation
│  ├─ collect-battery-health
│  ├─ collect-device-hardware-hash (preview)
│  ├─ collect-firmware-mode
│  ├─ collect-hypervisor-presence
│  ├─ collect-last-bootUp-time
│  ├─ collect-msft-defender-bitlocker-encryption-settings
│  ├─ collect-systemroot
│  ├─ collect-windows-low-disk-space
│  ├─ collect-windows-system-stability-index
│  ├─ monitor-additional-lsa-protection
│  ├─ monitor-assoc-for-risky-files
│  ├─ monitor-onedrive-kfm
│  ├─ monitor-posh-execution-policy
│  ├─ monitor-windows-unquoted-service-paths
│  ├─ monitor-windows-update-dynamic-active-hours
│  ├─ sample-files
├─ startup-performance
│  ├─ <empty>
├─ work-from-anywhere
│  ├─ <empty>
```

## Disclaimer

This is not an official repository, and is not affiliated with Microsoft, the **Windows kaleidoscope** repository is not affiliated with or endorsed by Microsoft. The names of actual companies and products mentioned herein may be the trademarks of their respective owners. All trademarks are the property of their respective companies.

## Legal and Licensing

**Windows kaleidoscope** is licensed under the [MIT license](./license 'MIT license').

The information and data of this repository and its contents are subject to change at any time without notice to you. This repository and its contents are provided AS IS without warranty of any kind and should not be interpreted as an offer or commitment on the part of the author(s). The descriptions are intended as brief highlights to aid understanding, rather than as thorough coverage.

## Change log

<details>
<summary>Click to expand change log</summary>

---

*Version 0.9.9.0 | May 30. 2022*

---

</details>
