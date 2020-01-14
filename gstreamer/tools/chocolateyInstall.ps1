$ErrorActionPreference = 'Stop';

# Strip package YYYYMMDD postfix if present
$versionSplit   = ${ENV:ChocolateyPackageVersion}.Split('.')
$major          = ${versionSplit}[0]
$minor          = ${versionSplit}[1]
$revision       = ${versionSplit}[2]
$version        = "${major}.${minor}.${revision}"

$packageName    = "${ENV:ChocolateyPackageName}"
$packageTitle   = "${ENV:ChocolateyPackageTitle}"
$url            = "https://gstreamer.freedesktop.org/data/pkg/windows/${version}/gstreamer-1.0-x86-${version}.msi"
$url64          = "https://gstreamer.freedesktop.org/data/pkg/windows/${version}/gstreamer-1.0-x86_64-${version}.msi"
$silentArgs     = "/qn /norestart /l*v `"$(${ENV:TEMP})\$(${packageName}).$(${version}).MsiInstall.log`""

$packageArgs = @{
  packageName     = "${packageName}"
  softwareName    = "${packageTitle}"
  url             = "${url}"
  url64           = "${url64}"
  fileType        = "msi"
  silentArgs      = "${silentArgs}"
  validExitCodes  = @(0)
  checksum        = "E9B9B36EDE71188FDCB8C987B693BEEA3597CF973C00BF5A8E09B2E8E599DCA0"
  checksumType    = "sha256"
  checksum64      = "86366081B3AD2C1031A0AFE31E4F1B95C9F581946480F1A509AF9D1E416BCB53"
  checksumType64  = "sha256"
}

Install-ChocolateyPackage @packageArgs

Write-Output ""

# Must install to User path since we need to expand a User environment variable
if (${ENV:OS_IS64BIT} -And -Not ${ENV:ChocolateyForceX86}) {
  Install-ChocolateyPath -PathToInstall "%GSTREAMER_1_0_ROOT_X86_64%\bin" -PathType "User"
} else {
  Install-ChocolateyPath -PathToInstall "%GSTREAMER_1_0_ROOT_X86%\bin" -PathType "User"
}