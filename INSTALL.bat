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

:: In das Fooocus-Unterverzeichnis wechseln
cd fooocus

:: Virtuelle Umgebung erstellen
if not exist "fooocus_env" (
    echo [1/4] Erstelle virtuelle Umgebung...
    python -m venv fooocus_env
)

:: Umgebung aktivieren
call fooocus_env\Scripts\activate.bat

:: pip updaten
python -m pip install --upgrade pip --quiet

:: CUDA-Version erkennen (robuste Methode)
set CUDA_MAJOR=12
set CUDA_MINOR=1
for /f "tokens=*" %%a in ('nvidia-smi ^| findstr /C:"CUDA Version"') do (
    for /f "tokens=9" %%v in ("%%a") do set FULL_VER=%%v
)
for /f "tokens=1 delims=." %%a in ("%FULL_VER%") do set CUDA_MAJOR=%%a
for /f "tokens=2 delims=." %%b in ("%FULL_VER%") do set CUDA_MINOR=%%b
echo [INFO] Erkannte CUDA-Version: %FULL_VER% (Major: %CUDA_MAJOR%, Minor: %CUDA_MINOR%)

:: Torch je nach CUDA installieren
echo [2/4] Installiere PyTorch mit GPU-Unterstuetzung...

if %CUDA_MAJOR% EQU 12 (
    if %CUDA_MINOR% GEQ 8 (
        echo [INFO] Nutze PyTorch cu128 fuer RTX 50xx
        pip install torch==2.7.0+cu128 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128 --quiet
    ) else (
        echo [INFO] Nutze PyTorch cu121 fuer RTX 30xx/40xx
        pip install torch==2.1.0+cu121 torchvision==0.16.0 --extra-index-url https://download.pytorch.org/whl/cu121 --quiet
    )
) else (
    echo [INFO] Nutze PyTorch cu121 als Standard
    pip install torch==2.1.0+cu121 torchvision==0.16.0 --extra-index-url https://download.pytorch.org/whl/cu121 --quiet
)

:: Jinja2 Fix VOR requirements
echo [3/4] Installiere Kernpakete...
pip install "jinja2==3.1.2" --force-reinstall --quiet

:: Restliche Abhaengigkeiten
echo [4/4] Installiere weitere Pakete...
pip install -r requirements_versions.txt --quiet

:: Jinja2 nochmals sicherstellen
pip install "jinja2==3.1.2" --force-reinstall --quiet

echo.
echo *** Installation abgeschlossen! ***
echo *** Starte mit: start.bat        ***
echo.
pause
