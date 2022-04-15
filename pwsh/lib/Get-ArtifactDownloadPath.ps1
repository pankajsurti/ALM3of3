param(
  [Parameter(Mandatory=$true)]
  $ArtifactName = "solution-artifact"
)

$platform = & $PSScriptRoot/Get-Platform.ps1
switch($platform) {
  "azdops" {
    Write-Output "$env:PIPELINE_WORKSPACE/$ArtifactName"
  }
  "github" {
    Write-Output "$(Get-Location)/$ArtifactName"
  }
}
Write-Host "End of Get-ArtifactDownloadPath.ps1 file"