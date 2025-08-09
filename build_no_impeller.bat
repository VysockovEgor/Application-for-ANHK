@echo off
echo Cleaning previous build...
flutter clean

echo Getting dependencies...
flutter pub get

echo Building with Impeller disabled...
flutter build apk --no-enable-impeller

echo Done! Check the build/app/outputs/flutter-apk/ directory for your APK.
pause 