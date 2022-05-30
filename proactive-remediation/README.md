# Proactive remediation

**Proactive remediations** is a part of the Microsoft Endpoint Manager feature **Endpoint Analytics**. Proactive Remediations allows you to detect and fix common support issues on a user’s device. This also allows you to schedule scripts to run on all your devices at a certain time (hourly or daily) or do a run once.

## Script requirements

- You can have up to 200 script packages.
    - A script package can contain a detection script only or both a detection script and a remediation script.
- Ensure the scripts are encoded in UTF-8.
- If the option **Enforce script signature check** is enabled in the Settings page of creating a script package, then make sure that the scripts are encoded in UTF-8 not UTF-8 BOM.
- The maximum allowed output size limit is 2048 characters.
- If the option **Enforce script signature check** is enabled in the Script Package Settings page of creating a script package, the script runs using the device's PowerShell execution policy. The default execution policy for Windows client computers is **Restricted**. The default execution for Windows Server devices is **RemoteSigned**. For more information, see [PowerShell execution policies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies#powershell-execution-policies/ "PowerShell execution policies").
    - Scripts built into Proactive remediations are signed and the certificate is added to the **Trusted Publishers** certificate store of the device.
    - When using third-party scripts that are signed, make sure the certificate is in the **Trusted Publishers** certificate store. As with any certificate, the certificate authority must be trusted by the device.
    - Scripts without **Enforce script signature check** use the **Bypass** execution policy.
- Don't put secrets in scripts. Consider using parameters to handle secrets instead.
- Don't put reboot commands in detection or remediations scripts.

Read more [here](https://docs.microsoft.com/en-us/mem/analytics/proactive-remediations/ "Proactive remediations").

## Repository naming

All **Proactive remediations** script packages are either a **Collect** or a **Monitor** packages.

- **Collect** packages contains detection script only and is used for *collecting* non-remediable information, e.g., battery health, firmware data or similar information.
- **Monitor** packages contain both detection- and remediation scripts, for *monitoring* remediable settings, e.g., registry values, folders and files or similar information.

## Create and deploy script packages

The Microsoft Intune Management Extension service gets the scripts from Intune and runs them.

The scripts are rerun every 24 hours. You can copy the provided scripts and deploy them, or you can create your own script packages. 

To deploy script packages, follow the instructions [here](https://docs.microsoft.com/en-us/mem/analytics/proactive-remediations#bkmk_prs_ps1 "Create and deploy custom script packages").

## DISCLAIMER OF WARRANTIES

THE SOLUTIONS PROVIDED IS PROVIDED ON AN "AS IS" BASIS, WITHOUT ANY WARRANTIES OR REPRESENTATIONS EXPRESS, IMPLIED OR STATUTORY, INCLUDING, WITHOUT LIMITATION WARRANTIES OF QUALITY, PERFORMANCE, NONINFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. NOR ARE THERE ANY WARRANTIES CREATED BY A COURSE OR DEALING, COURSE OF PERFORMANCE OR TRADE USAGE. FURTHERMORE, THERE ARE NO WARRANTIES THAT THE SOFTWARE WILL MEET YOUR NEEDS OR BE FREE FROM ERRORS, OR THAT THE OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
