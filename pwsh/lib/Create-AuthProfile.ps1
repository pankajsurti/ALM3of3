param(
  [Parameter(Mandatory=$true)]
  [string]$Url,
  [Parameter(Mandatory=$true)]
  [string]$ClientId,
  [Parameter(Mandatory=$true)]
  [string]$ClientSecret,
  [Parameter(Mandatory=$true)]
  [string]$TenantId
)

& $PSScriptRoot/Install-Pac.ps1
Write-Host "calling pac auth create..."
pac auth create `
  --url $Url `
  --applicationId $ClientId `
  --clientSecret $ClientSecret `
  --tenant $TenantId
Write-Host "finished calling pac auth create..."
