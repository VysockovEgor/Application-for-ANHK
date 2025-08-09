@echo off
cd %~dp0
rmdir /s /q "android\app\build" 2>nul
mkdir "android\app\build\intermediates\flutter\debug\flutter_assets\shaders"
icacls "android\app\build" /grant "Users:(OI)(CI)F"
flutter clean
flutter pub get
flutter run --no-enable-impeller 