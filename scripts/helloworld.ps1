param (
    [Parameter(Mandatory = $true)][string]$rg,
    [Parameter(Mandatory = $true)][string]$location
)

#$rg = 'buildkite-rg'
#$location = 'Central India'
Import-Module -Name Az -Force
$AzModule = (Get-Module Az -ErrorAction SilentlyContinue).Version
if (!(($AzModule.Major -ge 5 -and $AzModule.Minor -ge 0 -and $AzModule.Build -ge 0))) {
  throw "Please install Azure PowerShell version 5.0.0"
}
Write-output "=============================="
Write-output "Hello buildkite from powershell"
# $cred = New-Object System.Management.Automation.PSCredential($serviceprincipalid, ($serviceprincipal | ConvertTo-SecureString -AsPlainText -Force))
# Login-AzAccount -Credential $cred -ServicePrincipal -Subscription $SubscriptionId -Tenant $tenantid

Get-AzContext
$buildkiterge = Get-AzResourceGroup -Name $rg -ErrorAction SilentlyContinue
$buildkiterge
Connect-AzAccount
if (!$buildkiterge) {
  New-AzResourceGroup -Name $rg -Location $location -verbose
  write-output "Resource Group ($rg) created....."
}
else {
  write-output "Resource Group ($rg) exists....."
}
New-AzResourceGroupDeployment -ResourceGroupName $rg -Name 'stoage-deployment' -TemplateFile '.\templates\StorageAccount.json' -Verbose
Write-output "====== Thank You just to check no offense nor credential ====="
