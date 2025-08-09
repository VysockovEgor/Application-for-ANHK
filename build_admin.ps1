$ErrorActionPreference = "Stop"

# Get the current directory
$projectDir = $PSScriptRoot

# Remove existing build directory
Remove-Item -Path "$projectDir\android\app\build" -Recurse -Force -ErrorAction SilentlyContinue

# Create necessary directories
New-Item -Path "$projectDir\android\app\build\intermediates\flutter\debug\flutter_assets\shaders" -ItemType Directory -Force

# Set proper permissions
$acl = Get-Acl "$projectDir\android\app\build"
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($rule)
$acl | Set-Acl "$projectDir\android\app\build"

# Run Flutter commands
Set-Location $projectDir
flutter clean
flutter pub get
flutter run --no-enable-impeller 