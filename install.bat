@echo off
chcp 65001 >nul
title Fooocus Installation

echo.
echo  ╔══════════════════════════════════════╗
echo  ║    Fooocus – KI-Bildgenerator        ║
echo  ║    Easy Installation                 ║
echo  ╚══════════════════════════════════════╝
echo.

:: Python prüfen
python --version >nul 2>&1
if errorlevel 1 (
    echo  [FEHLER] Python nicht gefunden!
    echo  Bitte Python 3.10 von python.org installieren.
    pause
    exit /b 1
)
echo  [OK] Python gefunden.

:: Virtuelle Umgebung erstellen
if not exist "fooocus_env" (
    echo  [1/4] Erstelle virtuelle Umgebung...
    python -m venv fooocus_env
)

:: Umgebung aktivieren
call fooocus_env\Scripts\activate.bat

:: pip updaten
python -m pip install --upgrade pip --quiet

:: CUDA-Version erkennen
set CUDA_VER=11
for /f "skip=1 tokens=2 delims=," %%i in ('nvidia-smi --query-gpu=driver_version --format=csv 2^>nul') do (
    set DRIVER=%%i
)
for /f "tokens=9" %%v in ('nvidia-smi ^| findstr /C:"CUDA Version"') do set CUDA_VER=%%v
echo  [INFO] Erkannte CUDA-Version: %CUDA_VER%

:: Torch je nach CUDA installieren
echo  [2/4] Installiere PyTorch mit GPU-Unterstützung...
set CUDA_MAJOR=%CUDA_VER:~0,2%
set CUDA_MINOR=%CUDA_VER:~3,1%

if "%CUDA_MAJOR%"=="12" (
    if "%CUDA_MINOR%" GEQ "8" (
        echo  [INFO] Nutze PyTorch cu128 fuer RTX 50xx
        pip install torch==2.7.0+cu128 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128 --quiet
    ) else (
        echo  [INFO] Nutze PyTorch cu121 fuer RTX 30xx/40xx
        pip install torch==2.1.0+cu121 torchvision==0.16.0 --extra-index-url https://download.pytorch.org/whl/cu121 --quiet
    )
) else (
    echo  [INFO] Nutze PyTorch cu121 als Standard
    pip install torch==2.1.0+cu121 torchvision==0.16.0 --extra-index-url https://download.pytorch.org/whl/cu121 --quiet
)

:: Jinja2 Fix VOR requirements installieren
echo  [3/4] Installiere Kernpakete...
pip install "jinja2==3.1.2" --force-reinstall --quiet

:: Restliche Abhängigkeiten
echo  [4/4] Installiere weitere Pakete...
pip install -r requirements_versions.txt --quiet

:: Jinja2 nochmals sicherstellen (requirements könnte es überschrieben haben)
pip install "jinja2==3.1.2" --force-reinstall --quiet

echo.
echo  ╔══════════════════════════════════════╗
echo  ║  Installation abgeschlossen!         ║
echo  ║  Starte mit: START.bat               ║
echo  ╚══════════════════════════════════════╝
echo.
pause
