param(
  $Name,
  $ArtifactStagingPath = "$(& $PSScriptRoot/lib/Get-ArtifactStagingPath.ps1)",
  $ZipFile = "$ArtifactStagingPath/$Name.zip",
  $SolutionFolder = "solutions/$Name",
  $SrcFolder = "$SolutionFolder/src",
  $MapPath = "$SolutionFolder/map.xml",
  $PackageType = "Managed"
)

Write-Host "Variable of Compress-Solution.ps1 file"

Write-Host "$Name"
Write-Host "$ArtifactStagingPath"
Write-Host "$ZipFile"
Write-Host "$SolutionFolder"
Write-Host "$SrcFolder"
Write-Host "$MapPath"
Write-Host "$PackageType"

& $PSScriptRoot/lib/Install-Pac.ps1

pac solution pack `
  --zipfile $ZipFile `
  --folder $SrcFolder `
  --packagetype "Unmanaged" 

$ZipFile_managed = $("{0}/{1}_managed.zip" -f $ArtifactStagingPath, $Name)

pac solution pack `
  --zipfile $ZipFile_managed `
  --folder $SrcFolder `
  --packagetype "Managed"


#  --map $MapPath

Copy-Item `
  "$SolutionFolder/*.json" `
  $ArtifactStagingPath


Write-Host "End of Compress-Solution.ps1 file"