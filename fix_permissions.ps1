$shaderPath = "android/app/build/intermediates/flutter/debug/flutter_assets/shaders"
New-Item -ItemType Directory -Force -Path $shaderPath
$acl = Get-Acl $shaderPath
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users","FullControl","Allow")
$acl.SetAccessRule($accessRule)
Set-Acl $shaderPath $acl 