@echo off
chcp 65001 >nul
cd /d "%~dp0"
title Fooocus Installation

echo.
echo *** Fooocus - KI-Bildgenerator ***
echo *** Girls Day Installation      ***
echo.

:: Python pruefen
python --version >nul 2>&1
if errorlevel 1 (
    echo [FEHLER] Python nicht gefunden!
    echo Bitte Python 3.10 von python.org installieren.
    pause
    exit /b 1
)
echo [OK] Python gefunden.

:: In Fooocus-Unterverzeichnis wechseln
cd fooocus

:: Virtuelle Umgebung erstellen
if not exist "fooocus_env" (
    echo [1/5] Erstelle virtuelle Umgebung...
    python -m venv fooocus_env
)

:: Umgebung aktivieren
call fooocus_env\Scripts\activate.bat

:: pip updaten
python -m pip install --upgrade pip --quiet

:: Vorhandene torch-Version entfernen
echo [2/5] Entferne vorhandene PyTorch-Installation...
pip uninstall torch torchvision torchaudio -y >nul 2>&1

:: GPU-Treiber-Version ermitteln
set DRIVER_MAJOR=0
for /f "skip=1 tokens=1" %%a in ('nvidia-smi --query-gpu^=driver_version --format^=csv 2^>nul') do (
    if "%DRIVER_MAJOR%"=="0" (
        for /f "tokens=1 delims=." %%v in ("%%a") do set DRIVER_MAJOR=%%v
    )
)

:: Torch je nach Treiber installieren
echo [3/5] Installiere PyTorch mit GPU-Unterstuetzung...
echo [INFO] Erkannter Treiber (Major): %DRIVER_MAJOR%

set /a DRIVER_CHECK=%DRIVER_MAJOR%
if %DRIVER_CHECK% GEQ 570 (
    echo [INFO] RTX 50xx erkannt - nutze PyTorch cu128
    pip install torch==2.7.0+cu128 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128 --quiet
) else (
    echo [INFO] RTX 30xx/40xx erkannt - nutze PyTorch cu121
    pip install torch==2.1.0+cu121 torchvision==0.16.0 --extra-index-url https://download.pytorch.org/whl/cu121 --quiet
)

:: Abhaengigkeiten installieren
echo [4/5] Installiere weitere Pakete...
pip install -r requirements_versions.txt --quiet

:: Kritische Versionen nochmals sicherstellen
echo [5/5] Pruefe kritische Pakete...
pip install "jinja2==3.1.2" "markupsafe==2.1.5" "ffmpy==0.3.2" "starlette==0.27.0" "fastapi==0.99.0" --force-reinstall --quiet

echo.
echo *** Installation abgeschlossen! ***
echo *** Starte mit: start.bat        ***
echo.
pause