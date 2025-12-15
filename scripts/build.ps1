param(
    [switch]$SkipTest
)

$ErrorActionPreference = "Stop"

# Get version
$versionLine = Get-Content pubspec.yaml | Where-Object { $_ -match '^version:' }
$version = ($versionLine -replace 'version:\s*', '') -replace '\+.*', ''
Write-Host "Building zipnao v$version" -ForegroundColor Cyan

# Dependencies
Write-Host "Fetching dependencies..." -ForegroundColor Yellow
flutter pub get

if (-not $SkipTest) {
    # Test
    Write-Host "Running tests..." -ForegroundColor Yellow
    flutter test
    if ($LASTEXITCODE -ne 0) { exit 1 }

    # Analyze
    Write-Host "Analyzing code..." -ForegroundColor Yellow
    flutter analyze
    if ($LASTEXITCODE -ne 0) { exit 1 }
}

# Build
Write-Host "Building for Windows..." -ForegroundColor Yellow
flutter build windows --release

# Package
New-Item -ItemType Directory -Force -Path dist | Out-Null
$outputPath = "dist\zipnao-$version-windows.zip"
Compress-Archive -Path "build\windows\x64\runner\Release\*" -DestinationPath $outputPath -Force

Write-Host "Build complete: $outputPath" -ForegroundColor Green
