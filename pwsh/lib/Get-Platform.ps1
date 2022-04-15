Write-Output "azdops"
<#
if ([string]::IsNullOrEmpty($env:GITHUB_PATH))
{
  Write-Output "azdops"
} else {
  Write-Output "github"
}
#>
Write-Host "End of Get-Platform.ps1 file"