param(
  [Parameter(Mandatory=$true)]
  [string]$Name,
  [string]$Path = "./$Name.zip",
  [string]$Folder = "solutions/$Name/src",
  [string]$PackageType = "Both",
  [Parameter(Mandatory=$true)]
  [string]$Url,
  [Parameter(Mandatory=$true)]
  [string]$ClientId,
  [Parameter(Mandatory=$true)]
  [string]$ClientSecret,
  [Parameter(Mandatory=$true)]
  [string]$TenantId
)
Write-Host "calling Create-AuthProfile.ps1 ..."
& $PSScriptRoot/lib/Create-AuthProfile.ps1 `
  -Url $Url `
  -ClientId $ClientId `
  -ClientSecret $ClientSecret `
  -TenantId $TenantId

Write-Host "Finished calling Create-AuthProfile.ps1 ..."

Write-Host "calling switch ..."

if ( Test-Path $path)
{
  Write-Host "Delete $Path"
  del $path
  Write-Host "Deleted $Path"
}
[string]$ManagedPath = "./$Name" + "_managed.zip"
if ( Test-Path $ManagedPath)
{
  Write-Host "Delete $ManagedPath"
  del $ManagedPath
  Write-Host "Deleted $ManagedPath"
}

switch($PackageType)
{
  "Both" {
    <#
    1..2 | ForEach-Object -Parallel {
      switch ($_) {
        1 {
          & $using:PSScriptRoot/lib/Export-Managed.ps1 `
            -PackageType $using:PackageType `
            -Path $using:Path `
            -Name $using:Name
        }
        2 {
          & $using:PSScriptRoot/lib/Export-Unmanaged.ps1 `
            -Path $using:Path `
            -Name $using:Name
        }
      }
    }
    #>
    & $PSScriptRoot/lib/Export-Managed.ps1 `
      -PackageType $PackageType `
      -Path $Path `
      -Name $Name

    & $PSScriptRoot/lib/Export-Unmanaged.ps1 `
    -Path $Path `
    -Name $Name
  }
  "Managed" {
    & $PSScriptRoot/lib/Export-Managed.ps1 `
      -PackageType $PackageType `
      -Path $Path `
      -Name $Name
  }
  "Unmanaged" {
    & $PSScriptRoot/lib/Export-Unmanaged.ps1 `
      -Path $Path `
      -Name $Name
  }
}
# create an empty test and prod config file 
$configFile = @( ".\$Name\config.test.json", ".\$Name\config.prod.json") | ForEach-Object -Process {
    if (-not ( Test-Path $_) )
    {
        Write-Host "Create empty $_"
        "{}" | Out-File $_
    }
}

pac solution unpack `
  --zipfile $Path `
  --folder $Folder `
  --packagetype $PackageType `
  --allowDelete

