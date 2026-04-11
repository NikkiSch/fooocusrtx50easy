@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"
title Fooocus Installation

echo.
echo *** Fooocus - KI-Bildgenerator ***
echo *** Girls Day Installation      ***
echo.

:: Python 3.10 suchen - immer echten .exe-Pfad ermitteln
set PYTHON310=

:: Schritt 1: python im PATH - Version pruefen, dann Pfad holen
for /f "tokens=2" %%v in ('python --version 2^>^&1') do set PYVER=%%v
if "!PYVER:~0,4!"=="3.10" (
    for /f "tokens=*" %%p in ('python -c "import sys; print(sys.executable)" 2^>nul') do set PYTHON310=%%p
    echo [OK] Python 3.10 im PATH gefunden: !PYTHON310!
)

:: Schritt 2: py-Launcher
if "!PYTHON310!"=="" (
    py -3.10 --version >nul 2>&1
    if not errorlevel 1 (
        for /f "tokens=*" %%p in ('py -3.10 -c "import sys; print(sys.executable)" 2^>nul') do set PYTHON310=%%p
        echo [OK] Python 3.10 via py-Launcher gefunden: !PYTHON310!
    )
)

:: Schritt 3: Bekannte Pfade auf allen Laufwerken durchsuchen
if "!PYTHON310!"=="" (
    for %%d in (C D E F G) do (
        if "!PYTHON310!"=="" (
            if exist "%%d:\Python310\python.exe" (
                set PYTHON310=%%d:\Python310\python.exe
                echo [OK] Python 3.10 gefunden: %%d:\Python310\python.exe
            )
        )
        if "!PYTHON310!"=="" (
            if exist "%%d:\Program Files\Python310\python.exe" (
                set PYTHON310=%%d:\Program Files\Python310\python.exe
                echo [OK] Python 3.10 gefunden: %%d:\Program Files\Python310\python.exe
            )
        )
        if "!PYTHON310!"=="" (
            if exist "%%d:\Users\%USERNAME%\AppData\Local\Programs\Python\Python310\python.exe" (
                set PYTHON310=%%d:\Users\%USERNAME%\AppData\Local\Programs\Python\Python310\python.exe
                echo [OK] Python 3.10 gefunden unter AppData.
            )
        )
    )
)

:: Schritt 4: Automatisch herunterladen und installieren
if "!PYTHON310!"=="" (
    echo [INFO] Python 3.10 nicht gefunden - wird installiert...
    curl -L https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe -o python_installer.exe
    if errorlevel 1 (
        echo [FEHLER] Download fehlgeschlagen. Bitte manuell installieren:
        echo https://www.python.org/downloads/release/python-31011/
        pause
        exit /b 1
    )
    python_installer.exe /quiet InstallAllUsers=0 PrependPath=1 Include_pip=1
    del python_installer.exe
    py -3.10 --version >nul 2>&1
    if not errorlevel 1 (
        for /f "tokens=*" %%p in ('py -3.10 -c "import sys; print(sys.executable)" 2^>nul') do set PYTHON310=%%p
        echo [OK] Python 3.10 nach Installation gefunden: !PYTHON310!
    )
)

if "!PYTHON310!"=="" (
    echo [FEHLER] Python 3.10 konnte nicht gefunden oder installiert werden.
    echo Bitte manuell installieren: https://www.python.org/downloads/release/python-31011/
    pause
    exit /b 1
)

echo [OK] Verwende Python: !PYTHON310!

:: In Fooocus-Unterverzeichnis wechseln
cd fooocus

:: Virtuelle Umgebung erstellen
if not exist "fooocus_env" (
    echo [1/5] Erstelle virtuelle Umgebung...
    "!PYTHON310!" -m venv fooocus_env
)

:: Umgebung aktivieren - bei Fehler automatisch neu erstellen
echo [1/5] Aktiviere virtuelle Umgebung...
call fooocus_env\Scripts\activate.bat
if errorlevel 1 (
    echo [WARNUNG] Aktivierung fehlgeschlagen - erstelle neu...
    rmdir /s /q fooocus_env
    "!PYTHON310!" -m venv fooocus_env
    call fooocus_env\Scripts\activate.bat
    if errorlevel 1 (
        echo [FEHLER] Virtuelle Umgebung konnte nicht erstellt werden.
        pause
        exit /b 1
    )
)
echo [OK] Virtuelle Umgebung aktiviert.

:: pip updaten
python -m pip install --upgrade pip --quiet

:: Vorhandene torch-Version entfernen
echo [2/5] Entferne vorhandene PyTorch-Installation...
pip uninstall torch torchvision torchaudio -y >nul 2>&1

:: GPU-Namen abfragen
set GPU_NAME=
for /f "skip=1 delims=" %%a in ('nvidia-smi --query-gpu^=name --format^=csv 2^>nul') do (
    if "!GPU_NAME!"=="" set GPU_NAME=%%a
)
echo [INFO] Erkannte GPU: !GPU_NAME!

:: Torch je nach GPU installieren
echo [3/5] Installiere PyTorch mit GPU-Unterstuetzung...
set USE_CU128=0
echo !GPU_NAME! | findstr /i "RTX 50" >nul 2>&1
if errorlevel 1 (
    set USE_CU128=0
) else (
    set USE_CU128=1
)

if "!USE_CU128!"=="1" (
    echo [INFO] RTX 50xx erkannt - nutze PyTorch cu128
    pip install torch==2.7.0+cu128 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128
) else (
    echo [INFO] RTX 30xx/40xx erkannt - nutze PyTorch cu121
    pip install torch==2.1.0+cu121 torchvision==0.16.0 --extra-index-url https://download.pytorch.org/whl/cu121
)

:: Abhaengigkeiten installieren
echo [4/5] Installiere weitere Pakete...
pip install -r requirements_versions.txt

:: Kritische Versionen sicherstellen
echo [5/5] Pruefe kritische Pakete...
pip install "jinja2==3.1.2" "markupsafe==2.1.5" "ffmpy==0.3.2" "starlette==0.27.0" "fastapi==0.99.0" --force-reinstall --quiet

echo.
echo *** Installation abgeschlossen! ***
echo *** Starte mit: start.bat        ***
echo.
pause
