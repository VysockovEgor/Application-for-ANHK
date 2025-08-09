@echo off
echo Starting permission fix script...
echo.

echo Step 1: Cleaning previous build...
rmdir /s /q "android\app\build" 2>nul
rmdir /s /q "build" 2>nul

echo Step 2: Creating directories...
mkdir "android\app\build\intermediates\flutter\debug\flutter_assets\shaders" 2>nul

echo Step 3: Setting permissions...
echo y| cacls "android\app\build" /T /E /G Everyone:F
echo y| cacls "android\app\build\intermediates" /T /E /G Everyone:F
echo y| cacls "android\app\build\intermediates\flutter" /T /E /G Everyone:F
echo y| cacls "android\app\build\intermediates\flutter\debug" /T /E /G Everyone:F
echo y| cacls "android\app\build\intermediates\flutter\debug\flutter_assets" /T /E /G Everyone:F
echo y| cacls "android\app\build\intermediates\flutter\debug\flutter_assets\shaders" /T /E /G Everyone:F

echo.
echo Step 4: Running Flutter commands...
echo Running flutter clean...
call flutter clean
if errorlevel 1 (
    echo Failed to run flutter clean
    pause
    exit /b 1
)

echo Running flutter pub get...
call flutter pub get
if errorlevel 1 (
    echo Failed to run flutter pub get
    pause
    exit /b 1
)

echo Running flutter run with Paint.enableDithering disabled...
set FLUTTER_DISABLE_DITHERING=true
call flutter run -d 22126RN91Y --no-enable-impeller
if errorlevel 1 (
    echo Failed to run flutter
    pause
    exit /b 1
)

echo.
echo Script completed. Press any key to exit...
pause 